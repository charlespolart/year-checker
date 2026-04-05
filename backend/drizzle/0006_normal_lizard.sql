ALTER TABLE "users" ADD COLUMN "theme" text DEFAULT 'defaultTheme' NOT NULL;--> statement-breakpoint
ALTER TABLE "users" ADD COLUMN "language" text;--> statement-breakpoint
ALTER TABLE "users" ADD COLUMN "cursor_id" text DEFAULT 'cat' NOT NULL;--> statement-breakpoint
ALTER TABLE "users" ADD COLUMN "cursor_enabled" boolean DEFAULT false NOT NULL;