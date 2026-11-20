-- VerDvida Manager: cierres administrativos manuales.
-- Independientes de verdvida_sales (tickets) y de los turnos locales de Caja.
CREATE TABLE IF NOT EXISTS public.vd_daily_closings (
  owner_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  day date NOT NULL,
  efectivo numeric(12,2) NOT NULL DEFAULT 0 CHECK (efectivo >= 0),
  transferencias numeric(12,2) NOT NULL DEFAULT 0 CHECK (transferencias >= 0),
  tarjeta numeric(12,2) NOT NULL DEFAULT 0 CHECK (tarjeta >= 0),
  gastos jsonb NOT NULL DEFAULT '[]'::jsonb CHECK (jsonb_typeof(gastos) = 'array'),
  notas text NOT NULL DEFAULT '',
  updated_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (owner_id, day)
);
ALTER TABLE public.vd_daily_closings ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE public.vd_daily_closings FROM anon, authenticated;
GRANT SELECT, INSERT, UPDATE ON TABLE public.vd_daily_closings TO authenticated;
CREATE POLICY "vd_daily_closings_select_own"
  ON public.vd_daily_closings FOR SELECT TO authenticated
  USING (owner_id = (SELECT auth.uid()));
CREATE POLICY "vd_daily_closings_insert_own"
  ON public.vd_daily_closings FOR INSERT TO authenticated
  WITH CHECK (owner_id = (SELECT auth.uid()));
CREATE POLICY "vd_daily_closings_update_own"
  ON public.vd_daily_closings FOR UPDATE TO authenticated
  USING (owner_id = (SELECT auth.uid()))
  WITH CHECK (owner_id = (SELECT auth.uid()));
-- No DELETE para preservar historial de cierres.
