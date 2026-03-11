#!/bin/bash

# Development Environment Setup for Firewall/Proxy
# This script configures your Mac terminal to work with GitHub Copilot behind a firewall
# Usage: source setup-proxy-env.sh

echo "=================================="
echo "Development Environment Setup"
echo "GitHub Copilot Firewall Configuration"
echo "=================================="
echo ""

# Configuration - UPDATE THESE VALUES FOR YOUR ENVIRONMENT
PROXY_HOST="${PROXY_HOST:-proxy.company.com}"
PROXY_PORT="${PROXY_PORT:-8080}"
PROXY_USER="${PROXY_USER:-}"  # Leave empty if no authentication required
PROXY_PASS="${PROXY_PASS:-}"  # Leave empty if no authentication required

# Interactive setup if proxy host is still default
if [ "$PROXY_HOST" = "proxy.company.com" ]; then
    echo "⚠️  Using default proxy settings. You may want to customize these."
    echo ""
    read -p "Enter proxy host (or press Enter to skip proxy setup): " input_host
    if [ -n "$input_host" ]; then
        PROXY_HOST="$input_host"
        read -p "Enter proxy port [8080]: " input_port
        PROXY_PORT="${input_port:-8080}"
        read -p "Enter proxy username (or press Enter if none): " input_user
        PROXY_USER="$input_user"
        if [ -n "$PROXY_USER" ]; then
            read -sp "Enter proxy password: " input_pass
            PROXY_PASS="$input_pass"
            echo ""
        fi
    else
        echo "Skipping proxy configuration..."
        echo "To use this script, set environment variables:"
        echo "  export PROXY_HOST=your.proxy.com"
        echo "  export PROXY_PORT=8080"
        echo "  source setup-proxy-env.sh"
        return 0
    fi
fi

# Build proxy URL
if [ -n "$PROXY_USER" ] && [ -n "$PROXY_PASS" ]; then
    # URL encode special characters in password (secure method using stdin)
    ENCODED_PASS=$(printf %s "$PROXY_PASS" | jq -sRr @uri 2>/dev/null || printf %s "$PROXY_PASS" | python3 -c "import sys, urllib.parse; print(urllib.parse.quote(sys.stdin.read().strip()))" 2>/dev/null || echo "$PROXY_PASS")
    PROXY_URL="http://${PROXY_USER}:${ENCODED_PASS}@${PROXY_HOST}:${PROXY_PORT}"
    PROXY_URL_SAFE="http://${PROXY_USER}:****@${PROXY_HOST}:${PROXY_PORT}"
else
    PROXY_URL="http://${PROXY_HOST}:${PROXY_PORT}"
    PROXY_URL_SAFE="$PROXY_URL"
fi

echo ""
echo "Setting up proxy configuration..."
echo ""

# Set environment variables
export HTTP_PROXY="$PROXY_URL"
export HTTPS_PROXY="$PROXY_URL"
export http_proxy="$PROXY_URL"
export https_proxy="$PROXY_URL"
export NO_PROXY="localhost,127.0.0.1,.local,.internal"
export no_proxy="localhost,127.0.0.1,.local,.internal"

echo "✓ Environment variables configured"
echo "  HTTP_PROXY: $PROXY_URL_SAFE"
echo "  HTTPS_PROXY: $PROXY_URL_SAFE"
echo "  NO_PROXY: $NO_PROXY"

# Configure Git
if command -v git &> /dev/null; then
    git config --global http.proxy "$PROXY_URL"
    git config --global https.proxy "$PROXY_URL"
    echo "✓ Git proxy configured"
else
    echo "⚠️  Git not found, skipping Git configuration"
fi

# Configure npm if available
if command -v npm &> /dev/null; then
    npm config set proxy "$PROXY_URL" 2>/dev/null
    npm config set https-proxy "$PROXY_URL" 2>/dev/null
    echo "✓ npm proxy configured"
fi

# Configure Ruby/Bundler environment
if command -v bundle &> /dev/null; then
    echo "✓ Ruby/Bundler will use HTTP_PROXY environment variable"
fi

echo ""
echo "Testing connectivity..."
echo ""

# Test basic connectivity
if command -v curl &> /dev/null; then
    # Test with proxy
    if curl -I -s -m 5 --proxy "$PROXY_URL" https://api.github.com 2>/dev/null | head -n 1 | grep -q "HTTP.*\(200\|301\|302\)"; then
        echo "✓ GitHub API is reachable via proxy"
    else
        echo "✗ Cannot reach GitHub API via proxy"
        echo "  This may be normal if you're not behind a firewall"
        echo "  Or your proxy settings may need adjustment"
    fi
    
    # Test direct connection
    if curl -I -s -m 5 https://api.github.com 2>/dev/null | head -n 1 | grep -q "HTTP.*\(200\|301\|302\)"; then
        echo "✓ Direct internet connection is available"
    fi
else
    echo "⚠️  curl not found, cannot test connectivity"
fi

echo ""
echo "=================================="
echo "Setup Complete!"
echo "=================================="
echo ""
echo "Your terminal is now configured to work with GitHub Copilot behind a firewall."
echo ""
echo "Next steps:"
echo "1. Restart your IDE (VS Code, etc.) to apply proxy settings"
echo "2. Configure VS Code settings.json with:"
echo "   {"
echo "     \"http.proxy\": \"$PROXY_URL_SAFE\","
echo "     \"http.proxyStrictSSL\": false"
echo "   }"
echo "3. Sign in to GitHub Copilot in your IDE"
echo ""
echo "To make these settings permanent, add the following to ~/.zshrc or ~/.bash_profile:"
echo "  export PROXY_HOST=\"$PROXY_HOST\""
echo "  export PROXY_PORT=\"$PROXY_PORT\""
if [ -n "$PROXY_USER" ]; then
    echo "  export PROXY_USER=\"$PROXY_USER\""
    echo "  export PROXY_PASS=\"your_password\"  # Store securely!"
fi
echo "  source /path/to/setup-proxy-env.sh"
echo ""
echo "For more information, see DEVELOPMENT_SETUP.md"
echo ""
