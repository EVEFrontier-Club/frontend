# Contributing to EVE Frontier Club

Thank you for your interest in contributing to EVE Frontier Club! 🚀 This guide will help you get started with local development.

## Setup for Contributors

### Prerequisites

- **Dart SDK**: [Install here](https://dart.dev/get-dart)
- **Flutter** (optional, but recommended): [Install here](https://flutter.dev/docs/get-started/install)
- **Git**: For version control
- **Node.js** (optional): For some build tools

### Quick Start - Local Development

```bash
# Clone the repository
git clone https://github.com/EVEFrontier-Club/frontend.git
cd frontend

# Get dependencies
dart pub get

# Run development server
dart run jaspr:serve

# Open browser to http://localhost:8080
```

The development server supports hot reload - your changes appear instantly!

### Project Structure

```
lib/
├── app.dart              # Main app and routing
├── pages/                # Page components
│   ├── home.dart        # Landing page
│   ├── leaderboard.dart # Trust Index leaderboard
│   └── about.dart       # About page
├── components/           # Reusable UI components
│   ├── header.dart      # Top navigation
│   └── ...
├── services/             # Backend API clients
│   └── trust_service.dart  # Trust Index API
└── constants/            # Configuration
    └── theme.dart       # Styling tokens
```

### Styling

We use **Tailwind CSS v4** with custom theme tokens:

- **Primary**: `#4cc9f0` (neon blue)
- **Accent**: `#9d4bff` (purple)
- **Background**: `#0b0e14` (deep space)

See `web/styles.tw.css` for theme configuration.

### Development Workflow

1. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Keep components small and focused
   - Use Tailwind classes for styling
   - Add comments for complex logic

3. **Test locally**
   ```bash
   dart analyze        # Check for errors
   dart format lib/   # Format code
   ```

4. **Commit and push**
   ```bash
   git add .
   git commit -m "Add: description of your change"
   git push origin feature/your-feature-name
   ```

5. **Submit a pull request**
   - Describe what your PR does
   - Reference any related issues
   - Include screenshots if UI changes

## Code Style

- Follow Dart [style guide](https://dart.dev/guides/language/effective-dart/style)
- Use `dart format` for consistent formatting
- Keep functions small and testable
- Write meaningful variable and function names

## Local Testing with Docker (Optional)

For testing with the full stack locally:

```bash
docker-compose up
# App runs at http://localhost
```

This includes:
- Frontend (Jaspr)
- Mock backend API (httpbin)
- Nginx reverse proxy

## Reporting Issues

Found a bug? Please report it with:
- Description of the issue
- Steps to reproduce
- Expected vs actual behavior
- Browser/environment details
- Screenshots if applicable

## Questions?

- Check [discussions](https://github.com/EVEFrontier-Club/frontend/discussions)
- Open an [issue](https://github.com/EVEFrontier-Club/frontend/issues)
- Join our community!

## License

All contributions are subject to the project's license. By contributing, you agree to license your contributions under the same terms.

---

Happy coding! 🎉 We appreciate your contributions to EVE Frontier Club!
