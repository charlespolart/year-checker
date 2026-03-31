import { useState, useEffect, useCallback } from 'react';
import { apiFetch } from '../lib/api';
import { addWsListener } from '../lib/ws';

export interface Cell {
  pageId: string;
  month: number;
  day: number;
  color: string;
  updatedAt: string;
}

export function useCells(pageId: string | null) {
  const [cells, setCells] = useState<Cell[]>([]);
  const [loading, setLoading] = useState(false);

  const fetchCells = useCallback(async () => {
    if (!pageId) return;
    setLoading(true);
    try {
      const res = await apiFetch(`/cells/${pageId}`);
      if (res.ok) setCells(await res.json());
    } catch { /* ignore */ }
    setLoading(false);
  }, [pageId]);

  useEffect(() => {
    setCells([]);
    fetchCells();
  }, [fetchCells]);

  useEffect(() => {
    return addWsListener((event, data) => {
      if (!pageId) return;
      switch (event) {
        case 'cell:updated':
          if (data.pageId === pageId) {
            setCells(prev => {
              const idx = prev.findIndex(c => c.month === data.month && c.day === data.day);
              if (idx >= 0) return prev.map((c, i) => i === idx ? data : c);
              return [...prev, data];
            });
          }
          break;
        case 'cell:deleted':
          if (data.pageId === pageId) {
            setCells(prev => prev.filter(c => !(c.month === data.month && c.day === data.day)));
          }
          break;
        case 'cells:reset':
          if (data.pageId === pageId) setCells([]);
          break;
        case 'cells:recolored':
          if (data.pageId === pageId && data.colorMap) {
            setCells(prev => prev.map(c => {
              const newColor = data.colorMap[c.color.toUpperCase()] || data.colorMap[c.color];
              return newColor ? { ...c, color: newColor } : c;
            }));
          }
          break;
      }
    });
  }, [pageId]);

  const setCell = useCallback((month: number, day: number, color: string) => {
    if (!pageId) return;
    // Optimistic update
    const prev = cells.find(c => c.month === month && c.day === day);
    setCells(old => {
      const idx = old.findIndex(c => c.month === month && c.day === day);
      const cell = { pageId, month, day, color, updatedAt: new Date().toISOString() };
      if (idx >= 0) return old.map((c, i) => i === idx ? cell : c);
      return [...old, cell];
    });
    // Send request in background, revert on failure
    apiFetch(`/cells/${pageId}`, {
      method: 'PUT',
      body: JSON.stringify({ month, day, color }),
    }).catch(() => {
      // Revert
      if (prev) setCells(old => old.map(c => (c.month === month && c.day === day) ? prev : c));
      else setCells(old => old.filter(c => !(c.month === month && c.day === day)));
    });
  }, [pageId, cells]);

  const deleteCell = useCallback((month: number, day: number) => {
    if (!pageId) return;
    // Optimistic update
    const prev = cells.find(c => c.month === month && c.day === day);
    setCells(old => old.filter(c => !(c.month === month && c.day === day)));
    // Send request in background, revert on failure
    apiFetch(`/cells/${pageId}`, {
      method: 'DELETE',
      body: JSON.stringify({ month, day }),
    }).catch(() => {
      if (prev) setCells(old => [...old, prev]);
    });
  }, [pageId, cells]);

  const resetAll = useCallback(async () => {
    if (!pageId) return;
    await apiFetch(`/cells/${pageId}/all`, { method: 'DELETE' });
  }, [pageId]);

  const getCellColor = useCallback((month: number, day: number): string | null => {
    const cell = cells.find(c => c.month === month && c.day === day);
    return cell?.color ?? null;
  }, [cells]);

  return { cells, loading, setCell, deleteCell, resetAll, getCellColor, refetch: fetchCells };
}
