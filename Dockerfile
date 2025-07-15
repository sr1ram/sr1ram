# Use a minimal web server image
FROM nginx:stable-alpine

# Remove default content
RUN rm -rf /usr/share/nginx/html/*

# Copy your built site (e.g. from `docs/` or `public/`)
COPY /home/snatarajan/cka-quiz/sr1ram/webp /usr/share/nginx/html/

# Expose HTTP port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]