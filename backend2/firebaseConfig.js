// backend2/firebaseConfig.js
import admin from 'firebase-admin';
import { createRequire } from 'module';
const require = createRequire(import.meta.url);

if (process.env.NODE_ENV !== 'test') {
  let serviceAccount;
  try {
    serviceAccount = require('./serviceAccountKey.json');
  } catch {
    console.error('⚠️ Omitting Firebase Admin init: serviceAccountKey.json not found');
  }
  if (serviceAccount) {
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
    });
  }
}

export default admin;
