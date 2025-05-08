// backend2/swagger.js
import swaggerJsdoc from 'swagger-jsdoc';
import swaggerUi from 'swagger-ui-express';

// Opciones de swagger-jsdoc
const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'API Backend2',
      version: '1.0.0',
      description: 'Documentación Swagger de la API de planchas/ventas',
    },
    servers: [
      { url: 'http://localhost:3000', description: 'Servidor local' },
    ],
  },
  // Dónde buscar las anotaciones JSDoc en tu código
  apis: ['./index.js', './routes/*.js'], 
};

const swaggerSpec = swaggerJsdoc(options);

export function setupSwagger(app) {
  app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));
}
