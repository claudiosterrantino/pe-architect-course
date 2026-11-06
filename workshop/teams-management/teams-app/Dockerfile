# Dockerfile
FROM node:18-alpine as build

WORKDIR /app

# Copy package files
COPY package*.json ./
RUN npm ci --only=production

# Copy source code
COPY . .

# Build the app for production
RUN npm run build:prod

# Use nginx to serve the app
# SOSTITUITA IMMAGINE PRIVILEGIATA nginx:1.27-alpine
FROM nginxinc/nginx-unprivileged:1.27-alpine

# Copy built app to nginx
COPY --from=build /app/dist/teams-ui /usr/share/nginx/html

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
