import { WebSocketServer, WebSocket } from 'ws';
import type { Server } from 'http';
import { verifyAccessToken } from './jwt.js';

// Map userId -> Set of connected WebSockets
const clients = new Map<string, Set<WebSocket>>();

export function setupWebSocket(server: Server) {
  const wss = new WebSocketServer({ server, path: '/ws' });

  wss.on('connection', async (ws, req) => {
    const url = new URL(req.url || '', `http://${req.headers.host}`);
    const token = url.searchParams.get('token');

    if (!token) {
      ws.close(4001, 'Missing token');
      return;
    }

    let userId: string;
    try {
      userId = await verifyAccessToken(token);
    } catch {
      ws.close(4003, 'Invalid token');
      return;
    }

    if (!clients.has(userId)) clients.set(userId, new Set());
    clients.get(userId)!.add(ws);

    ws.on('close', () => {
      clients.get(userId)?.delete(ws);
      if (clients.get(userId)?.size === 0) clients.delete(userId);
    });
  });
}

export function broadcast(userId: string, event: string, data: unknown, excludeWs?: WebSocket) {
  const userClients = clients.get(userId);
  if (!userClients) return;
  const message = JSON.stringify({ event, data });
  for (const ws of userClients) {
    if (ws !== excludeWs && ws.readyState === WebSocket.OPEN) {
      ws.send(message);
    }
  }
}
