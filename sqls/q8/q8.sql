-- Q8. The Hiring Request
-- Hub managers have asked for 8 new agents to handle the forecast.
-- Would you approve the request? Make your case hub by hub, with costs.

-- This query builds the decision table:
--   staffing gap (from Q7 logic, peak forecast week per hub),
--   recommended action (hire, transfer, or none),
--   and 4-week cost of each new Fixed hire (BDT 650/day x 28 days).
-- Surplus hubs (gap < 0) have agents that can be transferred at zero
-- incremental cost, so the real hiring need is much less than 8.


WITH attempts_per_order AS (
    SELECT
        o.hub_id,
        COUNT(*) FILTER (
            WHERE ol.status = 'Assigned'
        ) * 1.0 / COUNT(DISTINCT o.order_id) AS apo
    FROM orders o
    INNER JOIN order_logs ol
        ON o.order_id = ol.order_id
    GROUP BY
        o.hub_id
),

active_agents AS (
    SELECT
        hub_id,
        COUNT(*) AS active_agents
    FROM agents
    WHERE active_status = 'Active'
    GROUP BY hub_id
),

-- Peak forecast week per hub (worst-case staffing need)
peak_week AS (
    SELECT
        vf.hub_id,
        MAX(vf.expected_orders) AS peak_orders,
        MAX(ROUND(vf.expected_orders * apo.apo)) AS peak_attempts,
        MAX(CEIL(vf.expected_orders * apo.apo / (34.0 * 7))) AS required_agents
    FROM volume_forecast vf
    INNER JOIN attempts_per_order apo
        ON vf.hub_id = apo.hub_id
    GROUP BY
        vf.hub_id
),

decision AS (
    SELECT
        h.hub_id,
        h.hub_name,
        aa.active_agents,
        pw.required_agents,
        pw.required_agents - aa.active_agents AS staffing_gap,
        pw.peak_orders,
        pw.peak_attempts,
        ROUND(apo.apo, 3) AS attempts_per_order,
        CASE
            WHEN pw.required_agents - aa.active_agents > 0 THEN 'Short'
            WHEN pw.required_agents - aa.active_agents < 0 THEN 'Surplus'
            ELSE 'Balanced'
        END AS status
    FROM peak_week pw
    INNER JOIN active_agents aa ON pw.hub_id = aa.hub_id
    INNER JOIN hubs h ON pw.hub_id = h.hub_id
    INNER JOIN attempts_per_order apo ON pw.hub_id = apo.hub_id
)

SELECT
    hub_name,
    active_agents,
    required_agents,
    staffing_gap,
    status,
    peak_orders,
    peak_attempts,
    attempts_per_order,
    -- cost of hiring the gap as Fixed agents for 4 weeks (28 days)
    CASE WHEN staffing_gap > 0
        THEN staffing_gap * 650 * 28
        ELSE 0
    END AS hire_cost_4wk_bdt,
    -- idle salary already being paid for surplus agents (Fixed rate)
    CASE WHEN staffing_gap < 0
        THEN ABS(staffing_gap) * 650 * 28
        ELSE 0
    END AS idle_cost_4wk_bdt
FROM decision
ORDER BY hub_id;

\COPY (WITH attempts_per_order AS (SELECT o.hub_id, COUNT(*) FILTER (WHERE ol.status = 'Assigned') * 1.0 / COUNT(DISTINCT o.order_id) AS apo FROM orders o INNER JOIN order_logs ol ON o.order_id = ol.order_id GROUP BY o.hub_id), active_agents AS (SELECT hub_id, COUNT(*) AS active_agents FROM agents WHERE active_status = 'Active' GROUP BY hub_id), peak_week AS (SELECT vf.hub_id, MAX(vf.expected_orders) AS peak_orders, MAX(ROUND(vf.expected_orders * apo.apo)) AS peak_attempts, MAX(CEIL(vf.expected_orders * apo.apo / (34.0 * 7))) AS required_agents FROM volume_forecast vf INNER JOIN attempts_per_order apo ON vf.hub_id = apo.hub_id GROUP BY vf.hub_id), decision AS (SELECT h.hub_id, h.hub_name, aa.active_agents, pw.required_agents, pw.required_agents - aa.active_agents AS staffing_gap, pw.peak_orders, pw.peak_attempts, ROUND(apo.apo, 3) AS attempts_per_order, CASE WHEN pw.required_agents - aa.active_agents > 0 THEN 'Short' WHEN pw.required_agents - aa.active_agents < 0 THEN 'Surplus' ELSE 'Balanced' END AS status FROM peak_week pw INNER JOIN active_agents aa ON pw.hub_id = aa.hub_id INNER JOIN hubs h ON pw.hub_id = h.hub_id INNER JOIN attempts_per_order apo ON pw.hub_id = apo.hub_id) SELECT hub_name, active_agents, required_agents, staffing_gap, status, peak_orders, peak_attempts, attempts_per_order, CASE WHEN staffing_gap > 0 THEN staffing_gap * 650 * 28 ELSE 0 END AS hire_cost_4wk_bdt, CASE WHEN staffing_gap < 0 THEN ABS(staffing_gap) * 650 * 28 ELSE 0 END AS idle_cost_4wk_bdt FROM decision ORDER BY hub_id) TO './q8.csv' WITH (FORMAT CSV, HEADER TRUE)
