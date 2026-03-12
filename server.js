const express = require('express');
const fs = require('fs');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;
const DATA_FILE = path.join(__dirname, 'data.json');

app.use(express.json());
app.use(express.static(__dirname));

function readData() {
  if (!fs.existsSync(DATA_FILE)) return [];
  try {
    return JSON.parse(fs.readFileSync(DATA_FILE, 'utf8'));
  } catch {
    return [];
  }
}

function writeData(pages) {
  fs.writeFileSync(DATA_FILE, JSON.stringify(pages, null, 2));
}

/* ── SSE: real-time sync between clients ── */
let sseClients = [];

app.get('/api/events', (req, res) => {
  res.writeHead(200, {
    'Content-Type': 'text/event-stream',
    'Cache-Control': 'no-cache',
    'Connection': 'keep-alive',
  });
  res.write('\n');
  sseClients.push(res);
  req.on('close', () => {
    sseClients = sseClients.filter(c => c !== res);
  });
});

function notifyClients() {
  sseClients.forEach(c => c.write('data: update\n\n'));
}

app.get('/api/pages', (req, res) => {
  res.json(readData());
});

app.put('/api/pages', (req, res) => {
  const pages = req.body;
  if (!Array.isArray(pages)) return res.status(400).json({ error: 'Expected array' });
  writeData(pages);
  notifyClients();
  res.json({ ok: true });
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
