const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const GITHUB_TOKEN = process.env.GITHUB_TOKEN;
const GITHUB_REPOSITORY = process.env.GITHUB_REPOSITORY || 'owner/repo';
const MODEL_ENDPOINT = 'https://models.inference.ai.azure.com/chat/completions';
const MODEL_NAME = 'gpt-4o';

function getLatestTag() {
  try {
    const tag = execSync('git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0"', { encoding: 'utf-8' }).trim();
    return tag;
  } catch {
    return 'v0.0.0';
  }
}

function getModuleSource(moduleDir, tag) {
  const modulePath = moduleDir.replace(/^\.\//, '');
  return `git::https://github.com/${GITHUB_REPOSITORY}.git//${modulePath}?ref=${tag}`;
}

async function callGitHubModel(prompt, systemPrompt) {
  const response = await fetch(MODEL_ENDPOINT, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${GITHUB_TOKEN}`,
    },
    body: JSON.stringify({
      model: MODEL_NAME,
      messages: [
        { role: 'system', content: systemPrompt },
        { role: 'user', content: prompt },
      ],
      temperature: 0.1,
      max_tokens: 2000,
    }),
  });

  if (!response.ok) {
    const error = await response.text();
    throw new Error(`GitHub Models API error: ${response.status} - ${error}`);
  }

  const data = await response.json();
  return data.choices[0].message.content;
}

function readTerraformFiles(moduleDir) {
  const tfFiles = {};
  const files = fs.readdirSync(moduleDir);

  for (const file of files) {
    if (file.endsWith('.tf')) {
      const filePath = path.join(moduleDir, file);
      tfFiles[file] = fs.readFileSync(filePath, 'utf-8');
    }
  }

  return tfFiles;
}

function extractVariableNames(tfFiles) {
  const variables = [];
  const variableRegex = /variable\s+"([^"]+)"/g;

  for (const content of Object.values(tfFiles)) {
    let match;
    while ((match = variableRegex.exec(content)) !== null) {
      variables.push(match[1]);
    }
  }

  return variables;
}

function extractOutputNames(tfFiles) {
  const outputs = [];
  const outputRegex = /output\s+"([^"]+)"/g;

  for (const content of Object.values(tfFiles)) {
    let match;
    while ((match = outputRegex.exec(content)) !== null) {
      outputs.push(match[1]);
    }
  }

  return outputs;
}

function extractTfDocsSection(readmeContent) {
  const beginMarker = '<!-- BEGIN_TF_DOCS -->';
  const endMarker = '<!-- END_TF_DOCS -->';

  const beginIndex = readmeContent.indexOf(beginMarker);
  const endIndex = readmeContent.indexOf(endMarker);

  if (beginIndex !== -1 && endIndex !== -1) {
    return readmeContent.substring(beginIndex, endIndex + endMarker.length);
  }

  return `${beginMarker}\n${endMarker}`;
}

function getModuleName(moduleDir) {
  const parts = moduleDir.split(path.sep);
  return parts[parts.length - 1];
}

function capitalizeFirst(str) {
  return str.charAt(0).toUpperCase() + str.slice(1);
}

async function generateReadme(moduleDir, latestTag) {
  const tfFiles = readTerraformFiles(moduleDir);
  const moduleName = getModuleName(moduleDir);
  const moduleSource = getModuleSource(moduleDir, latestTag);
  const variables = extractVariableNames(tfFiles);
  const outputs = extractOutputNames(tfFiles);

  const readmePath = path.join(moduleDir, 'README.md');
  let tfDocsSection = '<!-- BEGIN_TF_DOCS -->\n<!-- END_TF_DOCS -->';

  if (fs.existsSync(readmePath)) {
    const existingReadme = fs.readFileSync(readmePath, 'utf-8');
    tfDocsSection = extractTfDocsSection(existingReadme);
  }

  const tfContext = Object.entries(tfFiles)
    .map(([filename, content]) => `### ${filename}\n\`\`\`hcl\n${content}\n\`\`\``)
    .join('\n\n');

  const systemPrompt = `You are a technical documentation generator. You MUST respond with ONLY valid JSON, no markdown, no code blocks, no explanations. Your response must be parseable by JSON.parse().`;

  const prompt = `Analyze this Terraform module and return a JSON object with these exact keys:

{
  "description": "One sentence describing what this module does",
  "features": ["feature 1", "feature 2", "feature 3"]
}

Rules:
- description: One clear sentence, no period at the end
- features: Array of 3-7 strings, each starting with a verb (Creates, Configures, Supports, etc.)
- Only include features that exist in the actual code
- Be concise and professional

Terraform files:
${tfContext}

Respond with ONLY the JSON object:`;

  console.log(`Generating README for ${moduleDir}...`);
  console.log(`  Source: ${moduleSource}`);
  console.log(`  Variables: ${variables.join(', ')}`);
  console.log(`  Outputs: ${outputs.join(', ')}`);

  const aiResponse = await callGitHubModel(prompt, systemPrompt);

  let parsed;
  try {
    const cleanResponse = aiResponse.replace(/```json\n?/g, '').replace(/```\n?/g, '').trim();
    parsed = JSON.parse(cleanResponse);
  } catch (e) {
    console.error('Failed to parse AI response:', aiResponse);
    throw new Error(`Failed to parse AI response: ${e.message}`);
  }

  const variablesBlock = variables.map(v => `  ${v} = var.${v}`).join('\n');
  const outputsList = outputs.map(o => `# - module.${moduleName}.${o}`).join('\n');
  const firstOutput = outputs[0] || 'id';

  const readme = `# ${capitalizeFirst(moduleName)}

${parsed.description}

## Features

${parsed.features.map(f => `- ${f}`).join('\n')}

## Usage

### Basic Example

\`\`\`hcl
module "${moduleName}" {
  source = "${moduleSource}"

${variablesBlock}
}
\`\`\`

### Using Outputs

\`\`\`hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.${moduleName}.${firstOutput}
}

# Available outputs:
${outputsList}
\`\`\`

${tfDocsSection}
`;

  fs.writeFileSync(readmePath, readme);
  console.log(`README generated: ${readmePath}`);
}

async function main() {
  const moduleDirs = process.argv.slice(2);

  if (moduleDirs.length === 0) {
    console.log('No module directories provided');
    process.exit(0);
  }

  const latestTag = getLatestTag();
  console.log(`Latest tag: ${latestTag}`);

  for (const moduleDir of moduleDirs) {
    if (fs.existsSync(moduleDir)) {
      try {
        await generateReadme(moduleDir, latestTag);
      } catch (error) {
        console.error(`Error generating README for ${moduleDir}:`, error.message);
        process.exit(1);
      }
    } else {
      console.warn(`Directory not found: ${moduleDir}`);
    }
  }
}

main();
