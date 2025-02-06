# Use an official Node.js runtime as the base image
FROM node:18 AS build

# Set the working directory
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the app's source code
COPY . .

# Build the React app
RUN npm run build

# Use a smaller nginx image to serve the React app
FROM nginx:latest

# Copy the build folder to nginx's public directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose the port the app runs on
EXPOSE 80

# Start nginx to serve the app
CMD ["nginx", "-g", "daemon off;"]
