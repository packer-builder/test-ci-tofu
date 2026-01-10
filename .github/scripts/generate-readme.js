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
  // Remove leading ./ if present
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
      temperature: 0.3,
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

async function generateReadme(moduleDir, latestTag) {
  const tfFiles = readTerraformFiles(moduleDir);
  const moduleName = getModuleName(moduleDir);
  const moduleSource = getModuleSource(moduleDir, latestTag);
  const variables = extractVariableNames(tfFiles);

  // Check for existing README to preserve TF_DOCS section
  const readmePath = path.join(moduleDir, 'README.md');
  let tfDocsSection = '<!-- BEGIN_TF_DOCS -->\n<!-- END_TF_DOCS -->';

  if (fs.existsSync(readmePath)) {
    const existingReadme = fs.readFileSync(readmePath, 'utf-8');
    tfDocsSection = extractTfDocsSection(existingReadme);
  }

  // Build context from terraform files
  const tfContext = Object.entries(tfFiles)
    .map(([filename, content]) => `### ${filename}\n\`\`\`hcl\n${content}\n\`\`\``)
    .join('\n\n');

  const systemPrompt = `You are a technical documentation expert specializing in Terraform/OpenTofu modules.
Your task is to generate clear, concise README documentation in English.

Rules:
- Write in English only
- Be concise and professional
- Only document what actually exists in the code - DO NOT invent variables, outputs, or features
- The Features section should only list capabilities that are actually implemented in the code`;

  const prompt = `Analyze the following Terraform module and generate a README.md with these sections:

1. # Module Name (use "${moduleName}" capitalized appropriately)
2. A brief description (1-2 sentences) of what this module does
3. ## Features - bullet list of actual features based on what the code creates
4. ## Usage
   ### Basic Example - a working example showing how to use this module
   ### Using Outputs - show how to reference the module outputs (only outputs that exist in the code)

CRITICAL REQUIREMENTS FOR THE USAGE SECTION:

1. The source MUST be exactly: "${moduleSource}"

2. For variables in the Basic Example, use var.variable_name format. Example:
   \`\`\`hcl
   module "${moduleName}" {
     source = "${moduleSource}"

     vpc_cidr = var.vpc_cidr
     vpc_name = var.vpc_name
   }
   \`\`\`

3. Available variables from variables.tf: ${variables.join(', ')}

4. DO NOT include an Inputs or Outputs table - that will be auto-generated

5. End the README with the placeholder:
<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

Here are the Terraform files:

${tfContext}

Generate the README content:`;

  console.log(`Generating README for ${moduleDir}...`);
  console.log(`  Source: ${moduleSource}`);
  console.log(`  Variables: ${variables.join(', ')}`);

  const readmeContent = await callGitHubModel(prompt, systemPrompt);

  // Replace the TF_DOCS placeholder with the actual section from terraform-docs
  const finalReadme = readmeContent.replace(
    /<!-- BEGIN_TF_DOCS -->[\s\S]*<!-- END_TF_DOCS -->/,
    tfDocsSection
  );

  fs.writeFileSync(readmePath, finalReadme);
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
