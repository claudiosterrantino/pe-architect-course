# ==========================================
# STAGE 1: Build & Dependencies
# ==========================================
FROM node:20-alpine AS builder

WORKDIR /app

# Copia i file dei descrittori di pacchetto
COPY package*.json ./

# Installa tutte le dipendenze (incluse devDependencies se c'è uno step di build come TypeScript)
RUN npm ci

# Copia il codice sorgente
COPY . .

# Esegue la build se presente lo script "build" nel package.json (es. per TypeScript), altrimenti prosegue
RUN npm run build --if-present

# Rimuove le devDependencies per alleggerire l'immagine finale
RUN npm prune --production

# ==========================================
# STAGE 2: Runtime Hardened (Conforme a Gatekeeper)
# ==========================================
FROM node:20-alpine AS runner

WORKDIR /app

# 1. Creazione esplicita dell'utente e gruppo non-root (UID/GID 1001)
RUN addgroup -g 1001 appgroup && \
    adduser -u 1001 -G appgroup -s /bin/sh -D appuser

# 2. Copia dei file dallo stage builder assegnando la proprietà all'utente 1001
COPY --from=builder --chown=appuser:appgroup /app/node_modules ./node_modules
COPY --from=builder --chown=appuser:appgroup /app/package*.json ./
COPY --from=builder --chown=appuser:appgroup /app .

# 3. Switch obbligatorio all'utente non-root
USER 1001

ENV NODE_ENV=production \
    PORT=8080

EXPOSE 8080

# Avvia l'applicazione (usa lo start script definito in package.json)
CMD ["npm", "start"]
