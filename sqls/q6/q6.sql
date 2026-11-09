-- Q6. Cost per Delivered Order
-- Calculate each hub's cost per delivered order for Week 1 and Week 2.

-- Cost per delivered order = total agent cost / delivered orders
-- Daily agent cost (from agent_salary table):
--   Fixed    = monthly_salary / 26           = 16900 / 26 = 650
--   Variable = daily_allowance + 14 x deliveries that day = 300 + 14 x deliveries
-- One formula works for both because the unused columns are 0:
--   monthly_salary / 26 + daily_allowance + allowance_per_delivery x deliveries
-- A "day worked" = a day the agent has events in order_logs.


WITH agent_days AS (
    SELECT
        ag.agent_id,
        ag.hub_id,
        ag.salary_type,
        DATE(ol.event_time) AS work_date,
        COUNT(*) FILTER (
            WHERE ol.status = 'Delivered'
        ) AS deliveries
    FROM agents ag
    INNER JOIN order_logs ol
        ON ag.agent_id = ol.agent_id
    GROUP BY
        ag.agent_id,
        ag.hub_id,
        ag.salary_type,
        DATE(ol.event_time)
),

    agent_day_cost AS (
        SELECT
            ad.hub_id,
            ad.work_date,
            ad.deliveries,
            s.monthly_salary / 26.0
                + s.daily_allowance
                + s.allowance_per_delivery * ad.deliveries AS daily_cost
        FROM agent_days ad
        INNER JOIN agent_salary s
            ON ad.salary_type = s.salary_type
    ),
    hub_weekly AS (
        SELECT
            hub_id,
            SUM(daily_cost) FILTER (
                WHERE work_date BETWEEN '2026-10-13' AND '2026-10-19'
            ) AS w1_cost,
            SUM(deliveries) FILTER (
                WHERE work_date BETWEEN '2026-10-13' AND '2026-10-19'
            ) AS w1_deliveries,
            SUM(daily_cost) FILTER (
                WHERE work_date BETWEEN '2026-10-20' AND '2026-10-26'
            ) AS w2_cost,
            SUM(deliveries) FILTER (
                WHERE work_date BETWEEN '2026-10-20' AND '2026-10-26'
            ) AS w2_deliveries
        FROM agent_day_cost
        GROUP BY
            hub_id
    )
SELECT
    h.hub_name,
    ROUND(hw.w1_cost) AS w1_cost,
    hw.w1_deliveries,
    ROUND(hw.w1_cost / hw.w1_deliveries, 2) AS w1_cost_per_delivery,
    ROUND(hw.w2_cost) AS w2_cost,
    hw.w2_deliveries,
    ROUND(hw.w2_cost / hw.w2_deliveries, 2) AS w2_cost_per_delivery
FROM hub_weekly hw
INNER JOIN hubs h
    ON hw.hub_id = h.hub_id
ORDER BY w2_cost_per_delivery;

\COPY (WITH agent_days AS (
    SELECT
        ag.agent_id,
        ag.hub_id,
        ag.salary_type,
        DATE(ol.event_time) AS work_date,
        COUNT(*) FILTER (
            WHERE ol.status = 'Delivered'
        ) AS deliveries
    FROM agents ag
    INNER JOIN order_logs ol
        ON ag.agent_id = ol.agent_id
    GROUP BY
        ag.agent_id,
        ag.hub_id,
        ag.salary_type,
        DATE(ol.event_time)
),

    agent_day_cost AS (
        SELECT
            ad.hub_id,
            ad.work_date,
            ad.deliveries,
            s.monthly_salary / 26.0
                + s.daily_allowance
                + s.allowance_per_delivery * ad.deliveries AS daily_cost
        FROM agent_days ad
        INNER JOIN agent_salary s
            ON ad.salary_type = s.salary_type
    ),
    hub_weekly AS (
        SELECT
            hub_id,
            SUM(daily_cost) FILTER (
                WHERE work_date BETWEEN '2026-10-13' AND '2026-10-19'
            ) AS w1_cost,
            SUM(deliveries) FILTER (
                WHERE work_date BETWEEN '2026-10-13' AND '2026-10-19'
            ) AS w1_deliveries,
            SUM(daily_cost) FILTER (
                WHERE work_date BETWEEN '2026-10-20' AND '2026-10-26'
            ) AS w2_cost,
            SUM(deliveries) FILTER (
                WHERE work_date BETWEEN '2026-10-20' AND '2026-10-26'
            ) AS w2_deliveries
        FROM agent_day_cost
        GROUP BY
            hub_id
    )
SELECT
    h.hub_name,
    ROUND(hw.w1_cost) AS w1_cost,
    hw.w1_deliveries,
    ROUND(hw.w1_cost / hw.w1_deliveries, 2) AS w1_cost_per_delivery,
    ROUND(hw.w2_cost) AS w2_cost,
    hw.w2_deliveries,
    ROUND(hw.w2_cost / hw.w2_deliveries, 2) AS w2_cost_per_delivery
FROM hub_weekly hw
INNER JOIN hubs h
    ON hw.hub_id = h.hub_id
ORDER BY w2_cost_per_delivery) TO './q6.csv' WITH (FORMAT CSV, HEADER TRUE)