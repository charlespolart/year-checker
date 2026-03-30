import { useEffect } from 'react';
import { Platform } from 'react-native';

const cursorSrc = require('../../assets/cursor.gif') as string | { default: string; uri?: string };

// Create a persistent container outside React's tree — only once
let cursorContainer: HTMLDivElement | null = null;
function getCursorContainer(): HTMLDivElement {
  if (!cursorContainer) {
    cursorContainer = document.createElement('div');
    cursorContainer.id = 'custom-cursor-container';
    document.documentElement.appendChild(cursorContainer);
  }
  return cursorContainer;
}

export default function CustomCursor() {
  useEffect(() => {
    if (Platform.OS !== 'web') return;

    const src = typeof cursorSrc === 'string'
      ? cursorSrc
      : (cursorSrc as any)?.default ?? (cursorSrc as any)?.uri ?? '';
    if (!src) return;

    const container = getCursorContainer();

    const img = document.createElement('img');
    img.src = src;
    Object.assign(img.style, {
      position: 'absolute',
      width: '36px',
      height: '36px',
      pointerEvents: 'none',
      zIndex: '99999',
      transform: 'translate(-50%, -50%)',
      display: 'none',
    });
    container.appendChild(img);

    // Hide default cursor
    const style = document.createElement('style');
    style.textContent = `
      *, *::before, *::after,
      html, body, div, span, a, button, input, textarea, select, label,
      [style], [class] {
        cursor: none !important;
      }
    `;
    container.appendChild(style);

    document.documentElement.style.setProperty('cursor', 'none', 'important');
    document.body.style.setProperty('cursor', 'none', 'important');

    const update = (x: number, y: number) => {
      img.style.left = x + 'px';
      img.style.top = y + 'px';
    };

    const onMouseMove = (e: MouseEvent) => {
      img.style.display = '';
      update(e.pageX, e.pageY);
    };

    const onTouchStart = (e: TouchEvent) => {
      img.style.display = 'block';
      const t = e.touches[0];
      update(t.pageX, t.pageY);
      requestAnimationFrame(() => {
        if (e.touches[0]) update(e.touches[0].pageX, e.touches[0].pageY);
      });
    };

    const onTouchMove = (e: TouchEvent) => {
      img.style.display = 'block';
      const t = e.touches[0];
      update(t.pageX, t.pageY);
    };

    document.addEventListener('mousemove', onMouseMove, { passive: true });
    document.addEventListener('touchstart', onTouchStart, { passive: true, capture: true });
    document.addEventListener('touchmove', onTouchMove, { passive: true, capture: true });

    return () => {
      document.removeEventListener('mousemove', onMouseMove);
      document.removeEventListener('touchstart', onTouchStart, { capture: true } as any);
      document.removeEventListener('touchmove', onTouchMove, { capture: true } as any);
      document.documentElement.style.removeProperty('cursor');
      document.body.style.removeProperty('cursor');
      img.remove();
      style.remove();
    };
  }, []);

  return null;
}
