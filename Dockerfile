# Stage 1: Build React app
FROM node:18 AS build

WORKDIR /app

# Copy env and install dependencies
COPY package*.json ./
COPY .env .env
RUN npm install

# Copy the rest of the app
COPY . .

# Allow OpenSSL legacy for Webpack
ENV NODE_OPTIONS=--openssl-legacy-provider

# Build the React app
RUN npm run build

# Stage 2: Serve with nginx
FROM nginx:alpine

# Copy build output to nginx html directory
COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

