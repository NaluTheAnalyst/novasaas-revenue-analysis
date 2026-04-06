# NovaSaaS — Revenue & Growth Analysis

## Project Overview

NovaSaaS is a fictional B2B SaaS platform operating across the United States, United Kingdom, Canada, and Australia. This project analyses NovaSaaS's full-year 2023 data to uncover revenue trends, subscription performance, churn patterns, upgrade behaviour, and customer support insights — the kind of analysis a Revenue or Growth Analyst would present to a client or senior leadership.

The entire analysis was performed using **SQL Server 2019** across a dataset of 1,355 payments and 5 tables.

---

## Dataset

| Table | Description | Rows |
|---|---|---|
| `customers` | Every customer — company, plan, country, industry, signup date | 200 |
| `subscriptions` | Every subscription — status, start/end dates, upgrade info | 200 |
| `payments` | Every monthly payment — amount, date, plan, payment method | 1,355 |
| `churn` | Every churned customer — churn date, plan, reason | 49 |
| `support_tickets` | Every support ticket — category, priority, status, resolution days | 364 |

---

## Key Findings

1. **Enterprise drives disproportionate revenue** — Enterprise customers (13.5% of the base) generate 43% of total revenue with an ARPC of $3,678 — 11x more than Starter customers at $335
2. **United Kingdom is the top market** — The UK leads all countries in both total revenue ($78,635) and ARPC ($1,484). Australia is the weakest market at $719 ARPC despite having the same number of customers as Canada
3. **Strong MRR growth** — MRR grew 8x from $3,680 in January to $29,678 in December with no month-on-month dip across the entire year
4. **Churn rate is above benchmark** — The 24.5% annual churn rate is well above the healthy SaaS benchmark of 5-7%. Growth plan customers churn the most at 27.78%
5. **Upgrade revenue is significant** — Growth to Enterprise upgrades nearly doubled revenue contribution after upgrading ($12,492 before vs $24,451 after). Starter to Growth upgrades show a revenue drop after upgrading, suggesting early churn
6. **Support tickets do not predict churn** — Churned and active customers raise almost identical numbers of tickets (1.84 vs 1.81), meaning churn is driven by product and pricing issues rather than support volume

---

## Strategic Recommendations

| Priority | Recommendation | Based On |
|---|---|---|
| 1 | Reduce churn rate — investigate why Growth plan customers leave at 27.78% | Q7 |
| 2 | Build a structured Enterprise upsell programme — Growth to Enterprise upgrades nearly double revenue | Q8 |
| 3 | Review the Starter to Growth upgrade path — revenue drops after upgrading suggesting early churn | Q8 |
| 4 | Investigate Australia market — same customer count as Canada but half the revenue | Q6 |
| 5 | Improve support quality — Poor support ties as a top churn reason at 24.49% | Q7 |

---

## Tools Used

- SQL Server 2019
- SQL Server Management Studio (SSMS)
- Power BI Desktop
