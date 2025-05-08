// backend2/index.js
import express from 'express';
import admin from './firebaseConfig.js';

//const db = admin.firestore();
const app = express();
app.use(express.json());

app.get('/api/query', (req, res) => {
  const q = req.query.q || '';
  return res.json({ resultado: `Recibido: ${q}` });
});

// Listar todas las planchas
/**
 * @openapi
 * /planchas:
 *   get:
 *     summary: Listar todas las planchas
 *     responses:
 *       200:
 *         description: Lista de planchas
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   id:
 *                     type: string
 *                   tipo:
 *                     type: string
 */
app.get('/planchas', async (req, res) => { /* ... */ });

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

app.post('/planchas', async (req, res) => {

  let id = null;
  
  if (admin.apps.length > 0) {
  
    const db = admin.firestore();
    const ref = await db.collection('planchas').add(req.body);
    id = ref.id;
  }
  
  res.json({ id });
  
});
  
  

if (process.env.NODE_ENV !== 'test') {
  const PORT = process.env.PORT || 3000;
  app.listen(PORT, () => console.log(`Servidor corriendo en http://localhost:${PORT}`));
}