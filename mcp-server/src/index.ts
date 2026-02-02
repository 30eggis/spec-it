#!/usr/bin/env node

import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
  ListResourcesRequestSchema,
  ReadResourceRequestSchema,
  ListPromptsRequestSchema,
  GetPromptRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";

import { tools, handleToolCall } from "./tools/index.js";
import { resources, handleResourceRead } from "./resources/index.js";
import { prompts, handleGetPrompt } from "./prompts/index.js";

const server = new Server(
  {
    name: "spec-it-mcp",
    version: "1.0.0",
  },
  {
    capabilities: {
      tools: {},
      resources: {},
      prompts: {},
    },
  }
);

// List available tools
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return { tools };
});

// Handle tool calls
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  return handleToolCall(request.params.name, request.params.arguments ?? {});
});

// List available resources
server.setRequestHandler(ListResourcesRequestSchema, async () => {
  return { resources: await resources() };
});

// Read resource content
server.setRequestHandler(ReadResourceRequestSchema, async (request) => {
  return handleResourceRead(request.params.uri);
});

// List available prompts
server.setRequestHandler(ListPromptsRequestSchema, async () => {
  return { prompts };
});

// Get prompt content
server.setRequestHandler(GetPromptRequestSchema, async (request) => {
  return handleGetPrompt(request.params.name, request.params.arguments ?? {});
});

// Start the server
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("spec-it MCP server running on stdio");
}

main().catch((error) => {
  console.error("Fatal error:", error);
  process.exit(1);
});
