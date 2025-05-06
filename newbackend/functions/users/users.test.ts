import * as admin from 'firebase-admin';
import * as userService from './users.service';
import { UserData } from './users.model';

jest.mock('firebase-admin', () => {
  return {
    apps: [],
    initializeApp: jest.fn(),
    firestore: jest.fn(() => ({
      collection: jest.fn(() => ({
        doc: jest.fn(() => ({
          set: jest.fn().mockResolvedValue({})
        }))
      }))
    })),
    auth: jest.fn(() => ({
      createUser: jest.fn().mockResolvedValue({ uid: 'test-uid' })
    })),
    firestore: {
      FieldValue: {
        serverTimestamp: jest.fn()
      }
    }
  };
});

describe('User Service', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });
  
  test('should create a user successfully', async () => {
    const userData: UserData = {
      email: 'test@example.com',
      password: 'password123',
      displayName: 'Test User'
    };
    
    const result = await userService.createUser(userData);
    
    expect(admin.auth().createUser).toHaveBeenCalledWith({
      email: userData.email,
      password: userData.password,
      displayName: userData.displayName,
      phoneNumber: null
    });
    
    expect(result).toEqual({ uid: 'test-uid', success: true });
  });
});