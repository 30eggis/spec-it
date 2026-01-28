#!/usr/bin/env python3
"""
API Discovery Script for agentation-api-binder

Scans a project directory to find:
1. Frontend API calls (axios, fetch, ky, etc.)
2. Backend API endpoints (Express, FastAPI, NestJS, etc.)

Usage:
    python discover_apis.py <project_path> [--output json|markdown]
"""

import os
import re
import json
import argparse
from pathlib import Path
from dataclasses import dataclass, asdict
from typing import Optional

@dataclass
class APICall:
    """Represents a discovered API call or endpoint"""
    type: str  # 'frontend' or 'backend'
    method: str  # GET, POST, PUT, DELETE, PATCH
    path: str  # API path/URL
    file: str  # Source file
    line: int  # Line number
    library: str  # axios, fetch, express, etc.
    function_name: Optional[str] = None  # Function/handler name if available

# Frontend patterns
FRONTEND_PATTERNS = {
    'axios': [
        r'axios\.(get|post|put|delete|patch)\s*\(\s*[\'"`]([^\'"`]+)[\'"`]',
        r'axios\s*\(\s*\{[^}]*method:\s*[\'"`](\w+)[\'"`][^}]*url:\s*[\'"`]([^\'"`]+)[\'"`]',
        r'axios\s*\(\s*\{[^}]*url:\s*[\'"`]([^\'"`]+)[\'"`][^}]*method:\s*[\'"`](\w+)[\'"`]',
    ],
    'fetch': [
        r'fetch\s*\(\s*[\'"`]([^\'"`]+)[\'"`]\s*,\s*\{[^}]*method:\s*[\'"`](\w+)[\'"`]',
        r'fetch\s*\(\s*[\'"`]([^\'"`]+)[\'"`]\s*\)',  # GET by default
    ],
    'ky': [
        r'ky\.(get|post|put|delete|patch)\s*\(\s*[\'"`]([^\'"`]+)[\'"`]',
    ],
    'got': [
        r'got\.(get|post|put|delete|patch)\s*\(\s*[\'"`]([^\'"`]+)[\'"`]',
    ],
    'superagent': [
        r'superagent\.(get|post|put|delete|patch)\s*\(\s*[\'"`]([^\'"`]+)[\'"`]',
    ],
    'swr': [
        r'useSWR\s*\(\s*[\'"`]([^\'"`]+)[\'"`]',
    ],
    'react-query': [
        r'useQuery\s*\(\s*\[[^\]]*\]\s*,\s*\(\)\s*=>\s*fetch\s*\(\s*[\'"`]([^\'"`]+)[\'"`]',
        r'useMutation\s*\(\s*\{[^}]*mutationFn:[^}]*fetch\s*\(\s*[\'"`]([^\'"`]+)[\'"`]',
    ],
}

# Backend patterns
BACKEND_PATTERNS = {
    'express': [
        r'(app|router)\.(get|post|put|delete|patch)\s*\(\s*[\'"`]([^\'"`]+)[\'"`]',
    ],
    'fastapi': [
        r'@(app|router)\.(get|post|put|delete|patch)\s*\(\s*[\'"`]([^\'"`]+)[\'"`]',
    ],
    'nestjs': [
        r'@(Get|Post|Put|Delete|Patch)\s*\(\s*[\'"`]?([^\'"`\)]*)[\'"`]?\s*\)',
    ],
    'nextjs-api': [
        r'export\s+(async\s+)?function\s+(GET|POST|PUT|DELETE|PATCH)\s*\(',
        r'export\s+const\s+(GET|POST|PUT|DELETE|PATCH)\s*=',
    ],
    'hono': [
        r'(app|router)\.(get|post|put|delete|patch)\s*\(\s*[\'"`]([^\'"`]+)[\'"`]',
    ],
}

IGNORED_DIRS = {
    'node_modules', '.git', '.next', 'dist', 'build',
    '__pycache__', '.venv', 'venv', 'coverage'
}

FRONTEND_EXTENSIONS = {'.js', '.jsx', '.ts', '.tsx', '.mjs'}
BACKEND_EXTENSIONS = {'.js', '.ts', '.py', '.mjs'}


def should_skip_dir(dir_name: str) -> bool:
    return dir_name in IGNORED_DIRS or dir_name.startswith('.')


def find_frontend_apis(file_path: Path, content: str) -> list[APICall]:
    """Find frontend API calls in a file"""
    apis = []
    lines = content.split('\n')

    for library, patterns in FRONTEND_PATTERNS.items():
        for pattern in patterns:
            for match in re.finditer(pattern, content, re.IGNORECASE | re.MULTILINE):
                # Calculate line number
                pos = match.start()
                line_num = content[:pos].count('\n') + 1

                groups = match.groups()
                if library == 'fetch' and len(groups) == 1:
                    method, path = 'GET', groups[0]
                elif library in ('swr', 'react-query') and len(groups) == 1:
                    method, path = 'GET', groups[0]
                elif len(groups) >= 2:
                    if groups[0].upper() in ('GET', 'POST', 'PUT', 'DELETE', 'PATCH'):
                        method, path = groups[0].upper(), groups[1]
                    else:
                        path, method = groups[0], groups[1].upper() if len(groups) > 1 else 'GET'
                else:
                    continue

                apis.append(APICall(
                    type='frontend',
                    method=method.upper(),
                    path=path,
                    file=str(file_path),
                    line=line_num,
                    library=library
                ))

    return apis


def find_backend_apis(file_path: Path, content: str) -> list[APICall]:
    """Find backend API endpoints in a file"""
    apis = []

    # Detect Next.js API routes from file path
    if '/app/api/' in str(file_path) or '/pages/api/' in str(file_path):
        # Extract route from file path
        path_str = str(file_path)
        if '/app/api/' in path_str:
            route = path_str.split('/app/api/')[-1]
            route = '/api/' + route.replace('/route.ts', '').replace('/route.js', '')
        else:
            route = path_str.split('/pages/api/')[-1]
            route = '/api/' + route.replace('.ts', '').replace('.js', '')

        # Find exported HTTP methods
        for match in re.finditer(r'export\s+(async\s+)?function\s+(GET|POST|PUT|DELETE|PATCH)', content):
            method = match.group(2)
            line_num = content[:match.start()].count('\n') + 1
            apis.append(APICall(
                type='backend',
                method=method,
                path=route.replace('[', '{').replace(']', '}'),
                file=str(file_path),
                line=line_num,
                library='nextjs-api'
            ))

        for match in re.finditer(r'export\s+const\s+(GET|POST|PUT|DELETE|PATCH)\s*=', content):
            method = match.group(1)
            line_num = content[:match.start()].count('\n') + 1
            apis.append(APICall(
                type='backend',
                method=method,
                path=route.replace('[', '{').replace(']', '}'),
                file=str(file_path),
                line=line_num,
                library='nextjs-api'
            ))

    # Other backend frameworks
    for library, patterns in BACKEND_PATTERNS.items():
        if library == 'nextjs-api':
            continue  # Already handled above

        for pattern in patterns:
            for match in re.finditer(pattern, content, re.IGNORECASE | re.MULTILINE):
                groups = match.groups()
                line_num = content[:match.start()].count('\n') + 1

                if library == 'nestjs':
                    method = groups[0].upper()
                    path = groups[1] if groups[1] else '/'
                elif len(groups) >= 3:
                    method = groups[1].upper()
                    path = groups[2]
                elif len(groups) >= 2:
                    method = groups[0].upper()
                    path = groups[1]
                else:
                    continue

                apis.append(APICall(
                    type='backend',
                    method=method,
                    path=path,
                    file=str(file_path),
                    line=line_num,
                    library=library
                ))

    return apis


def scan_directory(project_path: Path) -> list[APICall]:
    """Scan a directory for all API calls and endpoints"""
    all_apis = []

    for root, dirs, files in os.walk(project_path):
        # Filter out ignored directories
        dirs[:] = [d for d in dirs if not should_skip_dir(d)]

        for file in files:
            file_path = Path(root) / file
            suffix = file_path.suffix.lower()

            if suffix not in FRONTEND_EXTENSIONS | BACKEND_EXTENSIONS:
                continue

            try:
                content = file_path.read_text(encoding='utf-8')
            except (UnicodeDecodeError, PermissionError):
                continue

            # Check frontend patterns
            if suffix in FRONTEND_EXTENSIONS:
                all_apis.extend(find_frontend_apis(file_path, content))

            # Check backend patterns
            if suffix in BACKEND_EXTENSIONS:
                all_apis.extend(find_backend_apis(file_path, content))

    return all_apis


def format_markdown(apis: list[APICall], project_path: str) -> str:
    """Format API list as markdown"""
    frontend = [a for a in apis if a.type == 'frontend']
    backend = [a for a in apis if a.type == 'backend']

    output = f"# API Discovery Report\n\n"
    output += f"**Project:** `{project_path}`\n"
    output += f"**Total APIs Found:** {len(apis)} (Frontend: {len(frontend)}, Backend: {len(backend)})\n\n"

    if backend:
        output += "## Backend Endpoints\n\n"
        output += "| Method | Path | Library | File | Line |\n"
        output += "|--------|------|---------|------|------|\n"
        for api in sorted(backend, key=lambda x: (x.path, x.method)):
            rel_path = os.path.relpath(api.file, project_path)
            output += f"| `{api.method}` | `{api.path}` | {api.library} | `{rel_path}` | {api.line} |\n"
        output += "\n"

    if frontend:
        output += "## Frontend API Calls\n\n"
        output += "| Method | Path | Library | File | Line |\n"
        output += "|--------|------|---------|------|------|\n"
        for api in sorted(frontend, key=lambda x: (x.path, x.method)):
            rel_path = os.path.relpath(api.file, project_path)
            output += f"| `{api.method}` | `{api.path}` | {api.library} | `{rel_path}` | {api.line} |\n"

    return output


def main():
    parser = argparse.ArgumentParser(description='Discover APIs in a project')
    parser.add_argument('project_path', help='Path to the project directory')
    parser.add_argument('--output', choices=['json', 'markdown'], default='markdown',
                        help='Output format (default: markdown)')
    args = parser.parse_args()

    project_path = Path(args.project_path).resolve()

    if not project_path.exists():
        print(f"Error: Path '{project_path}' does not exist")
        return 1

    apis = scan_directory(project_path)

    if args.output == 'json':
        print(json.dumps([asdict(api) for api in apis], indent=2))
    else:
        print(format_markdown(apis, str(project_path)))

    return 0


if __name__ == '__main__':
    exit(main())
