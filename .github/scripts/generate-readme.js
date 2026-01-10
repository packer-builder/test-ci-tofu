const fs = require('fs');
const path = require('path');

const GITHUB_TOKEN = process.env.GITHUB_TOKEN;
const MODEL_ENDPOINT = 'https://models.inference.ai.azure.com/chat/completions';
const MODEL_NAME = 'gpt-4o';

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

async function generateReadme(moduleDir) {
  const tfFiles = readTerraformFiles(moduleDir);
  const moduleName = getModuleName(moduleDir);

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
- For the Usage section, use realistic example values based on the actual variables defined
- If a variable has a default value, you can omit it from the basic example
- The Features section should only list capabilities that are actually implemented in the code`;

  const prompt = `Analyze the following Terraform module and generate a README.md with these sections:

1. # Module Name (use "${moduleName}" capitalized appropriately)
2. A brief description (1-2 sentences) of what this module does
3. ## Features - bullet list of actual features based on what the code creates
4. ## Usage
   ### Basic Example - a working example showing how to use this module with realistic values
   ### Using Outputs - show how to reference the module outputs (only outputs that exist in the code)

IMPORTANT:
- DO NOT include an Inputs or Outputs table - that will be auto-generated
- End the README with the placeholder: <!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
- Only use variables and outputs that actually exist in the code

Here are the Terraform files:

${tfContext}

Generate the README content:`;

  console.log(`Generating README for ${moduleDir}...`);

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

  for (const moduleDir of moduleDirs) {
    if (fs.existsSync(moduleDir)) {
      try {
        await generateReadme(moduleDir);
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
