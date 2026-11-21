# Pyinsara (ပဉ္စရာ) starter project

This is a starter kit for the Thoon Powder Shop online store: Myanmar market, red/white/gold brand direction, nationwide delivery.

## Included
- `admin/`: Next.js admin dashboard starter (responsive UI, branded with the supplied logo)
- `supabase/schema.sql`: initial database schema for profiles, categories, products, orders, order items, payment proofs and admin roles, plus initial RLS policies and sample products
- `docs/`: implementation notes

## Important status
This is a development starter, not a deployed or production-ready shop. The dashboard currently shows placeholder metrics. Customer checkout, live inventory reservation, payment-provider integrations, shipping integrations, authentication screens, and production security review still need implementation.

## Setup the admin UI
1. Install Node.js 20+.
2. In `admin/`, run `npm install`.
3. Copy `.env.example` to `.env.local` and fill in your Supabase project URL and anon key.
4. Run `npm run dev`.

## Set up Supabase
1. Create a Supabase project.
2. Open SQL Editor and run `supabase/schema.sql`.
3. Create the owner account through Supabase Auth.
4. Add that account to `public.admin_users` using its Auth user UUID and role `owner`.
5. Configure storage buckets for product photos and payment proof uploads, with appropriate private/public policies before launch.

## Before accepting real orders
- Implement checkout as a trusted server-side transaction/RPC: re-read product prices, validate stock, calculate totals, decrement stock atomically, and create order + items together. Never trust totals sent by the browser.
- Add rate limiting, phone verification if needed, audit logs, backups, and admin MFA.
- Payment methods such as KBZPay, WavePay, AYA Pay, CB Pay, MPU/cards and bank transfer require merchant onboarding and supported API/gateway access. COD can be added as a payment option. Do not store card numbers or banking credentials.
- Set actual product prices, package weights, stock quantities and delivery fees by destination township before launch.
- Have the RLS policies reviewed and test customer/admin access with separate accounts.

## Suggested rollout
Phase 1: product catalogue + COD/manual transfer + order management.
Phase 2: payment-provider integrations and payment-proof review.
Phase 3: nationwide delivery fee matrix, tracking integrations, Android/iOS customer app.
