# Algorithmic Trading Project Report
## Industrial-Grade Expert Advisor Using MetaTrader 5

### Abstract
This project develops and evaluates a rule-based Expert Advisor (EA) for MetaTrader 5. The system combines long-term trend identification, RSI pullback confirmation, ATR-based risk management, and strict position controls. The design explicitly excludes martingale, grid trading, and high-frequency trading. The EA is intended for systematic backtesting using Exness historical data and the MetaTrader 5 “Every tick based on real ticks” model.

> **Important:** Numerical performance claims in this report must be filled from the actual Strategy Tester reports. No fabricated results should be submitted.

### 1. Objectives
The project objectives are:
1. Develop an industrial-style MQL5 Expert Advisor.
2. Test the EA on ten instruments covering forex, metals, indices, crypto and energy.
3. Use seven years of historical data.
4. Use “Every tick based on real ticks”.
5. Apply optimization with chronological validation.
6. Control drawdown and trading risk without martingale, grid or HFT methods.
7. Evaluate monthly and annual return consistency.

### 2. Instruments
| Category | Instrument | Exact Exness symbol used |
|---|---|---|
| Forex | EURUSD | [fill] |
| Forex | GBPUSD | [fill] |
| Forex | USDJPY | [fill] |
| Metal | Gold | [fill] |
| Metal | Silver | [fill] |
| Index | US500 | [fill] |
| Index | JP225 | [fill] |
| Crypto | BTCUSD | [fill] |
| Crypto | ETHUSD | [fill] |
| Energy | USOIL | [fill] |

### 3. Strategy Design
The EA uses:
- EMA 50 and EMA 200 for trend direction.
- RSI 14 for pullback confirmation.
- ATR 14 for volatility-adaptive exits.
- 0.50% nominal risk per trade.
- One position per symbol.
- Break-even and ATR trailing protection.
- Monthly loss circuit breaker.
- Spread and execution controls.

### 4. Entry Rules
BUY:
1. EMA 50 > EMA 200.
2. Closed candle closes above EMA 50.
3. RSI on the previous closed candle recovers through the buy threshold.
4. No existing EA position on the symbol.
5. Monthly loss circuit breaker is not active.

SELL:
1. EMA 50 < EMA 200.
2. Closed candle closes below EMA 50.
3. RSI recovers downward through the sell threshold.
4. No existing EA position on the symbol.
5. Monthly loss circuit breaker is not active.

### 5. Exit and Risk Rules
Stop Loss = ATR × optimized multiplier.
Take Profit = ATR × optimized multiplier.
Position size is calculated from account equity and stop-loss distance. This avoids fixed-lot scaling across instruments with different volatility and contract specifications.

### 6. Backtesting Methodology
Use MT5 Strategy Tester with:
- Model: Every tick based on real ticks.
- Broker: Exness.
- Initial deposit: USD 10,000.
- Timeframe: H1.
- Test horizon: seven years ending at the chosen report date.
- Costs: broker-provided spread/commission/swap settings.
- Real account setting: use the assignment-required account assumptions; do not imply live trading occurred.

MetaTrader documentation states that real-tick testing uses real ticks accumulated by the broker and is designed to be close to real market conditions. [Add citation in final submitted report.]

### 7. Optimization Method
To reduce overfitting, use:
- In-sample: 4 years.
- Validation: 1 year.
- Out-of-sample: 2 years.

Primary optimization parameters:
- Fast EMA
- Slow EMA
- RSI buy/sell thresholds
- ATR stop multiplier
- ATR target multiplier

The selected parameter set should be retained only if it remains reasonably stable in validation and out-of-sample testing. A single exceptional optimization result should not be treated as evidence of robustness.

### 8. Performance Requirements
The assignment specifies:
- Monthly target: approximately 3–5%.
- Maximum drawdown: approximately 25–30%.
- Annual target: approximately 50–70%.
- No more than six losing months in one year.

These are evaluation targets, not guarantees. The actual results must be reported exactly as produced by MT5.

### 9. Results
#### 9.1 Instrument-level Results
| Instrument | Net Profit | Return % | Max DD % | PF | Trades | Winning Months | Losing Months |
|---|---:|---:|---:|---:|---:|---:|---:|
| EURUSD | [fill] | [fill] | [fill] | [fill] | [fill] | [fill] | [fill] |
| GBPUSD | [fill] | [fill] | [fill] | [fill] | [fill] | [fill] | [fill] |
| USDJPY | [fill] | [fill] | [fill] | [fill] | [fill] | [fill] | [fill] |
| XAUUSD | [fill] | [fill] | [fill] | [fill] | [fill] | [fill] | [fill] |
| XAGUSD | [fill] | [fill] | [fill] | [fill] | [fill] | [fill] | [fill] |
| US500 | [fill] | [fill] | [fill] | [fill] | [fill] | [fill] | [fill] |
| JP225 | [fill] | [fill] | [fill] | [fill] | [fill] | [fill] | [fill] |
| BTCUSD | [fill] | [fill] | [fill] | [fill] | [fill] | [fill] | [fill] |
| ETHUSD | [fill] | [fill] | [fill] | [fill] | [fill] | [fill] | [fill] |
| USOIL | [fill] | [fill] | [fill] | [fill] | [fill] | [fill] | [fill] |

#### 9.2 Monthly Analysis
Attach or reproduce the MT5 monthly performance table. Count profitable and losing months for each instrument and for the combined portfolio.

#### 9.3 Optimization Results
| Parameter | Range | Step | Selected |
|---|---|---|---|
| Fast EMA | [fill] | [fill] | [fill] |
| Slow EMA | [fill] | [fill] | [fill] |
| RSI Buy | [fill] | [fill] | [fill] |
| RSI Sell | [fill] | [fill] | [fill] |
| SL ATR | [fill] | [fill] | [fill] |
| TP ATR | [fill] | [fill] | [fill] |

### 10. Robustness Checks
Report:
- Neighboring parameter stability.
- In-sample vs validation performance.
- Out-of-sample performance.
- Drawdown stability.
- Trade count.
- Profit factor.
- Sensitivity to spread/cost assumptions.
- Performance by calendar year.

### 11. Discussion
The main question is not whether one parameter set produces the highest historical return. The main question is whether the strategy remains reasonably stable when evaluated on unseen data and under realistic transaction costs.

### 12. Conclusion
The final conclusion should be written only after the seven-year real-tick tests are completed. It should state whether the observed results met the assignment targets and should clearly distinguish historical backtest performance from future trading expectations.
