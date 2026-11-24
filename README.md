## Repository Structure & Usage Guide

| File | Description |
| :--- | :--- |
| `README.md` | Project overview, problem statement, system architecture, and AI workflow guide. |
| `sample_daily_transactions.csv` | Ready-to-use CSV template containing sample daily records for sales (`SALES`), inventory (`STOCK`), and operating expenses (`OPEX`) across `CASH`, `QR_EWALLET`, and `DIGITAL_WALLET`. |
| `margin_cashflow_analysis.sql` | SQL queries to create the `daily_transactions` table, calculate daily gross profit, net cash flow, net margin (%), payment channel breakdown, and high-cost alerts (`> 60%` of sales). |

### How to Run the Sample Analysis
1. **Log Daily Records:** Open `sample_daily_transactions.csv` in Excel, Google Sheets, or any SQL-compatible tool and replace the sample rows with your daily business transactions.
2. **Execute SQL Queries:** Import the CSV data into a SQLite, PostgreSQL, or MySQL table named `daily_transactions` and run `margin_cashflow_analysis.sql` to generate daily margin and cash-flow summaries.
3. **Generate Weekly AI Insights:** Paste your weekly summary output into an AI assistant using the prompt template below.

---

## AI-Assisted Weekly Summary Prompt Template

Copy and paste this prompt along with your weekly CSV or SQL summary table to generate actionable business insights:

```text
Act as a lean retail and F&B operations analyst for a micro-merchant in Sabah, Malaysia.
Below is my weekly transaction summary (in MYR) covering Sales, Stock Costs, Operating Expenses (OPEX), and Payment Channels (Cash, QR/E-Wallet, Digital Wallet):

[PASTE YOUR WEEKLY CSV OR SQL SUMMARY DATA HERE]

Please provide:
1. Total Gross Sales, Total Stock + OPEX Costs, Net Cash Flow, and Net Profit Margin (%).
2. A breakdown of revenue share by payment channel (Cash vs. QR/E-Wallet vs. Digital Wallet).
3. Any days where combined Stock + OPEX exceeded 60% of daily sales, with likely reasons.
4. Three practical, low-cost actions I can take next week to improve cash flow and protect profit margins.
