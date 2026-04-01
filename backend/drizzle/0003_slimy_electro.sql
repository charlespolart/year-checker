ALTER TABLE "cells" ADD COLUMN "comment" text;--> statement-breakpoint
ALTER TABLE "pages" ADD COLUMN "year" integer DEFAULT 2026 NOT NULL;