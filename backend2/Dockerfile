# Usa una imagen ligera de Node
FROM node:18-alpine

WORKDIR /usr/src/app

# Copia solo package.json / lock y instala prod deps
COPY package*.json ./
RUN npm ci --only=production

# Copia el código
COPY . .

EXPOSE 3000
CMD ["node", "index.js"]
