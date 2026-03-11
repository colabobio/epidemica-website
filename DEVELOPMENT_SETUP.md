# Development Environment Setup for GitHub Copilot

This guide helps you configure your Mac terminal environment to work with GitHub Copilot coding agent, particularly when behind a corporate firewall or proxy.

## Prerequisites

- macOS with Terminal access
- GitHub Copilot subscription
- Network administrator approval for proxy/firewall configuration (if applicable)

## Environment Configuration for Firewall Bypass

### 1. Configure HTTP/HTTPS Proxy

If you're behind a corporate firewall, you'll need to configure proxy settings:

```bash
# Add these to your ~/.zshrc or ~/.bash_profile
export HTTP_PROXY="http://proxy.company.com:8080"
export HTTPS_PROXY="http://proxy.company.com:8080"
export http_proxy="http://proxy.company.com:8080"
export https_proxy="http://proxy.company.com:8080"

# If your proxy requires authentication
export HTTP_PROXY="http://username:password@proxy.company.com:8080"
export HTTPS_PROXY="http://username:password@proxy.company.com:8080"

# Domains that should bypass the proxy
export NO_PROXY="localhost,127.0.0.1,.local,.internal"
export no_proxy="localhost,127.0.0.1,.local,.internal"
```

### 2. Configure Git for Proxy

```bash
# Set Git to use your proxy
git config --global http.proxy http://proxy.company.com:8080
git config --global https.proxy http://proxy.company.com:8080

# If authentication is needed
git config --global http.proxy http://username:password@proxy.company.com:8080
git config --global https.proxy http://username:password@proxy.company.com:8080

# Verify configuration
git config --global --list | grep proxy
```

### 3. Configure npm/Node.js for Proxy (if applicable)

```bash
npm config set proxy http://proxy.company.com:8080
npm config set https-proxy http://proxy.company.com:8080
npm config set strict-ssl false  # Only if you have SSL certificate issues
```

### 4. Configure Ruby/Bundler for Proxy

```bash
# Add to ~/.zshrc or ~/.bash_profile
export HTTPS_PROXY=http://proxy.company.com:8080
export HTTP_PROXY=http://proxy.company.com:8080

# For bundler specifically
bundle config set https://rubygems.org/ http://proxy.company.com:8080
```

### 5. SSL Certificate Configuration

If you encounter SSL certificate issues behind a firewall:

```bash
# Option 1: Install corporate CA certificate (recommended)
# Download your company's root CA certificate
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain /path/to/ca-cert.crt

# Option 2: Configure Git to use specific CA bundle
git config --global http.sslCAInfo /path/to/ca-bundle.crt

# Option 3: Disable SSL verification (NOT RECOMMENDED for production)
git config --global http.sslVerify false
```

## Quick Setup Script for Mac

Create a file `setup-proxy-env.sh` in your project root:

```bash
#!/bin/bash

# Development Environment Setup for Firewall/Proxy
# Usage: source setup-proxy-env.sh

# Configuration - UPDATE THESE VALUES
PROXY_HOST="proxy.company.com"
PROXY_PORT="8080"
PROXY_USER=""  # Leave empty if no authentication required
PROXY_PASS=""  # Leave empty if no authentication required

# Build proxy URL
if [ -n "$PROXY_USER" ] && [ -n "$PROXY_PASS" ]; then
    PROXY_URL="http://${PROXY_USER}:${PROXY_PASS}@${PROXY_HOST}:${PROXY_PORT}"
else
    PROXY_URL="http://${PROXY_HOST}:${PROXY_PORT}"
fi

# Set environment variables
export HTTP_PROXY="$PROXY_URL"
export HTTPS_PROXY="$PROXY_URL"
export http_proxy="$PROXY_URL"
export https_proxy="$PROXY_URL"
export NO_PROXY="localhost,127.0.0.1,.local"
export no_proxy="localhost,127.0.0.1,.local"

echo "✓ Proxy environment variables set"
echo "  HTTP_PROXY: $HTTP_PROXY"
echo "  HTTPS_PROXY: $HTTPS_PROXY"

# Configure Git
git config --global http.proxy "$PROXY_URL"
git config --global https.proxy "$PROXY_URL"
echo "✓ Git proxy configured"

# Test connectivity
echo ""
echo "Testing connectivity..."
if curl -I --proxy "$PROXY_URL" https://api.github.com 2>/dev/null | head -n 1 | grep -q "200\|301\|302"; then
    echo "✓ GitHub API is reachable"
else
    echo "✗ Cannot reach GitHub API - check your proxy settings"
fi
```

## Using the Setup Script

1. Download the script:
   ```bash
   curl -O https://raw.githubusercontent.com/samuelho-ai/epidemica-website/main/setup-proxy-env.sh
   ```

2. **IMPORTANT**: Review the script before executing:
   ```bash
   cat setup-proxy-env.sh  # or: nano setup-proxy-env.sh
   # Verify the script contents are as expected
   ```

3. Edit the script to update proxy settings (optional):
   ```bash
   nano setup-proxy-env.sh
   # Update PROXY_HOST, PROXY_PORT, PROXY_USER, PROXY_PASS
   ```

4. Source the script (don't execute it):
   ```bash
   source setup-proxy-env.sh
   ```

## GitHub Copilot Specific Configuration

### VS Code Settings

Add to your VS Code `settings.json` (⌘+, then search for "settings.json"):

```json
{
  "http.proxy": "http://proxy.company.com:8080",
  "http.proxyStrictSSL": false,
  "github.copilot.advanced": {
    "debug.overrideProxyUrl": "http://proxy.company.com:8080"
  }
}
```

### VS Code Command Palette Configuration

1. Open VS Code
2. Press `⌘+Shift+P` to open Command Palette
3. Type "Preferences: Open Settings (JSON)"
4. Add the proxy configuration shown above

## Verifying Your Setup

Run these commands to verify your configuration:

```bash
# Check environment variables
env | grep -i proxy

# Test GitHub connectivity
curl -I https://api.github.com

# Test Git over HTTPS
git ls-remote https://github.com/github/docs.git

# Test with explicit proxy
curl -x http://proxy.company.com:8080 https://api.github.com
```

## Troubleshooting

### Issue: SSL Certificate Errors

**Solution:**
```bash
# Temporary fix (not recommended for production)
export NODE_TLS_REJECT_UNAUTHORIZED=0
git config --global http.sslVerify false

# Permanent fix: Install your company's CA certificate
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain /path/to/company-ca.crt
```

### Issue: Authentication Required

**Solution:**
- Ensure your username and password are correctly encoded in the proxy URL
- Special characters in password should be URL-encoded (e.g., `@` becomes `%40`)
- Consider using environment variables to store credentials securely

### Issue: GitHub Copilot Not Working in VS Code

**Solution:**
1. Check VS Code output panel (View → Output → GitHub Copilot)
2. Sign out and sign back into GitHub Copilot
3. Restart VS Code after configuring proxy settings
4. Check VS Code's network settings match your system proxy

### Issue: Connection Timeout

**Solution:**
```bash
# Increase Git timeout
git config --global http.postBuffer 524288000
git config --global http.lowSpeedLimit 0
git config --global http.lowSpeedTime 999999
```

## Removing Proxy Configuration

If you no longer need proxy configuration:

```bash
# Remove environment variables (close terminal or unset)
unset HTTP_PROXY HTTPS_PROXY http_proxy https_proxy

# Remove Git proxy configuration
git config --global --unset http.proxy
git config --global --unset https.proxy

# Re-enable SSL verification
git config --global --unset http.sslVerify
```

## Security Considerations

1. **Never commit credentials**: Do not add proxy credentials to version control
2. **Use environment variables**: Store sensitive information in environment variables
3. **CA Certificates**: Always prefer installing CA certificates over disabling SSL verification
4. **Secure storage**: Use macOS Keychain or similar for storing proxy credentials
5. **Network policy compliance**: Ensure your firewall bypass methods comply with your organization's policies

## Additional Resources

- [GitHub Copilot Documentation](https://docs.github.com/en/copilot)
- [VS Code Proxy Documentation](https://code.visualstudio.com/docs/setup/network)
- [Git Configuration Documentation](https://git-scm.com/docs/git-config)
- [macOS Network Configuration](https://support.apple.com/guide/mac-help/welcome/mac)

## Support

If you continue to experience issues after following this guide:

1. Check with your network administrator about firewall rules
2. Review VS Code and GitHub Copilot logs
3. Test basic network connectivity: `curl -v https://api.github.com`
4. Verify your GitHub Copilot subscription is active

For project-specific issues, please open an issue in the [repository](https://github.com/samuelho-ai/epidemica-website/issues).
