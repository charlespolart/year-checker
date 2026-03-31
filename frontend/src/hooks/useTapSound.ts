import { useRef, useCallback } from 'react';
import { Platform } from 'react-native';
import { Audio } from 'expo-av';

const tapSrc = require('../../assets/dot-tap.mp3');

const SKIP_START = 0.07;
const VOLUME = 0.3;

let audioCtx: AudioContext | null = null;
let audioBuffer: AudioBuffer | null = null;
let initialized = false;

// Initialize AudioContext on first user interaction (any touch/click on the page)
function initOnFirstInteraction() {
  if (initialized || Platform.OS !== 'web') return;
  initialized = true;

  const init = () => {
    document.removeEventListener('touchstart', init, true);
    document.removeEventListener('mousedown', init, true);

    audioCtx = new (window.AudioContext || (window as any).webkitAudioContext)();

    const src = typeof tapSrc === 'string' ? tapSrc :
      (tapSrc as any)?.default ?? (tapSrc as any)?.uri ?? '';
    if (!src) return;

    fetch(src)
      .then(r => r.arrayBuffer())
      .then(buf => audioCtx!.decodeAudioData(buf))
      .then(decoded => { audioBuffer = decoded; })
      .catch(() => {});
  };

  document.addEventListener('touchstart', init, { capture: true, once: true });
  document.addEventListener('mousedown', init, { capture: true, once: true });
}

// Call immediately at module load on web
if (Platform.OS === 'web') {
  initOnFirstInteraction();
}

export function useTapSound() {
  const soundRef = useRef<Audio.Sound | null>(null);

  const play = useCallback(async () => {
    try {
      if (Platform.OS === 'web') {
        if (!audioBuffer || !audioCtx) return;
        if (audioCtx.state === 'suspended') audioCtx.resume();
        const source = audioCtx.createBufferSource();
        source.buffer = audioBuffer;
        const gain = audioCtx.createGain();
        gain.gain.value = VOLUME;
        source.connect(gain);
        gain.connect(audioCtx.destination);
        source.start(0, SKIP_START);
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
