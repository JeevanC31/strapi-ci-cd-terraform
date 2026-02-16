# -------- Build Stage --------
FROM node:20-bullseye-slim AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y \
    python3 make g++ build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY strapi-app/package*.json ./
RUN npm install

COPY strapi-app/ .
RUN npm run build

# -------- Production Stage --------
FROM node:20-bullseye-slim

WORKDIR /app

COPY --from=builder /app /app

EXPOSE 1337

CMD ["npm", "run", "start"]
