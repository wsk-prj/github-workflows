# 1. 임시 이미지 빌드
FROM node:20-alpine AS builder

WORKDIR /builder-tmp

COPY package.json package-lock.json ./
RUN npm ci

COPY . .
RUN npm run build

# 2. 최종 이미지 빌드(빌드 결과물)
FROM node:20-alpine

WORKDIR /app

# 임시 이미지(builder)에서 빌드 결과물을 복사
COPY --from=builder /builder-tmp/package*.json ./
COPY --from=builder /builder-tmp/node_modules ./node_modules
COPY --from=builder /builder-tmp/dist ./dist

EXPOSE 3000

CMD ["node", "dist/main"]
