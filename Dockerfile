# Stage 1: Build Stage
FROM node:14 AS builder
WORKDIR /app

# Copy only package.json to install dependencies first (better caching)
COPY package*.json ./
RUN npm install

# Copy the rest of the application
COPY . .

# Stage 2: Production Stage (Smaller Image)
FROM node:14-slim
WORKDIR /app

# Copy only the necessary files from the builder stage
COPY --from=builder /app .

# Expose port 3000
EXPOSE 3000

# Command to start the application
CMD ["node", "app.js"]