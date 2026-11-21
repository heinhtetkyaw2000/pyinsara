-- Pyinsara (ထွန်းအမှုန့်စုံ) initial Supabase schema
create extension if not exists pgcrypto;

create type public.order_status as enum ('pending','confirmed','packing','shipped','delivered','cancelled');
create type public.payment_status as enum ('unpaid','pending_verification','paid','failed','refunded');

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  phone text,
  address text,
  township text,
  city text,
  created_at timestamptz not null default now()
);

create table public.categories (
  id uuid primary key default gen_random_uuid(),
  name_my text not null,
  slug text unique not null,
  image_url text,
  is_active boolean not null default true,
  sort_order int not null default 0,
  created_at timestamptz not null default now()
);

create table public.products (
  id uuid primary key default gen_random_uuid(),
  category_id uuid references public.categories(id) on delete set null,
  name_my text not null,
  description_my text,
  sku text unique,
  price_mmk numeric(12,2) not null check (price_mmk >= 0),
  stock_qty int not null default 0 check (stock_qty >= 0),
  unit_label text not null default 'ထုပ်',
  image_url text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.orders (
  id uuid primary key default gen_random_uuid(),
  order_number text unique not null,
  customer_id uuid references public.profiles(id) on delete set null,
  customer_name text not null,
  phone text not null,
  delivery_address text not null,
  township text,
  city text,
  note text,
  status public.order_status not null default 'pending',
  subtotal_mmk numeric(12,2) not null check (subtotal_mmk >= 0),
  delivery_fee_mmk numeric(12,2) not null default 0 check (delivery_fee_mmk >= 0),
  total_mmk numeric(12,2) not null check (total_mmk >= 0),
  payment_method text not null default 'cod',
  payment_status public.payment_status not null default 'unpaid',
  tracking_number text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders(id) on delete cascade,
  product_id uuid references public.products(id) on delete set null,
  product_name_my text not null,
  unit_price_mmk numeric(12,2) not null check (unit_price_mmk >= 0),
  quantity int not null check (quantity > 0),
  line_total_mmk numeric(12,2) not null check (line_total_mmk >= 0)
);

create table public.payment_proofs (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders(id) on delete cascade,
  method text not null,
  transaction_reference text,
  proof_image_url text,
  status public.payment_status not null default 'pending_verification',
  submitted_at timestamptz not null default now()
);

create table public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  role text not null check (role in ('owner','manager','fulfillment')) default 'manager',
  created_at timestamptz not null default now()
);

create index products_active_idx on public.products(is_active, created_at desc);
create index orders_created_idx on public.orders(created_at desc);
create index orders_status_idx on public.orders(status);
create index order_items_order_idx on public.order_items(order_id);

create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path = public
as $$ select exists (select 1 from public.admin_users where user_id = auth.uid()); $$;

alter table public.profiles enable row level security;
alter table public.categories enable row level security;
alter table public.products enable row level security;
alter table public.orders enable row level security;
alter table public.order_items enable row level security;
alter table public.payment_proofs enable row level security;
alter table public.admin_users enable row level security;

create policy "customers read own profile" on public.profiles for select using (id = auth.uid() or public.is_admin());
create policy "customers update own profile" on public.profiles for update using (id = auth.uid()) with check (id = auth.uid());
create policy "public read active categories" on public.categories for select using (is_active or public.is_admin());
create policy "admin manage categories" on public.categories for all using (public.is_admin()) with check (public.is_admin());
create policy "public read active products" on public.products for select using (is_active or public.is_admin());
create policy "admin manage products" on public.products for all using (public.is_admin()) with check (public.is_admin());
create policy "customer read own orders" on public.orders for select using (customer_id = auth.uid() or public.is_admin());
create policy "customer create own orders" on public.orders for insert with check (customer_id = auth.uid() or customer_id is null);
create policy "admin update orders" on public.orders for update using (public.is_admin()) with check (public.is_admin());
create policy "customer read own order items" on public.order_items for select using (exists (select 1 from public.orders o where o.id = order_id and (o.customer_id = auth.uid() or public.is_admin())));
create policy "customer add own order items" on public.order_items for insert with check (exists (select 1 from public.orders o where o.id = order_id and (o.customer_id = auth.uid() or o.customer_id is null)));
create policy "admin manage order items" on public.order_items for all using (public.is_admin()) with check (public.is_admin());
create policy "customer read own payment proofs" on public.payment_proofs for select using (exists (select 1 from public.orders o where o.id = order_id and (o.customer_id = auth.uid() or public.is_admin())));
create policy "customer submit payment proof" on public.payment_proofs for insert with check (exists (select 1 from public.orders o where o.id = order_id and (o.customer_id = auth.uid() or o.customer_id is null)));
create policy "admin manage payment proofs" on public.payment_proofs for all using (public.is_admin()) with check (public.is_admin());
create policy "admin list admins" on public.admin_users for select using (public.is_admin());

-- Seed starter categories and example products; edit prices/stock before launch.
insert into public.categories(name_my,slug,sort_order) values
('နနွင်းမှုန့်','turmeric',1),('ငရုတ်သီးမှုန့်','chili',2),('ဟင်းခတ်အမွှေးအကြိုင်','spices',3),('အခြားပစ္စည်းများ','other',4)
on conflict (slug) do nothing;

insert into public.products(name_my,sku,price_mmk,stock_qty,unit_label,category_id)
select 'နနွင်းမှုန့်','PAN-TUR-001',3500,0,'၁ ထုပ်',id from public.categories where slug='turmeric'
on conflict (sku) do nothing;
insert into public.products(name_my,sku,price_mmk,stock_qty,unit_label,category_id)
select 'ငရုတ်သီးမှုန့်','PAN-CHI-001',4000,0,'၁ ထုပ်',id from public.categories where slug='chili'
on conflict (sku) do nothing;
