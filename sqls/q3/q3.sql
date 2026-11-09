
WITH hub_reasons AS (
    SELECT
        h.hub_name,
        ol.hold_reason,
        COUNT(*) AS holds
    FROM hubs h
    INNER JOIN agents a
        ON h.hub_id = a.hub_id
    INNER JOIN order_logs ol
        ON a.agent_id = ol.agent_id
    WHERE ol.status = 'Hold'
      AND ol.event_time BETWEEN '2026-10-20' AND '2026-10-26'
    GROUP BY
        h.hub_name,
        ol.hold_reason
),

hub_totals AS (
    SELECT
        hub_name,
        SUM(holds) AS total_holds,
        SUM(holds) FILTER (
            WHERE hold_reason IN ('Late Dispatch', 'Not Attempted', 'Agent Time Shortage')
        ) AS agent_side_holds
    FROM hub_reasons
    GROUP BY
        hub_name
),

ranked_reasons AS (
    SELECT
        hub_name,
        hold_reason,
        holds,
        RANK() OVER (
            PARTITION BY hub_name
            ORDER BY holds DESC
        ) AS reason_rank
    FROM hub_reasons
    WHERE hold_reason IN ('Late Dispatch', 'Not Attempted', 'Agent Time Shortage')
),

top_reasons AS (
    SELECT
        hub_name,
        STRING_AGG(hold_reason || ' (' || holds || ')', ' / ' ORDER BY hold_reason)
            FILTER (WHERE reason_rank = 1) AS top_reason_1,
        STRING_AGG(hold_reason || ' (' || holds || ')', ' / ' ORDER BY hold_reason)
            FILTER (WHERE reason_rank = 2) AS top_reason_2
    FROM ranked_reasons
    GROUP BY
        hub_name
)

SELECT
    t.hub_name,
    t.total_holds,
    t.agent_side_holds,
    ROUND(t.agent_side_holds * 100.0 / t.total_holds, 1) AS agent_side_pct,
    r.top_reason_1,
    r.top_reason_2
FROM hub_totals t
INNER JOIN top_reasons r
    ON t.hub_name = r.hub_name
ORDER BY t.total_holds DESC;
