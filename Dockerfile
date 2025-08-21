# Use an official Node.js runtime as a parent image
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy your package.json and package-lock.json files
COPY package*.json ./

# Install your application's dependencies
RUN npm install

# Copy the rest of your application's source code
COPY . .

# Expose the port your app runs on (e.g., 8080)
EXPOSE 8080

# Define the command to start your app
CMD [ "node", "server.js" ]
