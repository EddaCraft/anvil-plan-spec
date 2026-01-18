# Security Policy

## Reporting a Vulnerability

If you discover a security issue, please report it privately.

- Email: <josh@eddacraft.ai>
- If you cannot reach us by email, open a GitHub issue and clearly mark it as
  "security" and request a private channel.

We will acknowledge reports within 7 days and provide a timeline for a fix when
possible.

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 0.x.x   | :white_check_mark: |

We support the latest minor release. Security fixes will be backported to the
most recent release only.

## Security Considerations

APS is a specification format consisting of markdown templates and a simple CLI
tool for scaffolding. It does not:

- Execute arbitrary code
- Make network requests (except during `npm install`)
- Access sensitive system resources
- Store or transmit user data

The CLI (`bin/aps.js`) only performs file system operations in the target
directory specified by the user.
