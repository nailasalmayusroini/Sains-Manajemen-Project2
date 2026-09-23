# Backtest and Optimization Notes

## Optimization

- Overall historical window: 23 September 2019 – 23 September 2026
- In-sample optimization: 23 September 2019 – 23 September 2023
- Untouched out-of-sample period: 24 September 2023 – 23 September 2026
- Model: Every tick based on real ticks
- Initial balance: USD 10,000
- Tester leverage assumption: 1:1
- Timeframe: H1
- Optimization method: Fast genetic algorithm
- Optimization criterion: Profit Factor

Search ranges were kept small and focused on Fast EMA, Slow EMA, RSI thresholds, and ATR stop/target multipliers.

The final candidate used for OOS testing was 50/300 EMA, RSI 46/56, SL 1.75 ATR, and TP 2.50 ATR.

## Out-of-Sample Test Set

EURUSD, GBPUSD, USDJPY, USDCHF, USDCAD, NZDUSD, USDCNH, US500, USTEC, and JPN225.

XAUUSD was not included in the final table because the available test history was only 44% and produced no trades, so it was not considered a valid performance result.
