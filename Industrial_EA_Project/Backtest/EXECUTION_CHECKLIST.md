# Execution Checklist

1. Install/open MetaTrader 5 and log into the Exness account/data environment required by the assignment.
2. Open MetaEditor and copy IndustrialTrendPullbackEA.mq5 into MQL5/Experts.
3. Compile with F7. Fix only broker-specific symbol or platform issues; do not change the strategy rules without recording the change.
4. Open Strategy Tester (Ctrl+R).
5. Select the EA and exact Exness symbol.
6. Set H1 and “Every tick based on real ticks”.
7. Set the seven-year date range.
8. Use USD 10,000 initial capital and the required leverage/non-leverage assumption.
9. Run a baseline test.
10. Run optimization on the first four years only.
11. Validate the selected parameters on the next year.
12. Run the final two years as out-of-sample.
13. Repeat for all ten instruments.
14. Export/save the Strategy Tester report for every instrument.
15. Fill Backtest/results_template.csv.
16. Insert screenshots of the tester settings, equity curve, optimization results and yearly/monthly statistics into the report.
17. Keep the original reports as evidence in a Backtest/Reports folder.
