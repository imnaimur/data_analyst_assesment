-- Q7. Agents Needed for the Forecast
-- Calculate required agents and the staffing gap for each of the four forecast weeks.

-- Forecast is in ORDERS, but agent workload is in ATTEMPTS
-- (a held order is attempted again), so:
--   expected_attempts = expected_orders x attempts_per_order (hub's own 14-day history)
--   required_agents   = expected_attempts / (34 attempts x 7 days), rounded UP
--                       34 = planning target (85% of the 40-attempt standard workload)
--   staffing_gap      = required_agents - active agents
--                       positive = short of agents, negative = spare agents
-- Only Active agents count (inactive agents left at the end of Week 1).

-- step 1: how many attempts each hub needs per order (from the 14 days of data)
WITH attempts_per_order AS (
    SELECT
        o.hub_id,
        COUNT(*) FILTER (
            WHERE ol.status = 'Assigned'
        ) * 1.0 / COUNT(DISTINCT o.order_id) AS attempts_per_order
    FROM orders o
    INNER JOIN order_logs ol
        ON o.order_id = ol.order_id
    GROUP BY
        o.hub_id
    ),

    available_agents AS (
        SELECT
            hub_id,
            COUNT(*) AS active_agents
        FROM agents
        WHERE active_status = 'Active'
        GROUP BY
            hub_id
    ),

    forecast_attempts AS (
        SELECT
            vf.hub_id,
            vf.week_start,
            vf.week_end,
            vf.expected_orders,
            ROUND(apo.attempts_per_order, 3) AS attempts_per_order,
            ROUND(vf.expected_orders * apo.attempts_per_order) AS expected_attempts
        FROM volume_forecast vf
        INNER JOIN attempts_per_order apo
            ON vf.hub_id = apo.hub_id
    )


SELECT
    h.hub_name,
    fa.week_start,
    fa.week_end,
    fa.expected_orders,
    fa.attempts_per_order,
    fa.expected_attempts,
    CEIL(fa.expected_attempts / (34 * 7.0)) AS required_agents,
    aa.active_agents,
    CEIL(fa.expected_attempts / (34 * 7.0)) - aa.active_agents AS staffing_gap
FROM forecast_attempts fa
INNER JOIN available_agents aa
    ON fa.hub_id = aa.hub_id
INNER JOIN hubs h
    ON fa.hub_id = h.hub_id
ORDER BY
    fa.hub_id,
    fa.week_start;