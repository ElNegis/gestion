import * as functions from 'firebase-functions';
import * as userService from './users.service';
import { UserData } from './users.model';

// Función HTTP para crear usuario
export const createUser = functions.https.onCall(
  async (data: UserData, context: functions.https.CallableContext) => {
    // Verificar si el usuario tiene permisos (opcional)
    if (context.auth?.token.role !== 'admin') {
      throw new functions.https.HttpsError(
        'permission-denied',
        'Solo administradores pueden crear usuarios'
      );
    }
    
    try {
      const result = await userService.createUser(data);
      return { success: true, uid: result.uid };
    } catch (error: any) {
      throw new functions.https.HttpsError(
        'internal',
        'Error al crear usuario',
        error.message
      );
    }
  }
);