import React, { createContext, useContext, useState, useEffect, useCallback } from 'react';
import * as api from '../lib/api';
import { connectWs, disconnectWs } from '../lib/ws';

interface AuthState {
  isLoading: boolean;
  isAuthenticated: boolean;
  emailVerified: boolean;
  login: (email: string, password: string) => Promise<void>;
  register: (email: string, password: string) => Promise<void>;
  logout: () => Promise<void>;
  resendVerification: () => Promise<void>;
  setEmailVerified: (v: boolean) => void;
}

const AuthContext = createContext<AuthState>({
  isLoading: true,
  isAuthenticated: false,
  emailVerified: true,
  login: async () => {},
  register: async () => {},
  logout: async () => {},
  resendVerification: async () => {},
  setEmailVerified: () => {},
});

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [isLoading, setIsLoading] = useState(true);
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [emailVerified, setEmailVerified] = useState(true);

  useEffect(() => {
    api.setOnAuthExpired(() => {
      setIsAuthenticated(false);
      disconnectWs();
    });

    api.tryRestoreSession().then((ok) => {
      setIsAuthenticated(ok);
      if (ok) connectWs();
      setIsLoading(false);
    });
  }, []);

  const loginFn = useCallback(async (email: string, password: string) => {
    const data = await api.login(email, password);
    setEmailVerified(data.emailVerified ?? true);
    setIsAuthenticated(true);
    connectWs();
  }, []);

  const registerFn = useCallback(async (email: string, password: string) => {
    const data = await api.register(email, password);
    setEmailVerified(data.emailVerified ?? false);
    setIsAuthenticated(true);
    connectWs();
  }, []);

  const logoutFn = useCallback(async () => {
    await api.logout();
    setIsAuthenticated(false);
    setEmailVerified(true);
    disconnectWs();
  }, []);

  const resendVerification = useCallback(async () => {
    await api.apiFetch('/auth/resend-verification', { method: 'POST' });
  }, []);

  return (
    <AuthContext.Provider value={{
      isLoading, isAuthenticated, emailVerified,
      login: loginFn, register: registerFn, logout: logoutFn,
      resendVerification, setEmailVerified,
    }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  return useContext(AuthContext);
}
