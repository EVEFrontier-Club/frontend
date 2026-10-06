# Quick Start - Local Development

Welcome to EVE Frontier Club! 🚀 Get started with local development in 5 minutes.

## ⚡ Prerequisites (1 minute)

Install Dart SDK: https://dart.dev/get-dart

```bash
dart --version  # Verify installation
```

## ⚡ Step 1: Clone & Setup (2 minutes)

```bash
# Clone the repository
git clone https://github.com/EVEFrontier-Club/frontend.git
cd frontend

# Get dependencies
dart pub get
```

## ⚡ Step 2: Start Development Server (1 minute)

```bash
# Start the dev server
dart run jaspr:serve
```

Output should show:
```
✓ Build complete
Serving at http://localhost:8080
```

## ⚡ Step 3: Open Browser (30 seconds)

Open your browser to: **http://localhost:8080**

🎉 You're now running EVE Frontier Club locally!

## 🔄 Hot Reload

Save any file in `lib/` → changes appear instantly in the browser (no manual refresh needed!)

## 📁 Project Structure

```
lib/
├── pages/           # Page components
│   ├── home.dart           # Landing page
│   ├── leaderboard.dart    # Leaderboard
│   └── about.dart          # About page
├── components/      # Reusable UI components
├── services/        # API clients
└── constants/       # Config & theme
```

## 🎨 Styling

We use Tailwind CSS. Modify:
- Class names in `lib/pages/` and components
- Colors in `web/styles.tw.css`
- Spacing/sizes directly with Tailwind utilities

## 🧪 Code Quality

Before committing:

```bash
# Check for errors
dart analyze

# Format code
dart format lib/
```

## 🐳 Full Stack Local Testing (Optional)

Test with frontend + backend stack:

```bash
docker-compose up
# Visit http://localhost (port 80)
```

Includes:
- Frontend (Jaspr dev server)
- Mock backend API (httpbin)
- Nginx reverse proxy

## 🐛 Common Issues

### "Port 8080 already in use"
```bash
# Use a different port
dart run jaspr:serve -- --port 8082
```

### "Build fails"
```bash
# Clean build
dart clean && dart pub get && dart run build_runner build
```

### "Hot reload not working"
- Save the file again
- Check browser console for errors
- Try browser hard refresh (Ctrl+Shift+R)

## 📚 Next Steps

1. ✅ Run locally
2. 📖 Read [CONTRIBUTING.md](../CONTRIBUTING.md)
3. 🔍 Explore the codebase
4. 🎯 Find an issue to work on
5. 📤 Submit a PR!

## 🆘 Need Help?

- 📝 Check [CONTRIBUTING.md](../CONTRIBUTING.md)
- 🐛 Open an [issue](https://github.com/EVEFrontier-Club/frontend/issues)
- 💬 Start a [discussion](https://github.com/EVEFrontier-Club/frontend/discussions)

## 🚀 Ready to Contribute?

1. Create a branch: `git checkout -b feature/my-feature`
2. Make changes
3. Test locally
4. Commit: `git commit -m "Add: my feature"`
5. Push: `git push origin feature/my-feature`
6. Create a Pull Request!

---

Happy coding! We look forward to your contributions! 👋
