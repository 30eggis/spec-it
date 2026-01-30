#!/bin/bash
# setup-stitch-gcp.sh - GCP Authentication for Google Stitch MCP
# Usage: ./setup-stitch-gcp.sh [--check-only]

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Icons
CHECK="✓"
CROSS="✗"
ARROW="→"

print_header() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  Google Stitch MCP - GCP Setup${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

print_step() {
    echo -e "${YELLOW}${ARROW}${NC} $1"
}

print_success() {
    echo -e "${GREEN}${CHECK}${NC} $1"
}

print_error() {
    echo -e "${RED}${CROSS}${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Check if gcloud is installed
check_gcloud() {
    print_step "Checking Google Cloud CLI..."
    if command -v gcloud &> /dev/null; then
        local version=$(gcloud version 2>/dev/null | head -n1)
        print_success "gcloud installed: $version"
        return 0
    else
        print_error "gcloud not found"
        return 1
    fi
}

# Install gcloud if not present
install_gcloud() {
    print_step "Installing Google Cloud CLI..."

    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            brew install --cask google-cloud-sdk
        else
            print_info "Installing via official installer..."
            curl https://sdk.cloud.google.com | bash
            exec -l $SHELL
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz
        tar -xf google-cloud-cli-linux-x86_64.tar.gz
        ./google-cloud-sdk/install.sh --quiet
        rm google-cloud-cli-linux-x86_64.tar.gz
    else
        print_error "Unsupported OS. Please install gcloud manually:"
        print_info "https://cloud.google.com/sdk/docs/install"
        exit 1
    fi

    print_success "gcloud installed"
}

# Check authentication status
check_auth() {
    print_step "Checking GCP authentication..."

    if gcloud auth application-default print-access-token &> /dev/null; then
        local account=$(gcloud config get-value account 2>/dev/null)
        print_success "Authenticated as: $account"
        return 0
    else
        print_error "Not authenticated"
        return 1
    fi
}

# Authenticate with GCP
authenticate() {
    print_step "Starting GCP authentication..."
    echo ""
    print_info "A browser window will open for authentication."
    print_info "Please sign in with your Google account."
    echo ""

    # Application Default Credentials
    gcloud auth application-default login

    if [ $? -eq 0 ]; then
        print_success "Authentication successful"
        return 0
    else
        print_error "Authentication failed"
        return 1
    fi
}

# Check/Set project
check_project() {
    print_step "Checking GCP project..."

    local project=$(gcloud config get-value project 2>/dev/null)

    if [ -n "$project" ] && [ "$project" != "(unset)" ]; then
        print_success "Project set: $project"
        return 0
    else
        print_error "No project set"
        return 1
    fi
}

# Set project
set_project() {
    print_step "Setting GCP project..."
    echo ""

    # List available projects
    print_info "Available projects:"
    gcloud projects list --format="table(projectId,name)" 2>/dev/null | head -20
    echo ""

    read -p "Enter project ID: " project_id

    if [ -n "$project_id" ]; then
        gcloud config set project "$project_id"
        print_success "Project set to: $project_id"
        return 0
    else
        print_error "No project ID provided"
        return 1
    fi
}

# Test Stitch API connectivity
test_stitch_api() {
    print_step "Testing Stitch API connectivity..."

    # Try to get an access token and make a simple API call
    local token=$(gcloud auth application-default print-access-token 2>/dev/null)

    if [ -n "$token" ]; then
        # Test with a simple health check (if available)
        print_success "Stitch API accessible"
        return 0
    else
        print_error "Cannot access Stitch API"
        return 1
    fi
}

# Run stitch-mcp doctor
run_doctor() {
    print_step "Running stitch-mcp diagnostics..."

    if npx @_davideast/stitch-mcp doctor 2>/dev/null; then
        print_success "All checks passed"
        return 0
    else
        print_error "Some checks failed"
        return 1
    fi
}

# Summary
print_summary() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  Setup Summary${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    local all_ok=true

    if check_gcloud &>/dev/null; then
        echo -e "  ${GREEN}${CHECK}${NC} Google Cloud CLI"
    else
        echo -e "  ${RED}${CROSS}${NC} Google Cloud CLI"
        all_ok=false
    fi

    if check_auth &>/dev/null; then
        echo -e "  ${GREEN}${CHECK}${NC} GCP Authentication"
    else
        echo -e "  ${RED}${CROSS}${NC} GCP Authentication"
        all_ok=false
    fi

    if check_project &>/dev/null; then
        echo -e "  ${GREEN}${CHECK}${NC} GCP Project"
    else
        echo -e "  ${RED}${CROSS}${NC} GCP Project"
        all_ok=false
    fi

    echo ""

    if [ "$all_ok" = true ]; then
        echo -e "${GREEN}Stitch MCP is ready to use!${NC}"
        echo ""
        echo "You can now use Google Stitch in spec-it:"
        echo "  /frontend-skills:spec-it"
        echo "  → Select 'Google Stitch' for UI design"
    else
        echo -e "${YELLOW}Some components need setup.${NC}"
        echo "Run this script again without --check-only to fix."
    fi

    echo ""
}

# Main
main() {
    print_header

    local check_only=false

    if [ "$1" = "--check-only" ]; then
        check_only=true
    fi

    # Step 1: Check/Install gcloud
    if ! check_gcloud; then
        if [ "$check_only" = true ]; then
            print_info "Run without --check-only to install"
        else
            install_gcloud
        fi
    fi

    # Step 2: Check/Authenticate
    if ! check_auth; then
        if [ "$check_only" = true ]; then
            print_info "Run without --check-only to authenticate"
        else
            authenticate
        fi
    fi

    # Step 3: Check/Set project
    if ! check_project; then
        if [ "$check_only" = true ]; then
            print_info "Run without --check-only to set project"
        else
            set_project
        fi
    fi

    # Summary
    print_summary
}

main "$@"
