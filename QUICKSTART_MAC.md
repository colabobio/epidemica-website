# Quick Setup Guide for Mac Terminal - GitHub Copilot Firewall Configuration

This is a quick reference guide for configuring your Mac terminal to work with GitHub Copilot behind a corporate firewall or proxy.

## Quick Start (2 minutes)

### Option 1: Interactive Setup (Easiest)

```bash
# Download the setup script
curl -O https://raw.githubusercontent.com/samuelho-ai/epidemica-website/main/setup-proxy-env.sh

# IMPORTANT: Review the script before running it
cat setup-proxy-env.sh  # or open in your editor

# After reviewing, source it to configure your environment
source setup-proxy-env.sh
```

The script will prompt you for your proxy settings and configure everything automatically.

**Security Note**: Always review scripts before executing them, especially when downloading from the internet.

### Option 2: Manual Environment Variables

Add to `~/.zshrc` (or `~/.bash_profile` for bash):

```bash
# Replace with your actual proxy settings
export HTTP_PROXY="http://proxy.company.com:8080"
export HTTPS_PROXY="http://proxy.company.com:8080"
export http_proxy="http://proxy.company.com:8080"
export https_proxy="http://proxy.company.com:8080"
export NO_PROXY="localhost,127.0.0.1,.local"

# Configure Git
git config --global http.proxy http://proxy.company.com:8080
git config --global https.proxy http://proxy.company.com:8080
```

Then reload your shell:
```bash
source ~/.zshrc
```

### Option 3: VS Code Only

Add to VS Code `settings.json` (⌘+Shift+P → "Preferences: Open Settings (JSON)"):

```json
{
  "http.proxy": "http://proxy.company.com:8080",
  "http.proxyStrictSSL": false,
  "github.copilot.advanced": {
    "debug.overrideProxyUrl": "http://proxy.company.com:8080"
  }
}
```

## Test Your Configuration

```bash
# Test GitHub API connectivity
curl -I https://api.github.com

# Test Git
git ls-remote https://github.com/github/docs.git
```

If you see successful responses (HTTP 200 or repository information), you're all set!

## With Authentication

If your proxy requires username/password:

```bash
export HTTP_PROXY="http://username:password@proxy.company.com:8080"
export HTTPS_PROXY="http://username:password@proxy.company.com:8080"
```

**Important**: Special characters in passwords should be URL-encoded:
- `@` → `%40`
- `:` → `%3A`
- `!` → `%21`

## Common Issues

| Problem | Solution |
|---------|----------|
| SSL certificate errors | `git config --global http.sslVerify false` (temporary) or install company CA cert |
| Connection timeout | `git config --global http.postBuffer 524288000` |
| Copilot not working | Restart VS Code after configuring proxy |
| Authentication failed | Check username/password encoding and proxy credentials |

## Next Steps

- After setup, restart your IDE (VS Code, etc.)
- Sign in to GitHub Copilot
- Test by typing code and waiting for Copilot suggestions

## Need More Help?

See [DEVELOPMENT_SETUP.md](./DEVELOPMENT_SETUP.md) for comprehensive documentation including:
- Detailed troubleshooting
- SSL certificate installation
- Security best practices
- Ruby/Bundler configuration
- Removing proxy settings

## No Proxy Needed?

If you're not behind a firewall, you can skip all proxy configuration. GitHub Copilot should work out of the box.

---

**Remember**: Always comply with your organization's network and security policies when configuring proxy settings.
