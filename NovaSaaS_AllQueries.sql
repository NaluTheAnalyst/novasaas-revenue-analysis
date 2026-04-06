-- ============================================================
--  NovaSaaS  |  Revenue & Growth Analysis
--  SQL Server 2019
-- ============================================================

USE NovaSaaS;
GO


-- QUESTION 1: Revenue by Plan
SELECT
    [plan],
    SUM(amount) AS total_revenue
FROM payments
GROUP BY [plan]
ORDER BY total_revenue DESC

-- Results:
-- Enterprise    99,301.00
-- Growth        95,947.00
-- Starter       33,797.00

-- Finding:
-- Enterprise generates the most revenue at $99,301 despite having the
-- fewest customers (27). Starter has the most customers (101) but
-- generates the least revenue at $33,797. This highlights the extreme
-- value difference between plans and the significant upsell opportunity
-- sitting in the Starter customer base.


-- QUESTION 2: Revenue by Country
SELECT
    c.country,
    SUM(p.amount) AS total_revenue,
    CAST(SUM(p.amount) * 100.0 / SUM(SUM(p.amount)) OVER() AS DECIMAL(5,2)) AS revenue_share_pct
FROM payments p
JOIN customers c ON p.customer_id = c.customer_id
GROUP BY c.country
ORDER BY total_revenue DESC

-- Results:
-- United Kingdom    78,635.00    34.33%
-- Canada            66,883.00    29.20%
-- United States     46,860.00    20.46%
-- Australia         36,667.00    16.01%

-- Finding:
-- The United Kingdom is the top revenue market at 34.33% despite the
-- US typically being the dominant SaaS market. Australia is the weakest
-- at 16.01%. NovaSaaS should investigate whether pricing or product
-- localisation adjustments are needed for the Australian market.


-- QUESTION 3: Customer Distribution by Plan
SELECT
    [plan],
    COUNT(customer_id) AS total_customers,
    CAST(COUNT(customer_id) * 100.0 / SUM(COUNT(customer_id)) OVER() AS DECIMAL(5,2)) AS pct_of_customers
FROM customers
GROUP BY [plan]
ORDER BY total_customers DESC

-- Results:
-- Starter       101    50.50%
-- Growth         72    36.00%
-- Enterprise     27    13.50%

-- Finding:
-- Half the customer base is on the cheapest plan. Only 13.5% are on
-- Enterprise, yet Enterprise drives 43% of revenue. Converting even
-- a fraction of Starter customers to Growth or Enterprise would
-- substantially increase total revenue. NovaSaaS should build a
-- structured upsell programme targeting the Starter base.


-- QUESTION 4: MRR Trend Across 2023
SELECT
    MONTH(payment_date) AS month_number,
    DATENAME(MONTH, payment_date) AS month_name,
    SUM(amount) AS total_mrr
FROM payments
GROUP BY MONTH(payment_date), DATENAME(MONTH, payment_date)
ORDER BY month_number

-- Results:
-- January       3,680.00
-- February      6,409.00
-- March        11,043.00
-- April        13,774.00
-- May          17,250.00
-- June         18,737.00
-- July         20,929.00
-- August       23,057.00
-- September    25,839.00
-- October      29,271.00
-- November     29,378.00
-- December     29,678.00

-- Finding:
-- MRR grew every single month without a dip — from $3,680 in January
-- to $29,678 in December, an 8x increase. This is a textbook healthy
-- SaaS growth curve. November and December are nearly flat, suggesting
-- the business is approaching maturity and needs new customer acquisition
-- to maintain growth momentum into 2024.


-- QUESTION 5: Revenue by Industry
SELECT
    c.industry,
    SUM(p.amount) AS total_revenue
FROM payments p
JOIN customers c ON p.customer_id = c.customer_id
GROUP BY c.industry
ORDER BY total_revenue DESC

-- Results:
-- Healthcare      45,355.00
-- Fintech         41,375.00
-- EdTech          37,112.00
-- Logistics       35,243.00
-- E-commerce      35,212.00
-- Real Estate     34,748.00

-- Finding:
-- Healthcare leads at $45,355 followed closely by Fintech. Revenue is
-- fairly well distributed across all six industries with no extreme
-- concentration. NovaSaaS should prioritise Healthcare and Fintech in
-- its sales and marketing efforts as they demonstrate the highest
-- spending capacity.


-- QUESTION 6: ARPC by Plan and Country

-- By Plan
SELECT
    [plan],
    COUNT(DISTINCT customer_id) AS total_customers,
    SUM(amount) AS total_revenue,
    CAST(SUM(amount) / COUNT(DISTINCT customer_id) AS DECIMAL(10,2)) AS arpc
FROM payments
GROUP BY [plan]
ORDER BY arpc DESC

-- Results:
-- Enterprise    27    99,301.00    3,677.81
-- Growth        72    95,947.00    1,332.60
-- Starter      101    33,797.00      334.62

-- By Country
SELECT
    c.country,
    COUNT(DISTINCT p.customer_id) AS total_customers,
    SUM(p.amount) AS total_revenue,
    CAST(SUM(p.amount) / COUNT(DISTINCT p.customer_id) AS DECIMAL(10,2)) AS arpc
FROM payments p
JOIN customers c ON p.customer_id = c.customer_id
GROUP BY c.country
ORDER BY arpc DESC

-- Results:
-- United Kingdom    53    78,635.00    1,483.68
-- Canada            51    66,883.00    1,311.43
-- United States     45    46,860.00    1,041.33
-- Australia         51    36,667.00      718.96

-- Finding:
-- Enterprise customers are worth 11x more per customer than Starter
-- ($3,678 vs $335). The UK has the highest ARPC at $1,484. Australia
-- has the lowest at $719 despite having the same number of customers
-- as Canada (51) — it generates nearly half the revenue. ARPC is the
-- most important metric for understanding where to focus sales and
-- retention effort.


-- QUESTION 7: Churn Analysis

-- Overall Churn Rate
SELECT
    COUNT(*) AS total_churned,
    (SELECT COUNT(*) FROM customers) AS total_customers,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customers) AS DECIMAL(5,2)) AS churn_rate_pct
FROM churn

-- Result: 49 / 200 = 24.50%

-- Churn by Plan
SELECT
    ch.[plan],
    COUNT(*) AS churned_customers,
    (SELECT COUNT(*) FROM customers c WHERE c.[plan] = ch.[plan]) AS total_customers,
    CAST(COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM customers c WHERE c.[plan] = ch.[plan])
        AS DECIMAL(5,2)) AS churn_rate_pct
FROM churn ch
GROUP BY ch.[plan]
ORDER BY churn_rate_pct DESC

-- Results:
-- Growth        20    72     27.78%
-- Starter       24    101    23.76%
-- Enterprise     5    27     18.52%

-- Top Churn Reasons
SELECT
    reason,
    COUNT(*) AS total,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(5,2)) AS pct
FROM churn
GROUP BY reason
ORDER BY total DESC

-- Results:
-- Business closed           12    24.49%
-- Missing features          12    24.49%
-- Poor support              12    24.49%
-- Switched to competitor    10    20.41%
-- Too expensive              3     6.12%

-- Finding:
-- The 24.50% churn rate is significantly above the healthy SaaS
-- benchmark of 5-7% annually. Growth plan customers churn the most
-- at 27.78%. Three reasons tie at the top — Business closed, Missing
-- features, and Poor support — each at 24.49%. Multiple simultaneous
-- problems are harder to fix than a single root cause and require
-- parallel action across product, support, and retention.


-- QUESTION 8: Plan Upgrades & Revenue Impact

-- Upgrades by Plan
SELECT
    [plan] AS original_plan,
    upgraded_to AS new_plan,
    COUNT(*) AS total_upgrades
FROM subscriptions
WHERE upgraded_to IS NOT NULL
GROUP BY [plan], upgraded_to
ORDER BY total_upgrades DESC

-- Results:
-- Growth     Enterprise    11
-- Starter    Growth         8

-- Revenue Impact
SELECT
    s.[plan] AS original_plan,
    s.upgraded_to AS new_plan,
    COUNT(*) AS total_upgrades,
    SUM(CASE WHEN p.payment_date < s.upgrade_date THEN p.amount ELSE 0 END) AS revenue_before_upgrade,
    SUM(CASE WHEN p.payment_date >= s.upgrade_date THEN p.amount ELSE 0 END) AS revenue_after_upgrade
FROM subscriptions s
JOIN payments p ON s.customer_id = p.customer_id
WHERE s.upgraded_to IS NOT NULL
GROUP BY s.[plan], s.upgraded_to
ORDER BY revenue_after_upgrade DESC

-- Results:
-- Growth    Enterprise    11    12,492.00    24,451.00
-- Starter   Growth         8     2,709.00     1,639.00

-- Finding:
-- Growth to Enterprise upgrades nearly doubled revenue contribution —
-- from $12,492 before to $24,451 after. However Starter to Growth
-- upgrades show a revenue drop after upgrading ($1,639 vs $2,709
-- before), suggesting those customers churned shortly after upgrading.
-- The Growth plan may not be delivering enough value to justify the
-- price jump from Starter.


-- QUESTION 9: Support Tickets vs Churn

-- Average Tickets: Active vs Churned
SELECT
    CASE WHEN ch.customer_id IS NOT NULL THEN 'Churned' ELSE 'Active' END AS status,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(t.ticket_id) AS total_tickets,
    CAST(COUNT(t.ticket_id) * 1.0 / COUNT(DISTINCT c.customer_id) AS DECIMAL(5,2)) AS avg_tickets_per_customer
FROM customers c
LEFT JOIN support_tickets t ON c.customer_id = t.customer_id
LEFT JOIN churn ch ON c.customer_id = ch.customer_id
GROUP BY CASE WHEN ch.customer_id IS NOT NULL THEN 'Churned' ELSE 'Active' END

-- Results:
-- Active     151    274    1.81
-- Churned     49     90    1.84

-- Top 10 Customers by Ticket Count
SELECT TOP 10
    c.customer_id,
    c.company_name,
    c.[plan],
    COUNT(t.ticket_id) AS ticket_count,
    CASE WHEN ch.customer_id IS NOT NULL THEN 'Churned' ELSE 'Active' END AS status
FROM customers c
LEFT JOIN support_tickets t ON c.customer_id = t.customer_id
LEFT JOIN churn ch ON c.customer_id = ch.customer_id
GROUP BY c.customer_id, c.company_name, c.[plan], ch.customer_id
ORDER BY ticket_count DESC

-- Results:
-- CUST0005    Company_5     Growth      5    Active
-- CUST0020    Company_20    Growth      5    Active
-- CUST0023    Company_23    Starter     5    Active
-- CUST0028    Company_28    Starter     5    Churned
-- CUST0030    Company_30    Growth      5    Active
-- CUST0053    Company_53    Starter     5    Active
-- CUST0060    Company_60    Enterprise  5    Active
-- CUST0062    Company_62    Starter     5    Churned
-- CUST0078    Company_78    Enterprise  5    Churned
-- CUST0094    Company_94    Starter     5    Active

-- Finding:
-- Churned customers average 1.84 tickets vs 1.81 for active customers —
-- virtually no difference. Support ticket volume is NOT a reliable
-- predictor of churn at NovaSaaS. Of the top 10 highest-ticket
-- customers, 7 are still active. Churn is driven by pricing, product
-- gaps, and support quality rather than the number of tickets raised.
