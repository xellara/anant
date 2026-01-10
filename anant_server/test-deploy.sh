#!/bin/bash
# Test Docker build locally before deploying

echo "🧪 Testing Docker build locally..."
echo ""

# Build the image
echo "Building Docker image..."
docker build -t anant-server-test .

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Build successful!"
    echo ""
    echo "You can now deploy to Cloud Run using Cloud Shell:"
    echo ""
    echo "1. Upload these files to Cloud Shell"
    echo "2. Run the deployment command"
    echo ""
else
    echo ""
    echo "❌ Build failed - check the errors above"
    exit 1
fi
