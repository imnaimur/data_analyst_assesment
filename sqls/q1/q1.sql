-- agent's assigned, delivered, hold and returned attempts, and show each hub's average deliveries per agent per day.

-- Q1 part 1
WITH agent_performance AS (
   SELECT
       ag.agent_id,
       ag.agent_name,
       h.hub_name,
       DATE(ol.event_time) as event_date,

       COUNT(*) FILTER (
           WHERE ol.status = 'Assigned'
       ) AS assigned,

       COUNT(*) FILTER (
           WHERE ol.status = 'Delivered'
       ) AS delivered,

       COUNT(*) FILTER (
           WHERE ol.status = 'Hold'
       ) AS hold,

       COUNT(*) FILTER (
           WHERE ol.status = 'Returned'
       ) AS returned

   FROM agents ag
   INNER JOIN order_logs ol
       ON ag.agent_id = ol.agent_id
   INNER JOIN hubs h
       ON ag.hub_id = h.hub_id

   GROUP BY
       ag.agent_id,
       ag.agent_name,
       h.hub_name,
       DATE(ol.event_time)
)

SELECT *
FROM agent_performance
ORDER BY event_date, agent_id
LIMIT 20;




-- q1 part 2
WITH deliveries AS (
    SELECT
        ag.hub_id,
        ol.agent_id,
        DATE(ol.event_time) AS event_time,

        COUNT(*) FILTER (
            WHERE ol.status = 'Delivered'
        ) AS total_delivered

    FROM agents ag

    INNER JOIN order_logs ol
        ON ag.agent_id = ol.agent_id

    GROUP BY
        ag.hub_id,
        ol.agent_id,
        DATE(ol.event_time)
)

SELECT
    h.hub_name,
    ROUND(AVG(d.total_delivered), 2)
        AS daily_del_perAgnt
FROM deliveries d

INNER JOIN hubs h
    ON d.hub_id = h.hub_id
GROUP BY
    h.hub_name





\copy (WITH deliveries AS (
    SELECT
        ag.hub_id,
        ol.agent_id,
        DATE(ol.event_time) AS event_time,

        COUNT(*) FILTER (
            WHERE ol.status = 'Delivered'
        ) AS total_delivered

    FROM agents ag

    INNER JOIN order_logs ol
        ON ag.agent_id = ol.agent_id

    GROUP BY
        ag.hub_id,
        ol.agent_id,
        DATE(ol.event_time)
)

SELECT
    h.hub_name,
    ROUND(AVG(d.total_delivered), 2)
        AS daily_del_perAgnt
FROM deliveries d

INNER JOIN hubs h
    ON d.hub_id = h.hub_id
GROUP BY
    h.hub_name) TO './q1_part2.csv' WITH (FORMAT CSV, HEADER TRUE);
