import { Router } from 'express';
import { z } from 'zod';
import { db } from '../db/index.js';
import { pages, cells, legends } from '../db/schema.js';
import { requireAuth } from '../middleware/auth.js';
import { validate } from '../middleware/validate.js';
import { broadcast } from '../lib/ws.js';
import { eq, and, asc } from 'drizzle-orm';

const router = Router();
router.use(requireAuth);

// Get all pages for user
router.get('/', async (req, res) => {
  try {
    const result = await db.select()
      .from(pages)
      .where(eq(pages.userId, req.userId!))
      .orderBy(asc(pages.position));
    res.json(result);
  } catch (err) {
    console.error('Get pages error:', err);
    res.status(500).json({ error: 'Server error' });
  }
});

const createPageSchema = z.object({
  title: z.string().min(1).max(200).default('New Tracker'),
  position: z.number().int().min(0).default(0),
});

// Create page
router.post('/', validate(createPageSchema), async (req, res) => {
  try {
    const [page] = await db.insert(pages)
      .values({ userId: req.userId!, ...req.body })
      .returning();
    broadcast(req.userId!, 'page:created', page);
    res.status(201).json(page);
  } catch (err) {
    console.error('Create page error:', err);
    res.status(500).json({ error: 'Server error' });
  }
});

const updatePageSchema = z.object({
  title: z.string().min(1).max(200).optional(),
  position: z.number().int().min(0).optional(),
});

// Update page
router.patch('/:id', validate(updatePageSchema), async (req, res) => {
  try {
    const [page] = await db.update(pages)
      .set(req.body)
      .where(and(eq(pages.id, String(req.params.id)), eq(pages.userId, req.userId!)))
      .returning();
    if (!page) { res.status(404).json({ error: 'Page not found' }); return; }
    broadcast(req.userId!, 'page:updated', page);
    res.json(page);
  } catch (err) {
    console.error('Update page error:', err);
    res.status(500).json({ error: 'Server error' });
  }
});

// Delete page
router.delete('/:id', async (req, res) => {
  try {
    const [page] = await db.delete(pages)
      .where(and(eq(pages.id, String(req.params.id)), eq(pages.userId, req.userId!)))
      .returning({ id: pages.id });
    if (!page) { res.status(404).json({ error: 'Page not found' }); return; }
    broadcast(req.userId!, 'page:deleted', { id: page.id });
    res.json({ ok: true });
  } catch (err) {
    console.error('Delete page error:', err);
    res.status(500).json({ error: 'Server error' });
  }
});

export default router;
