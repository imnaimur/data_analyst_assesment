# Logistics Analysis

This repository contains a CTE-based PostgreSQL operational and ROI analysis of a parcel delivery network. It combines agent, hub, order, order-event, salary, and forecast data to evaluate current performance and make staffing, budget, and return-on-investment recommendations.

## Tableau Dashboard

A Tableau dashboard was built to provide an interactive view of the operational performance, staffing performane,Other statiscitcs.

[View the Tableau dashboard](https://public.tableau.com/app/profile/naimur.rahman5472/viz/order_analysis_dashboard/order_analysis?publish=yes)

## Analysis Topic

| Serial | Topic | Main files |
| --- | --- | --- |
| 1 | Daily agent productivity and average deliveries per agent per day | `sqls/q1/` |
| 2 | Hub utilization in Week 1 and Week 2 | `sqls/q2/` |
| 3 | Hold reasons and the main operational causes | `sqls/q3/` |
| 4 | Final outcomes of orders held at least once | `sqls/q4/` |
| 5 | Agents with high return ratios and sufficient tenure | `sqls/q5/` |
| 6 | Cost per delivered order by hub and week | `sqls/q6/` |
| 7 | Agents required to meet forecast demand and staffing gaps | `sqls/q7/` |
| 8 | Hub-by-hub assessment of the request to hire eight agents | `sqls/q8/` |
| 9 | Recommended staffing plan and budget allocation | `sqls/q9/` |
| 10 | Risks, early-warning indicators, and mitigations | `sqls/q10/` |

## Operational Snapshot

| Metric | Result |
|---|---:|
| Hubs analyzed | 6 |
| Active agents | 62 |
| Orders | 51,190 |
| Average utilization | 80.57% |
| Delivery attempts | 25,595 |
| Delivered | 21,078 |
| Holds | 3,042 |
| Returned | 1,475 |

## Hub Performance

| Hub | Agents | Week 2 Utilization | Agent-side Holds | Attempts per Order | Workload |
|---|---:|---:|---:|---:|---|
| Greenfield | 10 | 88.6% | 19.0% | 1.073 | Above target |
| Hillcrest | 9 | 95.9% | 22.0% | 1.078 | Above target |
| Riverside | 12 | 90.8% | 64.4% | 1.351 | Above target |
| Westwood | 9 | 80.4% | 20.5% | 1.067 | Balanced |
| Brookside | 11 | 71.5% | 26.3% | 1.085 | Below target |
| Lakeview | 11 | 56.2% | 21.1% | 1.073 | Below target |

## Forecasted Outcome

The proposed staffing distribution was projected to change hub
utilization as follows:

| Hub | Current Agents | Proposed Agents | Current Utilization | Forecast Utilization |
|---|---:|---:|---:|---:|
| Greenfield | 10 | 12 | 88.6% | 83% |
| Hillcrest | 9 | 11 | 95.9% | 83% |
| Riverside | 12 | 13 | 90.8% | 84% |
| Westwood | 9 | 9 | 80.4% | 82% |
| Brookside | 11 | 11 | 71.5% | 72% |
| Lakeview | 11 | 8 | 56.2% | 77% |

| Comparison | Current | Forecast after redistribution |
|---|---:|---:|
| Lowest hub utilization | 56.2% | 72% |
| Highest hub utilization | 95.9% | 84% |
| Utilization range | 39.7 percentage points | 12 percentage points |
