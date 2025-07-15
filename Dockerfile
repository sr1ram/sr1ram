FROM nginx:stable-alpine
RUN rm -rf /usr/share/nginx/html/*

# copy everything in the local webp/ dir into the container’s html folder
COPY webp/ /usr/share/nginx/html/

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]