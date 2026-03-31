import { useRef, useCallback, useEffect } from 'react';
import { Platform } from 'react-native';
import { Audio } from 'expo-av';

const tapSrc = require('../../assets/dot-tap.mp3');

const SKIP_START = 0.07; // Skip silence at start
const VOLUME = 0.3;

// Web: use AudioContext for instant playback on iOS Safari
let audioCtx: AudioContext | null = null;
let audioBuffer: AudioBuffer | null = null;
let bufferLoading = false;

function getAudioContext(): AudioContext {
  if (!audioCtx) {
    audioCtx = new (window.AudioContext || (window as any).webkitAudioContext)();
  }
  // Resume if suspended (iOS requires user gesture)
  if (audioCtx.state === 'suspended') {
    audioCtx.resume();
  }
  return audioCtx;
}

async function loadBuffer() {
  if (audioBuffer || bufferLoading) return;
  bufferLoading = true;
  try {
    const src = typeof tapSrc === 'string' ? tapSrc :
      (tapSrc as any)?.default ?? (tapSrc as any)?.uri ?? '';
    if (!src) return;
    const ctx = getAudioContext();
    const response = await fetch(src);
    const arrayBuffer = await response.arrayBuffer();
    audioBuffer = await ctx.decodeAudioData(arrayBuffer);
  } catch { /* ignore */ }
  bufferLoading = false;
}

function playWebAudio() {
  if (!audioBuffer) return;
  const ctx = getAudioContext();
  const source = ctx.createBufferSource();
  source.buffer = audioBuffer;
  const gain = ctx.createGain();
  gain.gain.value = VOLUME;
  source.connect(gain);
  gain.connect(ctx.destination);
  source.start(0, SKIP_START);
}

export function useTapSound() {
  const soundRef = useRef<Audio.Sound | null>(null);

  useEffect(() => {
    if (Platform.OS === 'web') {
      loadBuffer();
    }
  }, []);

  const play = useCallback(async () => {
    try {
      if (Platform.OS === 'web') {
        playWebAudio();
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
