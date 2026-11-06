// src/environments/environment.prod.ts
export const environment = {
  production: true,
  apiUrl: 'http://teams-api-service:4200' // Kubernetes service name
  keycloak: {
    url: 'http://platform-auth.127.0.0.1.sslip.io:8082',
    realm: 'teams',
    clientId: 'teams-ui'
  }
};
