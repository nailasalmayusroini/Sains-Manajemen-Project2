# Industrial-Grade EA Project — MT5 / MQL5

## Strategy
EMA(50/200) trend filter + RSI(14) pullback confirmation + ATR(14) dynamic SL/TP.

Risk controls:
- 0.50% nominal risk per trade
- 1 position per symbol
- No martingale
- No grid
- No HFT/scalping loop; entries are evaluated on closed H1 bars
- ATR-based stop loss and take profit
- Break-even and ATR trailing stop
- Monthly equity loss circuit breaker
- Spread filter
- Magic-number isolation

## Required instruments
Use the exact Exness symbol names shown in your MT5 Market Watch. Suggested coverage:
1. EURUSD — Forex
2. GBPUSD — Forex
3. USDJPY — Forex
4. XAUUSD — Gold
5. XAGUSD — Silver
6. US500 — Index
7. JP225 — Index
8. BTCUSD — Crypto
9. ETHUSD — Crypto
10. USOIL — Energy

Exness may use account-type suffixes such as m/c, so do not rename symbols manually; select the exact broker symbol.

## Backtest protocol
- Platform: MetaTrader 5
- Broker data: Exness
- Model: Every tick based on real ticks
- Initial deposit: USD 10,000
- Leverage: configure the tester/account to the assignment's required non-leveraged/1:1 assumption where supported
- Period: 7 years, ending at the test date
- Timeframe: H1
- Record spread, commission, swap, trade count and history quality.
- Run each instrument separately, then run a portfolio-level evaluation if the assignment requires it.

## Optimization protocol
Use a chronological split rather than optimizing on all 7 years:
- In-sample: first 4 years
- Validation: next 1 year
- Out-of-sample: final 2 years

Optimize only a small set of economically meaningful parameters:
FastEMA, SlowEMA, RSI thresholds, SL ATR multiplier, TP ATR multiplier.
Do not optimize dozens of parameters simultaneously.

Do not select a parameter set only by net profit. Check drawdown, profit factor, number of trades, stability across years and robustness around neighboring parameter values.

## Important
This repository intentionally does not contain fabricated backtest results. Run the EA in your own Exness MT5 environment and replace the CSV template with the actual Strategy Tester outputs.
