import * as admin from 'firebase-admin';
import { UserData, UserResponse } from './users.model';

// Inicializa Firebase Admin si aún no está inicializado
if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();
const auth = admin.auth();

export async function createUser(userData: UserData): Promise<UserResponse> {
  try {
    // Crear usuario en Firebase Auth
    const userRecord = await auth.createUser({
      email: userData.email,
      password: userData.password,
      displayName: userData.displayName || '',
      phoneNumber: userData.phoneNumber || null,
    });
    
    // Guardar datos adicionales en Firestore
    await db.collection('users').doc(userRecord.uid).set({
      email: userData.email,
      displayName: userData.displayName || '',
      phoneNumber: userData.phoneNumber || '',
      role: userData.role || 'user',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    
    return { uid: userRecord.uid, success: true };
  } catch (error) {
    console.error('Error creating user:', error);
    throw error;
  }
}