FROM node:14-alpine AS builder
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

FROM node:14-alpine
WORKDIR /app
COPY package*.json .
RUN npm install
COPY --from=builder /app/dist ./dist
EXPOSE 3000
CMD ["npm", "run", "start"]