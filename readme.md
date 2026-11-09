# Logistics Analysis

This repository contains a CTE-based PostgreSQL operational and ROI analysis of a parcel delivery network. It combines agent, hub, order, order-event, salary, and forecast data to evaluate current performance and make staffing, budget, and return-on-investment recommendations.

## Data model

| Table | Description |
| --- | --- |
| `agents` | Agent identity, hub assignment, salary type, joining date, and active status |
| `agent_salary` | Monthly salary and delivery allowance rules by salary type |
| `hubs` | Hub names and cluster assignments |
| `orders` | Order creation time, final status, COD amount, and delivery charge |
| `order_logs` | Assignment, delivery, hold, and return events for each order attempt |
| `volume_forecast` | Expected order volume by hub and forecast week |

The source files are:

```text
agents.csv
agent_salary.csv
hubs.csv
orders.csv
order_logs.csv
volume_forecast.csv
```

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

## Results

The `results/` directory contains Excel deliverables for 1-9:

```text
q1_part1.xlsx
q1_part2.xlsx
q2.xlsx
q3.xlsx
q4.xlsx
q5.xlsx
q6.xlsx
q7.xlsx
q8.xlsx
q9_calculations.xlsx
```

## Analysis conventions

- `order_logs` records order attempts and operational events; a held order can therefore generate additional attempts.
- 2 defines and compares hub utilization across the first two analysis weeks.
- 5 uses tenure and return ratio to identify higher-risk agent performance.
- 6 calculates agent cost using the salary rules in `agent_salary` and divides it by delivered orders.
- 7 converts forecast orders into expected attempts using each hub's observed attempts-per-order rate.
- 8-Q9 distinguish between transferring surplus agents and hiring new fixed-cost agents.
- 10 describes the monitoring signals to use during the first two weeks after implementing the staffing plan.
