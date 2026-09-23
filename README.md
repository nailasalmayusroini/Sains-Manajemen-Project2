# Industrial-Grade Algorithmic Trading EA

This repository contains the MetaTrader 5 Expert Advisor (EA), backtest results, optimization information, and project report for the industrial-grade algorithmic trading project.

## Expert Advisor

**Name:** IndustrialTrendPullbackEA  
**Platform:** MetaTrader 5 / MQL5  
**Timeframe:** H1  
**Broker/Data:** Exness

The EA uses a trend-following pullback strategy based on:
- Fast and slow EMA trend filtering
- RSI pullback confirmation
- ATR-based stop loss and take profit
- Percentage-based position sizing
- Break-even protection
- ATR trailing stop
- Monthly loss protection
- Maximum one position per symbol

The EA does **not** use martingale, grid trading, or high-frequency trading logic.

## Final Parameters

The final candidate used for the reported out-of-sample tests was:

- Fast EMA: 50
- Slow EMA: 300
- RSI Period: 14
- RSI Buy Level: 46
- RSI Sell Level: 56
- ATR Period: 14
- Risk per Trade: 0.50%
- Stop Loss: 1.75 ATR
- Take Profit: 2.50 ATR
- Maximum Monthly Loss: 5%
- Maximum Positions per Symbol: 1

These parameters were selected from the in-sample optimization stage and then tested on an untouched out-of-sample period.

## Backtesting

The reported out-of-sample tests used:
- Initial balance: USD 10,000
- H1 timeframe
- Every tick based on real ticks
- 1:1 tester leverage assumption
- Out-of-sample period: 24 September 2023 – 23 September 2026
- Optimization disabled during the out-of-sample tests

The out-of-sample period is approximately three years. The broader project also considered a seven-year historical window; the three-year OOS period should not be described as a seven-year OOS test.

## Repository Contents

```text
MQL5/Experts/IndustrialTrendPullbackEA.mq5   EA source code
Backtest/final_results_10_instruments.csv    Reported test results
Backtest/optimization_candidate.csv          Selected optimization candidate
Backtest/EXECUTION_NOTES.md                  Testing notes
Report/Industrial_EA_Project_Report.docx     Project report
```

## Important Notes

Backtest performance is historical and does not guarantee future results. The return targets in the assignment are treated as evaluation targets rather than guarantees.
