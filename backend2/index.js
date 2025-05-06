// backend2/index.js
import express from 'express';
import admin from './firebaseConfig.js';

const app = express();
const PORT = process.env.PORT || 3000;

app.get('/api/query', async (req, res) => {
  const q = req.query.q || '';

  // Sólo tratamos de usar Firestore si la app está inicializada
  if (admin.apps && admin.apps.length > 0) {
    const db = admin.firestore();
    // Ejemplo: guardar la consulta
    // await db.collection('queries').add({ texto: q, ts: Date.now() });
  } else {
    // En test o si no hay credenciales, simplemente no guardamos nada
    console.log('⚠️ Firebase Admin no inicializado, salto guardado en Firestore');
  }

  res.json({ resultado: `Recibido: ${q}` });
});

// Exporta la app para Supertest
export default app;

// Arranca el servidor sólo si index.js se ejecuta directamente
if (import.meta.url === `file://${process.argv[1]}`) {
  app.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
  });
}
