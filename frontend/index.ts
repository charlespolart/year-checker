import { Platform } from 'react-native';
import { registerRootComponent } from 'expo';

import App from './App';

// Suppress known React 19 + Expo dev-mode DOM error (facebook/react#17256)
if (Platform.OS === 'web' && __DEV__) {
  window.addEventListener('error', (e) => {
    if (e.message?.includes('removeChild')) e.preventDefault();
  });
  window.addEventListener('unhandledrejection', (e) => {
    if (String(e.reason)?.includes('removeChild')) e.preventDefault();
  });
  const origError = console.error;
  console.error = (...args: any[]) => {
    if (typeof args[0] === 'string' && args[0].includes('removeChild')) return;
    origError.apply(console, args);
  };
}

registerRootComponent(App);
