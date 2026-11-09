-- Active: 1793339384165@@127.0.0.1@5432@carry_bee
CREATE DATABASE carry_bee;
SELECT current_database();

CREATE TABLE agents(
    agent_id VARCHAR(255),
    agent_name VARCHAR(255),
    hub_id VARCHAR(255),
    salary_type VARCHAR(255),
    joining_date DATE,
    active_status VARCHAR(255)
);
COPY agents
FROM '/Users/naimurrahman/Desktop/carry_bee_datasets/agents.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ','
);

CREATE TABLE agent_salary(
    salary_type VARCHAR(255),
    monthly_salary INT,
    daily_allowance INT,
    allowance_per_delivery INT
);

COPY agent_salary
FROM '/Users/naimurrahman/Desktop/carry_bee_datasets/agent_salary.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ','
);
CREATE TABLE hubs(
    hub_id VARCHAR(255),
    hub_name VARCHAR(255),
    cluster VARCHAR(255)
);

COPY hubs
FROM '/Users/naimurrahman/Desktop/carry_bee_datasets/hubs.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ','
);
CREATE TABLE order_logs(
log_id VARCHAR(255),
order_id VARCHAR(255),
agent_id VARCHAR(255),
status VARCHAR(255),
hold_reason VARCHAR(255),
event_time DATE,
attempt_no INT
);

COPY order_logs
FROM '/Users/naimurrahman/Desktop/carry_bee_datasets/order_logs.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ','
);
CREATE TABLE orders(
    order_id VARCHAR(255),
    hub_id VARCHAR(255),
    created_at TIMESTAMP,
    final_status VARCHAR(100),
    cod_amount INT,
    delivery_charge INT
);

COPY orders
FROM '/Users/naimurrahman/Desktop/carry_bee_datasets/orders.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ','
);

CREATE TABLE volume_forecast(
    hub_id VARCHAR(255),
    week_start DATE,
    week_end DATE,
    expected_orders INT
);

COPY volume_forecast
FROM '/Users/naimurrahman/Desktop/carry_bee_datasets/volume_forecast.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ','
);

SELECT * from volume_forecast;
