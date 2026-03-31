import { useRef, useCallback } from 'react';
import { Platform } from 'react-native';
import { Audio } from 'expo-av';

const tapSrc = require('../../assets/dot-tap.mp3');

const SKIP_START = 0.07;
const VOLUME = 0.3;

let webAudio: HTMLAudioElement | null = null;
let unlocked = false;

function getWebAudio(): HTMLAudioElement | null {
  if (webAudio) return webAudio;
  const src = typeof tapSrc === 'string' ? tapSrc :
    (tapSrc as any)?.default ?? (tapSrc as any)?.uri ?? '';
  if (!src) return null;
  webAudio = new window.Audio(src);
  webAudio.volume = VOLUME;
  webAudio.preload = 'auto';
  return webAudio;
}

// Unlock audio on first user interaction (required by mobile browsers)
if (typeof document !== 'undefined') {
  const unlock = () => {
    if (unlocked) return;
    unlocked = true;
    const audio = getWebAudio();
    if (audio) {
      audio.muted = true;
      audio.play().then(() => {
        audio.pause();
        audio.muted = false;
        audio.currentTime = 0;
      }).catch(() => {});
    }
    document.removeEventListener('touchstart', unlock, true);
    document.removeEventListener('click', unlock, true);
  };
  document.addEventListener('touchstart', unlock, { capture: true });
  document.addEventListener('click', unlock, { capture: true });
}

export function useTapSound() {
  const soundRef = useRef<Audio.Sound | null>(null);

  const play = useCallback(async () => {
    try {
      if (Platform.OS === 'web') {
        const audio = getWebAudio();
        if (!audio) return;
        audio.currentTime = SKIP_START;
        audio.play().catch(() => {});
      } else {
        if (!soundRef.current) {
          const { sound } = await Audio.Sound.createAsync(tapSrc, { volume: VOLUME });
          soundRef.current = sound;
        }
        await soundRef.current.setPositionAsync(SKIP_START * 1000);
        await soundRef.current.playAsync();
      }
    } catch { /* ignore */ }
  }, []);

  return play;
}
