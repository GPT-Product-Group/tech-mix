# Build stage
FROM node:20-alpine AS builder

# Install pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

WORKDIR /app

# Copy package files
COPY package.json pnpm-lock.yaml ./

# Install dependencies
RUN pnpm install --frozen-lockfile

# Copy source code
COPY . .

# Build the application
RUN pnpm build

# Remove development dependencies
RUN pnpm prune --prod

# Production stage
FROM node:20-alpine AS runner

# Install netcat for wait-for-it script
RUN apk add --no-cache netcat-openbsd

WORKDIR /app

# Copy necessary files from builder
COPY --from=builder /app/package.json ./
COPY --from=builder /app/pnpm-lock.yaml ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules

# Copy startup scripts
COPY scripts/docker-entrypoint.sh scripts/wait-for-it.sh ./
RUN chmod +x docker-entrypoint.sh wait-for-it.sh

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000
ENV SEED_DATABASE=${SEED_DATABASE:-false}

# Expose the port the app runs on
EXPOSE 3000

# Start the application using the entrypoint script
ENTRYPOINT ["/app/docker-entrypoint.sh"]