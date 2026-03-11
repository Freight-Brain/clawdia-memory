-- ============================================================
-- FreightBrain Migration 001 — Multi-Tenant Foundation
-- Run this in: https://supabase.com/dashboard/project/xcckvedehcoskpylusmn/sql
-- ============================================================

-- STEP 1: Create fleets table
CREATE TABLE IF NOT EXISTS public.fleets (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name         TEXT NOT NULL,
  owner_email  TEXT NOT NULL UNIQUE,
  plan         TEXT NOT NULL DEFAULT 'starter' CHECK (plan IN ('starter', 'pro', 'enterprise')),
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- STEP 2: Seed Noxterra as Fleet #1
INSERT INTO public.fleets (id, name, owner_email, plan)
VALUES ('00000000-0000-0000-0000-000000000001', 'Noxterra Trucking', 'admin@noxterra.co', 'pro')
ON CONFLICT (id) DO NOTHING;

-- STEP 3: Add fleet_id to all tables (backfills existing rows to Noxterra)
ALTER TABLE public.loads           ADD COLUMN IF NOT EXISTS fleet_id UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000001';
ALTER TABLE public.drivers         ADD COLUMN IF NOT EXISTS fleet_id UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000001';
ALTER TABLE public.vehicles        ADD COLUMN IF NOT EXISTS fleet_id UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000001';
ALTER TABLE public.messages        ADD COLUMN IF NOT EXISTS fleet_id UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000001';
ALTER TABLE public.sms_log         ADD COLUMN IF NOT EXISTS fleet_id UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000001';
ALTER TABLE public.bols            ADD COLUMN IF NOT EXISTS fleet_id UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000001';
ALTER TABLE public.expenses        ADD COLUMN IF NOT EXISTS fleet_id UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000001';
ALTER TABLE public.breakdowns      ADD COLUMN IF NOT EXISTS fleet_id UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000001';
ALTER TABLE public.mileage         ADD COLUMN IF NOT EXISTS fleet_id UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000001';
ALTER TABLE public.mileage_records ADD COLUMN IF NOT EXISTS fleet_id UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000001';
ALTER TABLE public.rate_cons       ADD COLUMN IF NOT EXISTS fleet_id UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000001';
ALTER TABLE public.gov_contracts   ADD COLUMN IF NOT EXISTS fleet_id UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000001';

-- STEP 4: Drop temp defaults, add FK constraints
ALTER TABLE public.loads           ALTER COLUMN fleet_id DROP DEFAULT;
ALTER TABLE public.drivers         ALTER COLUMN fleet_id DROP DEFAULT;
ALTER TABLE public.vehicles        ALTER COLUMN fleet_id DROP DEFAULT;
ALTER TABLE public.messages        ALTER COLUMN fleet_id DROP DEFAULT;
ALTER TABLE public.sms_log         ALTER COLUMN fleet_id DROP DEFAULT;
ALTER TABLE public.bols            ALTER COLUMN fleet_id DROP DEFAULT;
ALTER TABLE public.expenses        ALTER COLUMN fleet_id DROP DEFAULT;
ALTER TABLE public.breakdowns      ALTER COLUMN fleet_id DROP DEFAULT;
ALTER TABLE public.mileage         ALTER COLUMN fleet_id DROP DEFAULT;
ALTER TABLE public.mileage_records ALTER COLUMN fleet_id DROP DEFAULT;
ALTER TABLE public.rate_cons       ALTER COLUMN fleet_id DROP DEFAULT;
ALTER TABLE public.gov_contracts   ALTER COLUMN fleet_id DROP DEFAULT;

ALTER TABLE public.loads           ADD CONSTRAINT fk_loads_fleet           FOREIGN KEY (fleet_id) REFERENCES public.fleets(id) ON DELETE CASCADE;
ALTER TABLE public.drivers         ADD CONSTRAINT fk_drivers_fleet         FOREIGN KEY (fleet_id) REFERENCES public.fleets(id) ON DELETE CASCADE;
ALTER TABLE public.vehicles        ADD CONSTRAINT fk_vehicles_fleet        FOREIGN KEY (fleet_id) REFERENCES public.fleets(id) ON DELETE CASCADE;
ALTER TABLE public.messages        ADD CONSTRAINT fk_messages_fleet        FOREIGN KEY (fleet_id) REFERENCES public.fleets(id) ON DELETE CASCADE;
ALTER TABLE public.sms_log         ADD CONSTRAINT fk_sms_log_fleet         FOREIGN KEY (fleet_id) REFERENCES public.fleets(id) ON DELETE CASCADE;
ALTER TABLE public.bols            ADD CONSTRAINT fk_bols_fleet            FOREIGN KEY (fleet_id) REFERENCES public.fleets(id) ON DELETE CASCADE;
ALTER TABLE public.expenses        ADD CONSTRAINT fk_expenses_fleet        FOREIGN KEY (fleet_id) REFERENCES public.fleets(id) ON DELETE CASCADE;
ALTER TABLE public.breakdowns      ADD CONSTRAINT fk_breakdowns_fleet      FOREIGN KEY (fleet_id) REFERENCES public.fleets(id) ON DELETE CASCADE;
ALTER TABLE public.mileage         ADD CONSTRAINT fk_mileage_fleet         FOREIGN KEY (fleet_id) REFERENCES public.fleets(id) ON DELETE CASCADE;
ALTER TABLE public.mileage_records ADD CONSTRAINT fk_mileage_records_fleet FOREIGN KEY (fleet_id) REFERENCES public.fleets(id) ON DELETE CASCADE;
ALTER TABLE public.rate_cons       ADD CONSTRAINT fk_rate_cons_fleet       FOREIGN KEY (fleet_id) REFERENCES public.fleets(id) ON DELETE CASCADE;
ALTER TABLE public.gov_contracts   ADD CONSTRAINT fk_gov_contracts_fleet   FOREIGN KEY (fleet_id) REFERENCES public.fleets(id) ON DELETE CASCADE;

-- STEP 5: Indexes
CREATE INDEX IF NOT EXISTS idx_loads_fleet_id           ON public.loads(fleet_id);
CREATE INDEX IF NOT EXISTS idx_drivers_fleet_id         ON public.drivers(fleet_id);
CREATE INDEX IF NOT EXISTS idx_vehicles_fleet_id        ON public.vehicles(fleet_id);
CREATE INDEX IF NOT EXISTS idx_messages_fleet_id        ON public.messages(fleet_id);
CREATE INDEX IF NOT EXISTS idx_sms_log_fleet_id         ON public.sms_log(fleet_id);
CREATE INDEX IF NOT EXISTS idx_bols_fleet_id            ON public.bols(fleet_id);
CREATE INDEX IF NOT EXISTS idx_expenses_fleet_id        ON public.expenses(fleet_id);
CREATE INDEX IF NOT EXISTS idx_breakdowns_fleet_id      ON public.breakdowns(fleet_id);
CREATE INDEX IF NOT EXISTS idx_mileage_fleet_id         ON public.mileage(fleet_id);
CREATE INDEX IF NOT EXISTS idx_mileage_records_fleet_id ON public.mileage_records(fleet_id);
CREATE INDEX IF NOT EXISTS idx_rate_cons_fleet_id       ON public.rate_cons(fleet_id);
CREATE INDEX IF NOT EXISTS idx_gov_contracts_fleet_id   ON public.gov_contracts(fleet_id);

-- ============================================================
-- DONE. Verify with:
-- SELECT id, name, plan FROM public.fleets;
-- SELECT column_name FROM information_schema.columns WHERE table_name = 'loads' AND column_name = 'fleet_id';
-- ============================================================
