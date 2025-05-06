export interface UserData {
    email: string;
    password: string;
    displayName?: string;
    phoneNumber?: string;
    role?: string;
  }
  
  export interface UserResponse {
    uid: string;
    success: boolean;
  }