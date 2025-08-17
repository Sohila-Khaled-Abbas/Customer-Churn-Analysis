-- Helpers to refresh materialized views in dependency order.

SET search_path = telecom, public;

CREATE OR REPLACE FUNCTION refresh_churn_materialized_views()
RETURNS void LANGUAGE plpgsql AS $$
BEGIN
  PERFORM 1;
  -- Refresh dimensionally-light MVs (no CONCURRENTLY due to lack of unique indexes)
  REFRESH MATERIALIZED VIEW mv_kpis;
  REFRESH MATERIALIZED VIEW mv_churn_by_contract;
  REFRESH MATERIALIZED VIEW mv_churn_by_internet_type;
  REFRESH MATERIALIZED VIEW mv_churn_by_payment_method;
  REFRESH MATERIALIZED VIEW mv_levers_matrix;
  REFRESH MATERIALIZED VIEW mv_churn_by_offer;
  REFRESH MATERIALIZED VIEW mv_value_segment;
  REFRESH MATERIALIZED VIEW mv_retention_targets;
  REFRESH MATERIALIZED VIEW mv_geo_zip;
END;
$$;

-- Example cron with pg_cron (if installed):
-- SELECT cron.schedule('telco_mv_refresh', '0 6 * * *', $$SELECT telecom.refresh_churn_materialized_views();$$);
