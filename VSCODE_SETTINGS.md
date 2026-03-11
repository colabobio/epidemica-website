# VS Code Proxy Settings for GitHub Copilot

This file provides example VS Code settings for configuring proxy support for GitHub Copilot.

## Usage

1. Open VS Code
2. Press `⌘+Shift+P` (Mac) or `Ctrl+Shift+P` (Windows/Linux)
3. Type "Preferences: Open Settings (JSON)"
4. Copy the settings from `.vscode-proxy-settings.json` into your `settings.json`
5. Update the proxy URL with your actual proxy server details

## Settings Explained

### Basic Proxy Configuration

```json
{
  "http.proxy": "http://proxy.company.com:8080",
  "http.proxyStrictSSL": false,
  "http.proxySupport": "on"
}
```

- **http.proxy**: Your proxy server URL
- **http.proxyStrictSSL**: Set to `false` if you have SSL certificate issues
- **http.proxySupport**: Set to `"on"` to enable proxy support

### GitHub Copilot Specific

```json
{
  "github.copilot.advanced": {
    "debug.overrideProxyUrl": "http://proxy.company.com:8080",
    "debug.testOverrideProxyUrl": "http://proxy.company.com:8080"
  }
}
```

These settings specifically configure GitHub Copilot to use your proxy.

### With Authentication

If your proxy requires authentication, update the `http.proxy` setting:

```json
{
  "http.proxy": "http://username:password@proxy.company.com:8080"
}
```

**Important**: URL-encode special characters in your password:
- `@` → `%40`
- `:` → `%3A`
- `!` → `%21`
- `#` → `%23`
- etc.

### SSL Certificate Issues

If you're having SSL certificate issues (as a last resort):

```json
{
  "http.systemCertificates": false
}
```

**Note**: This disables SSL certificate validation. It's better to install your company's CA certificate instead.

## Complete Example

```json
{
  "http.proxy": "http://myuser:mypass%40word@proxy.company.com:8080",
  "http.proxyStrictSSL": false,
  "http.proxySupport": "on",
  "http.proxyAuthorization": null,
  "github.copilot.advanced": {
    "debug.overrideProxyUrl": "http://myuser:mypass%40word@proxy.company.com:8080",
    "debug.testOverrideProxyUrl": "http://myuser:mypass%40word@proxy.company.com:8080"
  }
}
```

## Testing Your Configuration

After applying these settings:

1. Restart VS Code
2. Open a code file
3. Start typing code
4. GitHub Copilot should show suggestions

## Troubleshooting

### Copilot Not Working After Configuration

1. Check VS Code Output panel: View → Output → GitHub Copilot
2. Look for proxy-related errors
3. Verify your proxy URL is correct
4. Try signing out and back into GitHub Copilot

### Still Having Issues?

- Run the diagnostic script: `./diagnose-setup.sh`
- See [DEVELOPMENT_SETUP.md](DEVELOPMENT_SETUP.md) for comprehensive troubleshooting
- Check that your proxy credentials are correct
- Verify your GitHub Copilot subscription is active

## Security Notes

- **Never commit credentials**: Don't commit settings files with passwords to git
- **Use environment variables**: Consider using VS Code's support for environment variables
- **Workspace settings**: You can also put these in `.vscode/settings.json` in your project (but don't commit credentials)

## Additional Resources

- [VS Code Network Settings](https://code.visualstudio.com/docs/setup/network)
- [GitHub Copilot Documentation](https://docs.github.com/en/copilot)
- [Main Setup Guide](DEVELOPMENT_SETUP.md)
