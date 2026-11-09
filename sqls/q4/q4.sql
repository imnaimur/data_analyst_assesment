-- Q4. What Happens to Held Orders
-- For orders held at least once, find the share that were finally delivered, returned or are still on hold, by hub.


WITH held_orders AS (
    SELECT DISTINCT
        order_id
    FROM order_logs
    WHERE status = 'Hold'
    ),

    hub_side AS (
        SELECT
            h.hub_name,
            COUNT(*) AS held_orders,
            COUNT(*) FILTER (
                WHERE o.final_status = 'Delivered'
            ) AS delivered,
            COUNT(*) FILTER (
                WHERE o.final_status = 'Returned'
            ) AS returned,
            COUNT(*) FILTER (
                WHERE o.final_status = 'Hold'
            ) AS on_hold
        FROM held_orders ho
        INNER JOIN orders o
            ON ho.order_id = o.order_id
        INNER JOIN hubs h
            ON o.hub_id = h.hub_id
        GROUP BY
            h.hub_name
    )

SELECT
    hub_name,
    held_orders,
    delivered,
    returned,
    on_hold,
    ROUND(delivered * 100.0 / held_orders, 1) AS delivered_pct,
    ROUND(returned * 100.0 / held_orders, 1) AS returned_pct,
    ROUND(on_hold * 100.0 / held_orders, 1) AS on_hold_pct
FROM hub_side