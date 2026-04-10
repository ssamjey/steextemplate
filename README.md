# Steex Template

Steex is a static HTML dashboard/template project with prebuilt pages, components, and assets for admin-style interfaces.

## Project Structure

- `index.html` - main entry page
- `assets/` - CSS, JavaScript, fonts, images, and third-party libraries
- `apps-*.html`, `ui-*.html`, `forms-*.html`, etc. - ready-to-use page templates

## Getting Started

### 1) Clone

```bash
git clone https://github.com/ssamjey/steextemplate.git
cd steextemplate
```

### 2) Run Locally

Because this is a static project, you can open `index.html` directly, or serve it with any static server.

Example with Python:

```bash
python3 -m http.server 8080
```

Then open [http://localhost:8080](http://localhost:8080).

## Development Notes

- Keep secrets/tokens out of source files.
- A local pre-push secret scan is configured via `.git/hooks/pre-push`.
- Main scan script is `scripts/scan-secrets.sh`.

## License

Add your license details here.
