#!/usr/bin/env node
/**
 * setup-stitch-oauth.mjs - Browser OAuth for Google Stitch MCP
 * No gcloud CLI required. Direct browser OAuth authentication.
 *
 * Usage: node setup-stitch-oauth.mjs [--check-only]
 */

import http from 'http';
import { URL } from 'url';
import { exec } from 'child_process';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import readline from 'readline';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

// Colors for terminal output
const colors = {
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  reset: '\x1b[0m'
};

// Icons
const icons = {
  check: '✓',
  cross: '✗',
  arrow: '→',
  info: 'ℹ'
};

// Config
const CONFIG = {
  // Google OAuth endpoints
  authUrl: 'https://accounts.google.com/o/oauth2/v2/auth',
  tokenUrl: 'https://oauth2.googleapis.com/token',

  // OAuth settings for Stitch
  clientId: '764086051850-6qr4p6gpi6hn506pt8ejuq83di341hur.apps.googleusercontent.com',
  // This is Google's public OAuth client for CLI tools (same as gcloud uses)
  clientSecret: 'd-FL95Q19q7MQmFpd7hHD0Ty',

  // Scopes needed for Stitch
  scopes: [
    'https://www.googleapis.com/auth/cloud-platform',
    'https://www.googleapis.com/auth/userinfo.email'
  ],

  // Local callback server
  callbackPort: 8085,
  callbackPath: '/oauth/callback',

  // Token storage
  tokenFile: path.join(process.env.HOME, '.config', 'stitch-mcp', 'credentials.json')
};

// Utility functions
function print(message, color = 'reset') {
  console.log(`${colors[color]}${message}${colors.reset}`);
}

function printHeader() {
  console.log('');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', 'blue');
  print('  Google Stitch MCP - Browser OAuth Setup', 'blue');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', 'blue');
  console.log('');
}

function printStep(message) {
  print(`${icons.arrow} ${message}`, 'yellow');
}

function printSuccess(message) {
  print(`${icons.check} ${message}`, 'green');
}

function printError(message) {
  print(`${icons.cross} ${message}`, 'red');
}

function printInfo(message) {
  print(`${icons.info} ${message}`, 'blue');
}

// Open URL in browser
function openBrowser(url) {
  const platform = process.platform;
  let cmd;

  switch (platform) {
    case 'darwin':
      cmd = `open "${url}"`;
      break;
    case 'win32':
      cmd = `start "" "${url}"`;
      break;
    default:
      cmd = `xdg-open "${url}"`;
  }

  exec(cmd, (error) => {
    if (error) {
      printError(`Failed to open browser. Please visit manually:`);
      console.log(url);
    }
  });
}

// Generate OAuth URL
function generateAuthUrl(state) {
  const params = new URLSearchParams({
    client_id: CONFIG.clientId,
    redirect_uri: `http://localhost:${CONFIG.callbackPort}${CONFIG.callbackPath}`,
    response_type: 'code',
    scope: CONFIG.scopes.join(' '),
    access_type: 'offline',
    prompt: 'consent',
    state: state
  });

  return `${CONFIG.authUrl}?${params.toString()}`;
}

// Exchange authorization code for tokens
async function exchangeCodeForTokens(code) {
  const params = new URLSearchParams({
    client_id: CONFIG.clientId,
    client_secret: CONFIG.clientSecret,
    code: code,
    grant_type: 'authorization_code',
    redirect_uri: `http://localhost:${CONFIG.callbackPort}${CONFIG.callbackPath}`
  });

  const response = await fetch(CONFIG.tokenUrl, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    },
    body: params.toString()
  });

  if (!response.ok) {
    const error = await response.text();
    throw new Error(`Token exchange failed: ${error}`);
  }

  return response.json();
}

// Refresh access token
async function refreshAccessToken(refreshToken) {
  const params = new URLSearchParams({
    client_id: CONFIG.clientId,
    client_secret: CONFIG.clientSecret,
    refresh_token: refreshToken,
    grant_type: 'refresh_token'
  });

  const response = await fetch(CONFIG.tokenUrl, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    },
    body: params.toString()
  });

  if (!response.ok) {
    throw new Error('Token refresh failed');
  }

  return response.json();
}

// Save tokens to file
function saveTokens(tokens) {
  const dir = path.dirname(CONFIG.tokenFile);

  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }

  const data = {
    ...tokens,
    saved_at: new Date().toISOString()
  };

  fs.writeFileSync(CONFIG.tokenFile, JSON.stringify(data, null, 2));
  fs.chmodSync(CONFIG.tokenFile, 0o600); // Secure permissions
}

// Load saved tokens
function loadTokens() {
  try {
    if (fs.existsSync(CONFIG.tokenFile)) {
      const data = JSON.parse(fs.readFileSync(CONFIG.tokenFile, 'utf8'));
      return data;
    }
  } catch (error) {
    // Ignore errors
  }
  return null;
}

// Check if tokens are valid
async function checkAuth() {
  printStep('Checking authentication status...');

  const tokens = loadTokens();

  if (!tokens || !tokens.refresh_token) {
    printError('Not authenticated');
    return false;
  }

  try {
    // Try to refresh the token to verify it's valid
    const newTokens = await refreshAccessToken(tokens.refresh_token);

    // Save updated tokens
    saveTokens({
      ...tokens,
      access_token: newTokens.access_token,
      expires_in: newTokens.expires_in
    });

    printSuccess('Authenticated (token refreshed)');
    return true;
  } catch (error) {
    printError('Authentication expired');
    return false;
  }
}

// Start OAuth flow
function startOAuthFlow() {
  return new Promise((resolve, reject) => {
    const state = Math.random().toString(36).substring(7);

    // Create callback server
    const server = http.createServer(async (req, res) => {
      const url = new URL(req.url, `http://localhost:${CONFIG.callbackPort}`);

      if (url.pathname === CONFIG.callbackPath) {
        const code = url.searchParams.get('code');
        const returnedState = url.searchParams.get('state');
        const error = url.searchParams.get('error');

        if (error) {
          res.writeHead(400, { 'Content-Type': 'text/html' });
          res.end(`
            <html>
              <body style="font-family: system-ui; text-align: center; padding-top: 50px;">
                <h1 style="color: #dc2626;">❌ Authentication Failed</h1>
                <p>Error: ${error}</p>
                <p>You can close this window.</p>
              </body>
            </html>
          `);
          server.close();
          reject(new Error(error));
          return;
        }

        if (returnedState !== state) {
          res.writeHead(400, { 'Content-Type': 'text/html' });
          res.end(`
            <html>
              <body style="font-family: system-ui; text-align: center; padding-top: 50px;">
                <h1 style="color: #dc2626;">❌ Invalid State</h1>
                <p>Security check failed. Please try again.</p>
              </body>
            </html>
          `);
          server.close();
          reject(new Error('Invalid state'));
          return;
        }

        try {
          // Exchange code for tokens
          const tokens = await exchangeCodeForTokens(code);

          // Save tokens
          saveTokens(tokens);

          res.writeHead(200, { 'Content-Type': 'text/html' });
          res.end(`
            <html>
              <body style="font-family: system-ui; text-align: center; padding-top: 50px;">
                <h1 style="color: #16a34a;">✓ Authentication Successful!</h1>
                <p>You can close this window and return to the terminal.</p>
                <script>setTimeout(() => window.close(), 2000);</script>
              </body>
            </html>
          `);

          server.close();
          resolve(tokens);
        } catch (err) {
          res.writeHead(500, { 'Content-Type': 'text/html' });
          res.end(`
            <html>
              <body style="font-family: system-ui; text-align: center; padding-top: 50px;">
                <h1 style="color: #dc2626;">❌ Token Exchange Failed</h1>
                <p>${err.message}</p>
              </body>
            </html>
          `);
          server.close();
          reject(err);
        }
      }
    });

    server.listen(CONFIG.callbackPort, () => {
      const authUrl = generateAuthUrl(state);

      console.log('');
      printInfo('Opening browser for authentication...');
      printInfo('If browser does not open, visit this URL:');
      console.log('');
      console.log(authUrl);
      console.log('');

      openBrowser(authUrl);
    });

    server.on('error', (err) => {
      if (err.code === 'EADDRINUSE') {
        reject(new Error(`Port ${CONFIG.callbackPort} is in use. Please close other applications.`));
      } else {
        reject(err);
      }
    });

    // Timeout after 5 minutes
    setTimeout(() => {
      server.close();
      reject(new Error('Authentication timed out'));
    }, 5 * 60 * 1000);
  });
}

// Prompt for project ID
async function promptProjectId() {
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
  });

  return new Promise((resolve) => {
    console.log('');
    printInfo('Enter your GCP Project ID for Stitch:');
    printInfo('(You can find this in Google Cloud Console)');
    console.log('');

    rl.question('Project ID: ', (answer) => {
      rl.close();
      resolve(answer.trim());
    });
  });
}

// Save project configuration
function saveProjectConfig(projectId) {
  const configDir = path.dirname(CONFIG.tokenFile);
  const configFile = path.join(configDir, 'config.json');

  const config = {
    project_id: projectId,
    saved_at: new Date().toISOString()
  };

  fs.writeFileSync(configFile, JSON.stringify(config, null, 2));
}

// Load project configuration
function loadProjectConfig() {
  const configDir = path.dirname(CONFIG.tokenFile);
  const configFile = path.join(configDir, 'config.json');

  try {
    if (fs.existsSync(configFile)) {
      return JSON.parse(fs.readFileSync(configFile, 'utf8'));
    }
  } catch (error) {
    // Ignore
  }
  return null;
}

// Check project
function checkProject() {
  printStep('Checking GCP project...');

  const config = loadProjectConfig();

  if (config && config.project_id) {
    printSuccess(`Project set: ${config.project_id}`);
    return true;
  }

  printError('No project configured');
  return false;
}

// Print summary
function printSummary(authOk, projectOk) {
  console.log('');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', 'blue');
  print('  Setup Summary', 'blue');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', 'blue');
  console.log('');

  if (authOk) {
    print(`  ${icons.check} GCP Authentication (Browser OAuth)`, 'green');
  } else {
    print(`  ${icons.cross} GCP Authentication`, 'red');
  }

  if (projectOk) {
    print(`  ${icons.check} GCP Project`, 'green');
  } else {
    print(`  ${icons.cross} GCP Project`, 'red');
  }

  console.log('');

  if (authOk && projectOk) {
    printSuccess('Stitch MCP is ready to use!');
    console.log('');
    console.log('You can now use Google Stitch in spec-it:');
    console.log('  /frontend-skills:spec-it');
    console.log('  → Select "Google Stitch" for UI design');
  } else {
    print('Some components need setup.', 'yellow');
    console.log('Run this script again without --check-only to fix.');
  }

  console.log('');
  console.log('Token location:', CONFIG.tokenFile);
  console.log('');
}

// Main
async function main() {
  printHeader();

  const checkOnly = process.argv.includes('--check-only');

  // Check authentication
  let authOk = await checkAuth();

  if (!authOk && !checkOnly) {
    printStep('Starting browser OAuth authentication...');

    try {
      await startOAuthFlow();
      printSuccess('Authentication successful!');
      authOk = true;
    } catch (error) {
      printError(`Authentication failed: ${error.message}`);
    }
  }

  // Check project
  let projectOk = checkProject();

  if (!projectOk && !checkOnly && authOk) {
    const projectId = await promptProjectId();

    if (projectId) {
      saveProjectConfig(projectId);
      printSuccess(`Project set: ${projectId}`);
      projectOk = true;
    }
  }

  // Summary
  printSummary(authOk, projectOk);

  process.exit(authOk && projectOk ? 0 : 1);
}

main().catch((error) => {
  printError(`Fatal error: ${error.message}`);
  process.exit(1);
});
