# Stage 1: Build the application
FROM node:18 as build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to install dependencies
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the entire application code
COPY . .

# Build the Next.js application
RUN npm run build

# Install production dependencies
RUN npm prune --production

# Stage 2: Serve the application
FROM node:18 as production

# Set the working directory
WORKDIR /app

# Copy only the production dependencies
COPY --from=build /app/node_modules ./node_modules

# Copy the built application files
COPY --from=build /app/.next ./.next
COPY --from=build /app/package.json ./

# Expose the Next.js default port
EXPOSE 3000

# Start the Next.js application
CMD ["npm", "start"]
