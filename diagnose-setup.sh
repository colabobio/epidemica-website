#!/bin/bash

# Diagnostic script for GitHub Copilot firewall/proxy configuration
# Usage: ./diagnose-setup.sh

echo "=========================================="
echo "GitHub Copilot Environment Diagnostics"
echo "=========================================="
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_check() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $2"
    else
        echo -e "${RED}✗${NC} $2"
    fi
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Check 1: Environment Variables
echo "1. Checking Environment Variables"
echo "-----------------------------------"
if [ -n "$HTTP_PROXY" ] || [ -n "$HTTPS_PROXY" ]; then
    print_check 0 "Proxy environment variables are set"
    if [ -n "$HTTP_PROXY" ]; then
        # Mask password in output
        SAFE_PROXY=$(echo "$HTTP_PROXY" | sed -E 's/(:\/\/[^:]+:)[^@]+(@)/\1****\2/')
        echo "  HTTP_PROXY: $SAFE_PROXY"
    fi
    if [ -n "$HTTPS_PROXY" ]; then
        SAFE_PROXY=$(echo "$HTTPS_PROXY" | sed -E 's/(:\/\/[^:]+:)[^@]+(@)/\1****\2/')
        echo "  HTTPS_PROXY: $SAFE_PROXY"
    fi
else
    print_warning "No proxy environment variables set (this may be OK if not behind a firewall)"
fi
echo ""

# Check 2: Git Configuration
echo "2. Checking Git Configuration"
echo "------------------------------"
if command -v git &> /dev/null; then
    print_check 0 "Git is installed"
    
    GIT_HTTP_PROXY=$(git config --global --get http.proxy)
    GIT_HTTPS_PROXY=$(git config --global --get https.proxy)
    
    if [ -n "$GIT_HTTP_PROXY" ] || [ -n "$GIT_HTTPS_PROXY" ]; then
        print_check 0 "Git proxy is configured"
        [ -n "$GIT_HTTP_PROXY" ] && echo "  http.proxy: $GIT_HTTP_PROXY"
        [ -n "$GIT_HTTPS_PROXY" ] && echo "  https.proxy: $GIT_HTTPS_PROXY"
    else
        print_warning "Git proxy is not configured"
    fi
    
    GIT_SSL_VERIFY=$(git config --global --get http.sslVerify)
    if [ "$GIT_SSL_VERIFY" = "false" ]; then
        print_warning "SSL verification is disabled (security risk)"
    fi
else
    print_check 1 "Git is not installed"
fi
echo ""

# Check 3: Network Connectivity
echo "3. Testing Network Connectivity"
echo "--------------------------------"
if command -v curl &> /dev/null; then
    # Test GitHub API
    if curl -s -m 10 -I https://api.github.com 2>/dev/null | head -n 1 | grep -q "HTTP.*\(200\|301\|302\)"; then
        print_check 0 "Can reach GitHub API"
    else
        print_check 1 "Cannot reach GitHub API"
        echo "  This may indicate firewall/proxy issues"
    fi
    
    # Test with explicit proxy if set
    if [ -n "$HTTP_PROXY" ]; then
        if curl -s -m 10 -I --proxy "$HTTP_PROXY" https://api.github.com 2>/dev/null | head -n 1 | grep -q "HTTP.*\(200\|301\|302\)"; then
            print_check 0 "Can reach GitHub API via proxy"
        else
            print_check 1 "Cannot reach GitHub API via proxy"
            echo "  Check your proxy settings"
        fi
    fi
    
    # Test GitHub's raw content
    if curl -s -m 10 -I https://raw.githubusercontent.com 2>/dev/null | head -n 1 | grep -q "HTTP.*\(200\|301\|302\|307\)"; then
        print_check 0 "Can reach raw.githubusercontent.com"
    else
        print_check 1 "Cannot reach raw.githubusercontent.com"
    fi
else
    print_warning "curl is not installed, cannot test connectivity"
fi
echo ""

# Check 4: SSL Certificates
echo "4. Checking SSL Configuration"
echo "------------------------------"
if command -v openssl &> /dev/null; then
    if echo | openssl s_client -connect api.github.com:443 -servername api.github.com </dev/null 2>/dev/null | grep -q "Verify return code: 0"; then
        print_check 0 "SSL certificate verification works"
    else
        print_warning "SSL certificate verification may have issues"
        echo "  You may need to install your company's CA certificate"
    fi
else
    print_warning "openssl is not available"
fi
echo ""

# Check 5: Development Tools
echo "5. Checking Development Tools"
echo "------------------------------"
command -v ruby &> /dev/null && print_check 0 "Ruby is installed ($(ruby --version | cut -d' ' -f2))" || print_check 1 "Ruby is not installed"
command -v bundle &> /dev/null && print_check 0 "Bundler is installed" || print_check 1 "Bundler is not installed"
command -v jekyll &> /dev/null && print_check 0 "Jekyll is installed" || print_warning "Jekyll is not installed (run 'bundle install')"
command -v npm &> /dev/null && print_check 0 "npm is installed" || print_warning "npm is not installed"
command -v node &> /dev/null && print_check 0 "Node.js is installed ($(node --version))" || print_warning "Node.js is not installed"
echo ""

# Check 6: VS Code
echo "6. Checking VS Code Configuration"
echo "-----------------------------------"
if command -v code &> /dev/null; then
    print_check 0 "VS Code CLI is available"
    
    # Check if VS Code settings exist
    VSCODE_SETTINGS="$HOME/Library/Application Support/Code/User/settings.json"
    if [ -f "$VSCODE_SETTINGS" ]; then
        if grep -q "http.proxy" "$VSCODE_SETTINGS" 2>/dev/null; then
            print_check 0 "VS Code proxy settings found"
        else
            print_warning "No proxy settings in VS Code settings.json"
            echo "  Add proxy configuration to: $VSCODE_SETTINGS"
        fi
    else
        print_warning "VS Code settings.json not found"
    fi
else
    print_warning "VS Code CLI not available"
    echo "  VS Code may still be installed but not in PATH"
fi
echo ""

# Summary and Recommendations
echo "=========================================="
echo "Summary and Recommendations"
echo "=========================================="
echo ""

if [ -z "$HTTP_PROXY" ] && [ -z "$HTTPS_PROXY" ]; then
    echo "⚠ No proxy configured. If you're behind a firewall:"
    echo "  1. Run: source setup-proxy-env.sh"
    echo "  2. Or see QUICKSTART_MAC.md for manual setup"
    echo ""
fi

if ! curl -s -m 5 https://api.github.com &>/dev/null; then
    echo "⚠ Cannot reach GitHub. Possible issues:"
    echo "  • Firewall blocking connection"
    echo "  • Incorrect proxy settings"
    echo "  • Network connectivity problems"
    echo "  • SSL certificate issues"
    echo ""
    echo "  Solutions:"
    echo "  1. Verify proxy settings with your IT department"
    echo "  2. Check DEVELOPMENT_SETUP.md for detailed troubleshooting"
    echo "  3. Try: git config --global http.sslVerify false (temporary)"
    echo ""
fi

echo "For more help, see:"
echo "  • QUICKSTART_MAC.md - Quick setup guide"
echo "  • DEVELOPMENT_SETUP.md - Comprehensive documentation"
echo "  • .vscode-proxy-settings.json - VS Code configuration template"
echo ""
echo "=========================================="
