FROM node:20-alpine
WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000

COPY package*.json ./
ADD node_modules_prod.tar.gz ./
COPY dist ./dist

EXPOSE 3000

CMD ["node", "dist/main"]
