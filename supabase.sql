-- Skema untuk PWA Launcher.
-- Direkonstruksi dari query di index.html. Bandingkan dengan tabel `apps`
-- di project Supabase kamu sebelum menjalankannya di project yang sudah berjalan.

create table if not exists public.apps (
  id          bigint generated always as identity primary key,
  user_id     uuid not null default auth.uid() references auth.users(id) on delete cascade,
  name        text not null,
  url         text not null,
  repo_url    text not null,
  icon_url    text,
  sort_order  integer not null default 0,
  created_at  timestamptz not null default now()
);

create index if not exists apps_user_sort_idx on public.apps (user_id, sort_order, created_at);

alter table public.apps enable row level security;

drop policy if exists "apps_select_own" on public.apps;
drop policy if exists "apps_insert_own" on public.apps;
drop policy if exists "apps_update_own" on public.apps;
drop policy if exists "apps_delete_own" on public.apps;

create policy "apps_select_own" on public.apps
  for select using (auth.uid() = user_id);

create policy "apps_insert_own" on public.apps
  for insert with check (auth.uid() = user_id);

create policy "apps_update_own" on public.apps
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "apps_delete_own" on public.apps
  for delete using (auth.uid() = user_id);
