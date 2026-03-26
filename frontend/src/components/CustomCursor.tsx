import { useEffect } from 'react';
import { Platform } from 'react-native';

// On web, require() returns the URL string directly via the bundler
const cursorSrc = require('../../assets/cursor.gif') as string | { default: string; uri?: string };

export default function CustomCursor() {
  useEffect(() => {
    if (Platform.OS !== 'web') return;

    const src = typeof cursorSrc === 'string'
      ? cursorSrc
      : (cursorSrc as any)?.default ?? (cursorSrc as any)?.uri ?? '';
    if (!src) return;

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
    document.body.appendChild(img);

    // Hide default cursor — aggressive rule covering all elements and states
    const style = document.createElement('style');
    style.textContent = `
      *, *::before, *::after,
      html, body, div, span, a, button, input, textarea, select, label,
      [style], [class] {
        cursor: none !important;
      }
    `;
    document.head.appendChild(style);

    // Also set cursor on html/body directly for edge cases
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
    document.body.addEventListener('touchstart', onTouchStart, { passive: true, capture: true });
    document.body.addEventListener('touchmove', onTouchMove, { passive: true, capture: true });

    return () => {
      document.removeEventListener('mousemove', onMouseMove);
      document.body.removeEventListener('touchstart', onTouchStart, { capture: true } as any);
      document.body.removeEventListener('touchmove', onTouchMove, { capture: true } as any);
      document.documentElement.style.removeProperty('cursor');
      document.body.style.removeProperty('cursor');
      img.remove();
      style.remove();
    };
  }, []);

  return null;
}
