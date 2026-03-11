# FreightBrain Technical Architecture Document
**Version 1.0 — March 2026**
*Prepared by Clawdia for Victor Caballero / Noxterra Trucking*

---

## Section 1: Multi-Tenant Migration Plan (Supabase)

### Overview

Adding a `fleets` table and `fleet_id` column to every existing table, then locking down with Row Level Security. Each tenant only sees their own data. Noxterra seeds as `fleet_id = '00000000-0000-0000-0000-000000000001'`.

### Migration SQL

```sql
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
VALUES (
  '00000000-0000-0000-0000-000000000001',
  'Noxterra Trucking',
  'admin@noxterra.co',
  'pro'
) ON CONFLICT (id) DO NOTHING;

-- STEP 3: Add fleet_id to all existing tables (backfills to Noxterra)
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

-- STEP 6: Enable RLS
ALTER TABLE public.fleets          ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.loads           ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.drivers         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vehicles        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sms_log         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bols            ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.expenses        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.breakdowns      ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mileage         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mileage_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.rate_cons       ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.gov_contracts   ENABLE ROW LEVEL SECURITY;

-- STEP 7: JWT helper + RLS policies
CREATE OR REPLACE FUNCTION public.my_fleet_id()
RETURNS UUID LANGUAGE sql STABLE AS $$
  SELECT COALESCE(
    (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'fleet_id')::UUID,
    NULL
  );
$$;

CREATE POLICY "Fleet owner reads own fleet"  ON public.fleets FOR SELECT USING (id = public.my_fleet_id());
CREATE POLICY "Fleet owner updates own fleet" ON public.fleets FOR UPDATE USING (id = public.my_fleet_id());

CREATE POLICY "Fleet sees own loads"           ON public.loads           FOR ALL USING (fleet_id = public.my_fleet_id()) WITH CHECK (fleet_id = public.my_fleet_id());
CREATE POLICY "Fleet sees own drivers"         ON public.drivers         FOR ALL USING (fleet_id = public.my_fleet_id()) WITH CHECK (fleet_id = public.my_fleet_id());
CREATE POLICY "Fleet sees own vehicles"        ON public.vehicles        FOR ALL USING (fleet_id = public.my_fleet_id()) WITH CHECK (fleet_id = public.my_fleet_id());
CREATE POLICY "Fleet sees own messages"        ON public.messages        FOR ALL USING (fleet_id = public.my_fleet_id()) WITH CHECK (fleet_id = public.my_fleet_id());
CREATE POLICY "Fleet sees own sms_log"         ON public.sms_log         FOR ALL USING (fleet_id = public.my_fleet_id()) WITH CHECK (fleet_id = public.my_fleet_id());
CREATE POLICY "Fleet sees own bols"            ON public.bols            FOR ALL USING (fleet_id = public.my_fleet_id()) WITH CHECK (fleet_id = public.my_fleet_id());
CREATE POLICY "Fleet sees own expenses"        ON public.expenses        FOR ALL USING (fleet_id = public.my_fleet_id()) WITH CHECK (fleet_id = public.my_fleet_id());
CREATE POLICY "Fleet sees own breakdowns"      ON public.breakdowns      FOR ALL USING (fleet_id = public.my_fleet_id()) WITH CHECK (fleet_id = public.my_fleet_id());
CREATE POLICY "Fleet sees own mileage"         ON public.mileage         FOR ALL USING (fleet_id = public.my_fleet_id()) WITH CHECK (fleet_id = public.my_fleet_id());
CREATE POLICY "Fleet sees own mileage_records" ON public.mileage_records FOR ALL USING (fleet_id = public.my_fleet_id()) WITH CHECK (fleet_id = public.my_fleet_id());
CREATE POLICY "Fleet sees own rate_cons"       ON public.rate_cons       FOR ALL USING (fleet_id = public.my_fleet_id()) WITH CHECK (fleet_id = public.my_fleet_id());
CREATE POLICY "Fleet sees own gov_contracts"   ON public.gov_contracts   FOR ALL USING (fleet_id = public.my_fleet_id()) WITH CHECK (fleet_id = public.my_fleet_id());

-- STEP 8: Note — Fly.io Node backend uses service role key (bypasses RLS by design)
-- Driver PWA uses anon key + JWT → RLS enforces automatically
```

### JWT Setup (one-time per user)
```javascript
await supabaseAdmin.auth.admin.updateUserById(userId, {
  app_metadata: { fleet_id: 'their-fleet-uuid' }
});
```

---

## Section 2: Driver PWA Spec

### Stack: React + Vite + vite-plugin-pwa
- React 18 + Vite (not Next.js — offline-first, simpler)
- vite-plugin-pwa (Workbox)
- @supabase/supabase-js
- TanStack React Query (caching + offline)
- Tailwind CSS
- react-router-dom v6

### Auth: Phone number + SMS OTP (no passwords)
Supabase OTP built-in. Driver enters phone → gets 6-digit code → logged in.
JWT automatically contains fleet_id → RLS enforces data isolation.

### Key Screens
1. **Today's Load** — load number, status badge, pickup/delivery addresses, commodity/weight/miles/rate
2. **BOL Submission** — tap to camera, preview, upload to Supabase Storage, insert bols record
3. **Check-In/Check-Out** — status timeline: assigned → at_pickup → in_transit → at_delivery → delivered. Each tap logs GPS coords + timestamps to loads table.
4. **Message AI** — chat UI, realtime via Supabase channels, messages sent to webhook for AI response

### Deployment
- Cloudflare Pages (free CDN, instant global)
- URL: drivers.freightbrain.io

---

## Section 3: SMS AI Response Architecture

### Current State
Twilio webhook → https://freight-brain-noxterra.fly.dev/webhook/sms → logs to sms_log. No AI response.

### Target Flow
```
Driver texts Twilio number
  → Fly.io webhook receives POST
  → Look up driver by phone in drivers table
  → Fetch driver's current load + last 10 messages
  → Call Anthropic API with context
  → Send response via Twilio
  → Log to messages table
```

### Implementation (webhook/sms.js)

```javascript
import Anthropic from '@anthropic-ai/sdk';
import twilio from 'twilio';
import { createClient } from '@supabase/supabase-js';

const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_SERVICE_KEY);
const anthropic = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY });
const twilioClient = twilio(process.env.TWILIO_ACCOUNT_SID, process.env.TWILIO_AUTH_TOKEN);

export async function handleSmsWebhook(req, res) {
  const { From: fromPhone, Body: messageBody } = req.body;

  // 1. Look up driver
  const { data: driver } = await supabase
    .from('drivers')
    .select('id, name, fleet_id, status')
    .eq('phone', fromPhone.replace('+1', ''))
    .single();

  if (!driver) {
    await sendSms(fromPhone, "Hi! I don't recognize this number. Contact your dispatcher.");
    return res.sendStatus(200);
  }

  // 2. Get current load
  const { data: currentLoad } = await supabase
    .from('loads')
    .select('*')
    .eq('assigned_driver_id', driver.id)
    .in('status', ['assigned', 'at_pickup', 'in_transit', 'at_delivery'])
    .order('pickup_date', { ascending: true })
    .limit(1)
    .single();

  // 3. Get recent message history
  const { data: recentMessages } = await supabase
    .from('messages')
    .select('direction, body, created_at')
    .eq('driver_id', driver.id)
    .order('created_at', { ascending: false })
    .limit(10);

  // 4. Build AI context
  const systemPrompt = `You are Clawdia, the AI dispatcher for FreightBrain. You're texting with ${driver.name}, a truck driver.
  
Current load: ${currentLoad ? JSON.stringify({
    load_number: currentLoad.load_number,
    status: currentLoad.status,
    origin: currentLoad.origin,
    destination: currentLoad.destination,
    pickup_date: currentLoad.pickup_date,
    delivery_date: currentLoad.delivery_date,
    broker: currentLoad.broker
  }) : 'No active load assigned'}

Keep responses SHORT (under 160 chars when possible). Be helpful and direct. 
Handle: load status questions, check-ins, breakdown reports, ETA updates, general questions.
For breakdowns: collect location and issue type, confirm you'll notify dispatch.
For ETAs: acknowledge and note it.`;

  const messageHistory = (recentMessages || [])
    .reverse()
    .map(m => ({ role: m.direction === 'inbound' ? 'user' : 'assistant', content: m.body }));

  // 5. Call Anthropic
  const aiResponse = await anthropic.messages.create({
    model: 'claude-haiku-4-5', // fast + cheap for SMS
    max_tokens: 200,
    system: systemPrompt,
    messages: [...messageHistory, { role: 'user', content: messageBody }]
  });

  const replyText = aiResponse.content[0].text;

  // 6. Log inbound + outbound to messages table
  await supabase.from('messages').insert([
    {
      fleet_id: driver.fleet_id,
      driver_id: driver.id,
      direction: 'inbound',
      channel: 'sms',
      from_number: fromPhone,
      to_number: process.env.TWILIO_PHONE_NUMBER,
      body: messageBody,
      status: 'received'
    },
    {
      fleet_id: driver.fleet_id,
      driver_id: driver.id,
      direction: 'outbound',
      channel: 'sms',
      from_number: process.env.TWILIO_PHONE_NUMBER,
      to_number: fromPhone,
      body: replyText,
      status: 'sent'
    }
  ]);

  // 7. Send SMS reply
  await twilioClient.messages.create({
    body: replyText,
    from: process.env.TWILIO_PHONE_NUMBER,
    to: fromPhone
  });

  res.sendStatus(200);
}

async function sendSms(to, body) {
  return twilioClient.messages.create({
    body, from: process.env.TWILIO_PHONE_NUMBER, to
  });
}
```

### Driver Intent Handling
| Driver says | AI response |
|---|---|
| "what's my load" | Load # + origin/destination + status |
| "checked in" / "arrived" | Acknowledge + update load status |
| "breakdown" / "broke down" | Ask location + issue, alert dispatch |
| "eta [time]" | Acknowledge, note for broker |
| "delivered" | Confirm delivery, ask for BOL photo |

### Model Choice
Use `claude-haiku-4-5` for SMS (fast, cheap, ~$0.001/message).
Use `claude-sonnet-4-6` for complex dispatch decisions in the ops dashboard.

---

## Build Order (Recommended)

1. **Run Supabase migration** — 30 min, zero risk to existing data
2. **Wire SMS AI** — 2-3 hours, immediate driver value
3. **Driver PWA scaffold** — 1 day for auth + Today's Load screen
4. **BOL submission** — 2 hours
5. **Check-in/Check-out** — 2 hours  
6. **Message AI screen in PWA** — 2 hours
7. **Onboarding flow** (new fleet signup) — 1 day

**Total to MVP: ~3-4 days of focused work**

---

*Next fleet to onboard after Noxterra: Lux Xpress, then Decker, Lucero, Trinity.*
