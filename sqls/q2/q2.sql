-- Q2. Hub Utilisation in Week 1 and Week 2 Compare each hub's attempts and utilisation in Week 1 and Week 2, and flag the hubs above target in Week 2. State how you define utilisation.

WITH attempts AS (
    SELECT
        ag.hub_id,
        COUNT(*) FILTER (
            WHERE ol.event_time BETWEEN '2026-10-13' AND '2026-10-19'
        ) AS w1_attempts,
        COUNT(*) FILTER (
            WHERE ol.event_time BETWEEN '2026-10-20' AND '2026-10-26'
        ) AS w2_attempts
    FROM agents ag
    INNER JOIN order_logs ol
        ON ag.agent_id = ol.agent_id
    WHERE ol.status = 'Assigned'
    GROUP BY
        ag.hub_id
),

active_agents AS (
    SELECT
        hub_id,
        COUNT(*) AS w1_agents,
        COUNT(*) FILTER (
            WHERE active_status = 'Active'
        ) AS w2_agents
    FROM agents
    GROUP BY
        hub_id
),

utilisation AS (
    SELECT
        h.hub_id,
        h.hub_name,
        a.w1_attempts,
        ROUND(a.w1_attempts * 100.0 / (ag.w1_agents * 7 * 40), 1)
        AS w1_utl,
        a.w2_attempts,
        ROUND(a.w2_attempts * 100.0 / (ag.w2_agents * 7 * 40), 1)
        AS w2_utl
    FROM attempts a
    INNER JOIN active_agents ag
        ON a.hub_id = ag.hub_id
    INNER JOIN hubs h
        ON a.hub_id = h.hub_id
)

SELECT
    *,
    CASE
        WHEN w2_utl > 85 THEN 'Above target'
        ELSE 'Within target'
    END AS w2_flag
FROM utilisation;