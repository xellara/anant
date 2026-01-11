# Stage 1: Build the Flutter Web App
FROM ubuntu:latest AS build-env

# Install dependencies for Flutter
RUN apt-get update && \
    apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3 && \
    apt-get clean

# Clone Flutter SDK
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Set flutter path
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Switch to stable channel
RUN flutter channel stable
RUN flutter upgrade

# Create app directory
WORKDIR /app

# Copy pubspec files
COPY pubspec.yaml pubspec.lock ./

# Copy the app source code
COPY . .

# Enable web support
RUN flutter config --enable-web

# Build the web application
# Note: Pass any necessary build args here if needed, e.g., --dart-define=...
RUN flutter build web --release

# Stage 2: Serve the App with Nginx
FROM nginx:1.21.1-alpine

# Copy the built web assets from the previous stage to the Nginx html directory
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
