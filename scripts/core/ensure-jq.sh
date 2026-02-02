#!/bin/bash

ensure_jq() {
  if command -v jq >/dev/null 2>&1; then
    return 0
  fi

  local os_type
  os_type="$(uname -s)"

  case "$os_type" in
    Darwin)
      if command -v brew >/dev/null 2>&1; then
        brew install jq >/dev/null 2>&1 || true
      fi
      ;;
    Linux)
      if command -v apt-get >/dev/null 2>&1; then
        if [ "$(id -u)" = "0" ]; then
          apt-get update -y >/dev/null 2>&1 || true
          apt-get install -y jq >/dev/null 2>&1 || true
        elif command -v sudo >/dev/null 2>&1 && sudo -n true >/dev/null 2>&1; then
          sudo apt-get update -y >/dev/null 2>&1 || true
          sudo apt-get install -y jq >/dev/null 2>&1 || true
        fi
      elif command -v dnf >/dev/null 2>&1; then
        if [ "$(id -u)" = "0" ]; then
          dnf install -y jq >/dev/null 2>&1 || true
        elif command -v sudo >/dev/null 2>&1 && sudo -n true >/dev/null 2>&1; then
          sudo dnf install -y jq >/dev/null 2>&1 || true
        fi
      elif command -v yum >/dev/null 2>&1; then
        if [ "$(id -u)" = "0" ]; then
          yum install -y jq >/dev/null 2>&1 || true
        elif command -v sudo >/dev/null 2>&1 && sudo -n true >/dev/null 2>&1; then
          sudo yum install -y jq >/dev/null 2>&1 || true
        fi
      elif command -v pacman >/dev/null 2>&1; then
        if [ "$(id -u)" = "0" ]; then
          pacman -Sy --noconfirm jq >/dev/null 2>&1 || true
        elif command -v sudo >/dev/null 2>&1 && sudo -n true >/dev/null 2>&1; then
          sudo pacman -Sy --noconfirm jq >/dev/null 2>&1 || true
        fi
      elif command -v apk >/dev/null 2>&1; then
        if [ "$(id -u)" = "0" ]; then
          apk add --no-cache jq >/dev/null 2>&1 || true
        elif command -v sudo >/dev/null 2>&1 && sudo -n true >/dev/null 2>&1; then
          sudo apk add --no-cache jq >/dev/null 2>&1 || true
        fi
      fi
      ;;
    MINGW*|MSYS*|CYGWIN*)
      local winget_cmd=""
      if command -v winget.exe >/dev/null 2>&1; then
        winget_cmd="winget.exe"
      elif command -v winget >/dev/null 2>&1; then
        winget_cmd="winget"
      fi

      if [ -n "$winget_cmd" ]; then
        "$winget_cmd" install --id jqlang.jq -e --source winget --scope user --accept-package-agreements --accept-source-agreements >/dev/null 2>&1 || true
      fi

      if ! command -v jq >/dev/null 2>&1 && command -v scoop >/dev/null 2>&1; then
        scoop install jq >/dev/null 2>&1 || true
      fi

      if ! command -v jq >/dev/null 2>&1 && command -v choco >/dev/null 2>&1; then
        choco install jq -y >/dev/null 2>&1 || true
      fi
      ;;
  esac

  if command -v jq >/dev/null 2>&1; then
    return 0
  fi

  echo "ERROR: jq is required but could not be installed automatically." >&2
  case "$os_type" in
    Darwin)
      echo "Install with: brew install jq" >&2
      ;;
    Linux)
      echo "Install with: sudo apt-get install -y jq (or your distro package manager)" >&2
      ;;
    MINGW*|MSYS*|CYGWIN*)
      echo "Install with: winget install --id jqlang.jq -e --scope user --accept-package-agreements --accept-source-agreements" >&2
      echo "Or: scoop install jq" >&2
      echo "Or: choco install jq -y" >&2
      ;;
  esac
  return 1
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  ensure_jq
fi
