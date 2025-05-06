// backend2/index.js
import express from 'express';
import admin from './firebaseConfig.js';

const db = admin.firestore();
const app = express();
app.use(express.json());

// Listar todas las planchas
app.get('/planchas', async (req, res) => {
  const snapshot = await db.collection('planchas').get();
  const data = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
  res.json(data);
});

app.listen(3000,()=> console.log('API Firestore OK'));