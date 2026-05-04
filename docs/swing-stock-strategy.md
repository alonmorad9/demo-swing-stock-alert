# Swing Stock Strategy

Last updated: 2026-05-04

## Goal

Find swing trades in liquid stocks with a clear buy/sell plan and strong historical profit potential.

This is research, not financial advice. The test uses today's liquid growth universe, so historical results have selection bias.

## Recommended Strategy

Name:

- Weekly top-2 swing momentum rotation

Universe:

- Liquid large-cap/growth stocks, mostly Nasdaq-100 style names.
- Script universe is defined in `research/swing_stock_strategy.py`.

Market filter:

- Trade only when `QQQ` is above its 200-day simple moving average.
- If `QQQ` closes below SMA200, sell all positions.

Buy rule:

- Run the scan once per week after the final trading day of the week.
- Rank stocks by:
  - 63-day momentum
  - 20-day momentum
  - strength above SMA50
- Only buy stocks that satisfy:
  - close above SMA50
  - SMA50 above SMA200
  - 63-day return stronger than QQQ
  - average dollar volume above about `$50M/day`
- Hold the top 2 ranked stocks.
- Buy at the next trading day's open.

Sell rule:

- Sell if the stock closes below EMA21.
- Sell if the trailing stop is hit.
- Sell if the stock drops out of the weekly top-2 list.
- Sell all if QQQ closes below SMA200.

Trailing stop:

- Initial stop is the higher of:
  - 12% below entry
  - entry minus 2.5x ATR14
- While open, the stop ratchets up to the higher of:
  - 15% below the highest high since entry
  - highest high since entry minus 3x ATR14

Position sizing:

- Hold at most 2 stocks.
- Use roughly 50% of capital per stock.
- No margin.

## Profit-Taking Pullback Test

Because the desired style was "take short profits, keep riding waves, and recycle capital," I also tested a dedicated pullback/profit-taking strategy.

Tested rule:

- Buy strong stocks after a pullback toward EMA21/SMA20.
- Only buy when QQQ is above SMA200.
- Sell part of the position at a profit target.
- Move the stop up after the trim.
- Let the rest ride with a trailing stop.

Parameter sweep:

- Profit targets: 8%, 12%, 15%, 20%, 30%
- Trim sizes: 25%, 50%, 75%
- Max positions: 2, 3, 4, 5

Best result from the sweep:

| Strategy | Final | CAGR | Max DD | Calmar | Trades |
| --- | ---: | ---: | ---: | ---: | ---: |
| Pullback profit-taking, best tested variant | 2.7x | 12.8% | -26.3% | 0.49 | 1,649 |

Conclusion:

- This version is not good enough.
- It trades constantly but does not compound well.
- The problem is that taking partial profits too mechanically cuts too many winners and leaves too much churn.
- The better swing approach is still to own the strongest names and exit when strength breaks, not to force frequent profit-taking.

## Historical Proof

Backtest script:

- `research/swing_stock_strategy.py`

Daily data source:

- Yahoo Finance adjusted OHLCV data.

Main result from 2018-01-01 through 2026-05-04:

| Strategy | Final | CAGR | Max DD | Calmar | Trades |
| --- | ---: | ---: | ---: | ---: | ---: |
| Weekly top-2 swing momentum rotation | 16.5x | 40.0% | -39.5% | 1.01 | 480 |
| Current TQQQ live-like strategy | 16.1x | 39.6% | -34.9% | 1.14 | 45 |
| TQQQ buy and hold | 11.3x | 33.8% | -81.7% | 0.41 | 1 |
| QQQ buy and hold | 4.5x | 19.8% | -35.1% | 0.56 | 1 |
| Best pullback profit-taking variant | 2.7x | 12.8% | -26.3% | 0.49 | 1,649 |

Out-of-sample style check from 2021-01-01 through 2026-05-04:

| Strategy | Final | CAGR | Max DD | Calmar |
| --- | ---: | ---: | ---: | ---: |
| Weekly top-2 swing momentum rotation | 7.2x | 45.0% | -30.8% | 1.46 |

## Current Scan

As of the latest daily bar in the test data, 2026-05-04:

- QQQ close: `$676.52`
- QQQ SMA200: `$603.45`
- Market filter: ON

Top current candidates:

| Rank | Ticker | Close | Initial Stop | 63d Return | 20d Return |
| ---: | --- | ---: | ---: | ---: | ---: |
| 1 | INTC | `$98.89` | `$87.02` | 102.6% | 94.7% |
| 2 | MRVL | `$164.64` | `$144.88` | 109.4% | 50.4% |

Pullback profit-taking scan candidates, not recommended as primary strategy:

| Rank | Ticker | Close | Initial Stop | 63d Relative Strength | 20d Return |
| ---: | --- | ---: | ---: | ---: | ---: |
| 1 | AMAT | `$393.54` | `$365.91` | 11.8% | 11.6% |
| 2 | LRCX | `$259.74` | `$236.81` | 1.3% | 17.7% |

Important execution note:

- The proven version is weekly.
- If following the backtest exactly, run the scan after the final trading day of the week and enter the next trading day at the open.
- The 2026-05-04 list is a current preview, not an official weekly-rebalance signal unless it is the final trading day of the week.

## Outputs

- `research/out/weekly_rotation_equity_curve.csv`
- `research/out/weekly_rotation_trades.csv`
- `research/out/weekly_rotation_current_signals.csv`
- `research/out/swing_equity_curve.csv`
- `research/out/swing_trades.csv`
- `research/out/swing_current_signals.csv`
- `research/out/pullback_profit_taker_equity_curve.csv`
- `research/out/pullback_profit_taker_trades.csv`
- `research/out/pullback_profit_taker_current_signals.csv`
