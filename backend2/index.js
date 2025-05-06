// backend2/index.js
import express from 'express';
import admin from './firebaseConfig.js';

//const db = admin.firestore();
const app = express();
app.use(express.json());

// Listar todas las planchas
app.get('/planchas', async (req, res) => {

  let data = [];
  
  if (admin.apps.length > 0) {
    const db = admin.firestore();
    const snapshot = await db.collection('planchas').get();
    data = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
  }

  res.json(data);
  
  });

export default app;

// Sólo arranca el servidor si este módulo se ejecuta directamente:
if (import.meta.url === `file://${process.argv[1]}`) {
  app.listen(PORT, () => console.log(`Servidor corriendo en http://localhost:${PORT}`));
}