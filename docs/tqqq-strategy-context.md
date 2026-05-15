# TQQQ Strategy Research Handoff

Last updated: 2026-05-04

Status note, 2026-05-15: this file is historical context copied into the swing demo repo. The live TQQQ strategy and real TQQQ/XLK state are maintained in the `tqqq-alert` repo. For month-end, use `tqqq-alert/position_state.json` and `tqqq-alert/docs/monthly-context.md` as the source of truth.

## Purpose

This file is a compact context handoff for a new research chat. The goal is to continue strategy research without rereading the whole prior conversation.

The live repo is an automated TQQQ alert bot. It sends Telegram instructions, but the human executes real trades manually.

## Current Live Bot Strategy

Asset:

- Execution asset: `TQQQ`
- Long only

Entry:

- Buy/re-enter when TQQQ crosses above its 200-day simple moving average (`SMA200`).

Full exit:

- Sell all if TQQQ crosses below `SMA200`.
- Sell all if the true ratcheting trailing stop is hit.

Trailing stop:

- Stop is 25% below the highest high since entry.
- Formula: `highest_high_since_entry * 0.75`
- It only moves upward while a position is open.
- It resets after a full exit and starts again after the next entry.

Profit taking:

- Every +125% from entry, sell 90% of remaining shares.
- First target multiple: `2.25x`
- Then next target increments by `+1.25x`, so after first trim the next target is `3.50x`, then `4.75x`, etc.

Current tracked real position state:

```json
{
  "avg_cost": 61.54,
  "cash": 0.0,
  "entry_date": "2026-04-29",
  "highest_high_since_entry": 65.84,
  "next_profit_multiple": 2.25,
  "position_open": true,
  "shares": 40.4647,
  "ticker": "TQQQ"
}
```

Current implied levels:

- Trailing stop: about `$49.38`
- Next profit target: about `$138.47`

## Scheduling And Data

Scheduler:

- Cloudflare Worker triggers GitHub Actions.
- Intraday checks run every 10 minutes during NASDAQ trading hours.
- Daily reports run 15 minutes after market open and 15 minutes before market close.

Price handling:

- The bot uses Yahoo/yfinance.
- Daily data is used for SMA/RSI/ATR calculations.
- During market hours, the bot overlays Yahoo's latest 1-minute TQQQ bar on top of the daily history.
- If the latest 1-minute price is stale by more than 30 minutes while the market is open, the run fails instead of trading on stale data.
- Telegram reports include a price source line, such as `1m bar ...`.

Important caveat:

- Yahoo/yfinance can be flaky. A second price source fallback is a future improvement.

## Backtest Tooling

Research file:

- `research/backtest_trailing_stops.py`

It can fetch historical Yahoo chart data and compare strategy variants.

Important correction:

- A previous quick sweep mislabeled some profit rules. The corrected model starts the first profit target at `1 + profit_step`.
- Example: `profit_step = 1.25` means first target is `2.25x`, not `2.0x`.

## Strategies Already Tested

Trailing stops:

- Old rolling 30-day high minus 35%.
- True ratchet stops at 15%, 20%, 22.5%, 25%, 27.5%, 30%, 35%, 40%.
- ATR stops based on daily low, close, and highest high.
- ATR multipliers from roughly 1x to 8x.

Conclusion:

- Best practical stop remains true 25% ratchet from highest high since entry.
- ATR stops were worse unless extremely wide, and still did not clearly beat the 25% ratchet.

Trend filters:

- SMA100, SMA150, SMA200.
- EMA100, EMA150, EMA200.
- QQQ signal filters.

Conclusion:

- SMA200 was the best simple trend backbone.
- Faster trend filters caused too much churn.

VIX filters:

- VIX exits at 30, 35, 40 with different re-entry thresholds.

Conclusion:

- VIX added complexity without enough improvement.

QQQ/TQQQ "Sniper" strategy:

- Signal asset: QQQ.
- Execution asset: TQQQ.
- QQQ above SMA200.
- EMA9 above EMA21.
- RSI filters.
- ATR3 stop.
- RSI>80 trims.

Conclusion:

- Performed much worse than the simpler SMA200 TQQQ strategy.

RSI sell and re-buy strategy:

- Tested RSI full exits at 70, 75, 80, 85, 90.
- Tested re-buy levels from 45 to 70.
- Tested several re-entry modes.

Best RSI variant:

- Sell all when RSI >= 80.
- Re-buy when RSI <= 70 and price is still above SMA200.

Result:

| Strategy | Final | CAGR | Max DD | Trades | Exits |
| --- | ---: | ---: | ---: | ---: | ---: |
| Current baseline | 77.8x | 32.6% | -42.7% | 92 | 43 |
| Best RSI sell/re-buy | 78.1x | 32.6% | -49.7% | 214 | 107 |

Conclusion:

- RSI sell/re-buy produced almost no extra final return.
- It caused much more trading and worse drawdown.
- Keep RSI as report context only, not as a trading trigger.

Profit-taking:

Tested:

- No profit taking.
- Frequent small trims at +10%, +20%, +25%, +50%.
- Larger trims at +100%, +125%, +200%, +250%.
- Trim fractions from 5% to 90%.

Key findings:

- Small frequent profit grabs feel good emotionally but reduced long-term compounding.
- Best practical profit rule was `+125%, sell 90%`.

Current live strategy result:

| Strategy | Final | CAGR | Max DD | Trades | Exits | Trims |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| SMA200 + 25% ratchet + +125% sell 90% | 77.8x | 32.6% | -42.7% | 92 | 43 | 5 |

## Individual Stock Research

Question tested:

- Could applying the same strategy to individual stocks beat TQQQ?

Stocks tested:

- `NVDA`, `AAPL`, `MSFT`, `AMZN`, `GOOGL`, `META`, `TSLA`, `AVGO`, `AMD`, `NFLX`, `COST`, `ORCL`, `ADBE`, `CRM`

Same strategy on single stocks:

| Asset | Strategy Final | CAGR | Max DD |
| --- | ---: | ---: | ---: |
| TQQQ | 77.8x | 32.6% | -42.7% |
| NVDA | 29.0x | 24.2% | -44.7% |
| AAPL | 15.1x | 19.1% | -35.3% |
| NFLX | 13.2x | 18.0% | -45.9% |
| META | 11.7x | 20.5% | -28.0% |

Conclusion:

- Applying the same trend strategy to one individual stock did not beat TQQQ.

## Momentum Rotation Research

Question tested:

- Could rotating between strong individual Nasdaq/AI/mega-cap stocks beat TQQQ?

Simple test:

- Universe: today's known mega-cap/AI winners.
- Rank stocks by 6-month momentum.
- Rotate monthly or weekly into top 1, 2, 3, or 5 names.
- Optional SMA200 filter.

Best results since 2013-03-07:

| Strategy | Final | CAGR | Max DD |
| --- | ---: | ---: | ---: |
| Monthly rotate top 2 by 6-month momentum | 426.9x | 58.5% | -51.9% |
| Monthly rotate top 1 by 6-month momentum | 372.3x | 56.8% | -60.6% |
| Monthly rotate top 3 by 6-month momentum | 191.9x | 49.1% | -44.9% |
| TQQQ buy and hold since 2013-03-07 | 109.6x | 42.9% | -81.7% |
| TQQQ current strategy since 2013-03-07 | 39.2x | 32.2% | -42.7% |

Important warning:

- This has serious survivorship bias.
- The test used today's known winners, such as NVDA, AVGO, TSLA, META.
- A proper test must use a historically valid universe, such as Nasdaq-100 constituents at each point in time, or at least a broader fixed universe with delisted/underperforming names included.

Preliminary conclusion:

- Single-stock trend strategy: not better than TQQQ.
- Stock momentum rotation: historically much better in the biased test, but riskier and not yet trustworthy enough for live automation.

## Recommended Next Research

Research goal:

- Decide whether a separate monthly momentum rotation bot is worth building.

Questions to answer:

1. Can a less biased universe be obtained?
   - Historical Nasdaq-100 constituents by date would be ideal.
   - If unavailable, use a broad fixed universe and explicitly label survivorship bias.

2. Which rotation rule is robust?
   - Monthly top 2 by 6-month momentum.
   - Monthly top 3 by 6-month momentum.
   - Weekly top 2 or top 3.
   - With and without SMA200 filter.

3. What is the tax/trading impact?
   - Rotation may create many taxable events.
   - It may be harder to follow manually than the TQQQ bot.

4. What drawdown is acceptable?
   - Top 2 rotation had much higher returns but about -52% max drawdown.
   - Top 3 had lower return but better drawdown around -45%.

5. Should it be separate from the TQQQ bot?
   - Recommendation: yes.
   - Keep the current TQQQ bot stable.
   - Research rotation separately before touching live TQQQ automation.

## Current Recommendation

Do not change the live TQQQ bot right now.

The current TQQQ strategy is simple, tested, and operational. It should run for a month before further changes.

The best next research path is a separate "Nasdaq Momentum Rotation" study, not another tweak to the TQQQ bot.
