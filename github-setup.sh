#!/bin/bash

# Create and enter a new directory for the project
mkdir portfolio-project
cd portfolio-project

# Clone the empty repository
git clone https://github.com/knowlesb/CSCVFinalProject.git .

# Create necessary directories if they don't exist
mkdir -p css js server img

# Copy all project files (assuming they're in a source directory)
# Replace '../source' with the actual path to your source files
cp ../index.html .
cp ../about.html .
cp ../projects.html .
cp ../contact.html .
cp ../css/styles.css css/
cp ../js/app.js js/
cp ../server/server.js server/
cp ../package.json .
cp ../README.md .
cp ../LICENSE .
cp ../.gitignore .
cp ../img/* img/

# Initialize git and stage all files
git add .

# Create initial commit
git commit -m "feat: initial full-stack portfolio

- Add HTML pages (index, about, projects, contact)
- Add CSS styling and responsive design
- Add JavaScript functionality
- Add Express server with contact form
- Add project documentation
- Configure development environment"

# Push to main branch
git push -u origin main

# Optional: Enable GitHub Pages via gh-cli (if installed)
# gh repo edit --enable-pages --branch main --path /

echo "Repository setup complete! 🚀"
echo "To enable GitHub Pages manually:"
echo "1. Go to https://github.com/knowlesb/CSCVFinalProject/settings/pages"
echo "2. Under 'Source', select 'Deploy from a branch'"
echo "3. Select 'main' branch and '/ (root)' folder"
echo "4. Click 'Save'" 