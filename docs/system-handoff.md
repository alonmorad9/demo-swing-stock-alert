# System Handoff

Last updated: 2026-05-15

## Purpose

This repo is the second trading system. It should stay separate from the existing TQQQ alert bot.

Primary system:

- Existing repo: `tqqq-alert`
- Strategy: high-risk/high-reward TQQQ swing system with XLK waiting-asset tracking
- Status: real system; currently no open TQQQ, tracked XLK waiting-asset exposure

Second system:

- New repo: `swing-stock-alert`
- Strategy: weekly top-2 swing momentum rotation
- Status: research/pilot candidate
- Paper tracking: seeded from the first official report on 2026-05-04, assuming 50% `INTC` and 50% `MRVL`.

## Recommended Operating Plan

Do now:

- Continue managing the real TQQQ/XLK path only from the `tqqq-alert` repo.
- Use this repo to run weekly swing scans.
- Treat swing alerts as pilot signals until enough live/paper evidence accumulates.

Do not do yet:

- Do not replace TQQQ with the swing strategy.
- Do not force frequent short profit-taking. The backtest rejected that idea.

## Strategy Decision

The weekly top-2 swing rotation is the best stock-swing candidate found so far.

For this month's demo, the repo tracks a simple paper portfolio because the pilot started before the first normal Friday rebalance:

- `INTC`, 50% allocation, seeded from the 2026-05-04 report at `$97.99`
- `MRVL`, 50% allocation, seeded from the 2026-05-04 report at `$164.41`

The pullback profit-taking system was tested because it matched the user's instinct to take short profits and recycle capital. It underperformed:

- Too many trades.
- Too little compounding.
- Winners were cut too mechanically.

The better active approach is:

- Buy the strongest stocks.
- Hold while strength continues.
- Sell when strength breaks.

## Current TQQQ Context

From the current TQQQ repo state/strategy as of 2026-05-15:

- Ticker: `TQQQ`
- Current mode: manual safety mode after a user-recorded manual sell, with tracked XLK waiting-asset exposure
- Position open: false
- Shares: `0.0`
- Tracked cash: about `$26.13`
- Waiting asset: `XLK`, `15.1158` shares, average cost `$178.62`
- Manual exit price: `$67.37`
- Manual exit date: `2026-05-05`
- Manual below-SMA reset seen: false
- Current selected TQQQ trailing stop: 14% true ratchet
- Profit target: sell all at +20% from average cost
- Parabolic auto-exit: sell profitable TQQQ if 5-day return is at least 25%
- Re-entry guard: TQQQ RSI14 must be at or below 65
- Manual safety sell mode exists: if the user manually sells TQQQ, the TQQQ repo can be marked with `manual_sold` and a manual sell price.
- In manual safety mode, the bot waits for a manual re-buy trigger: 7.5% pullback from manual exit price, SMA200 reset, or 20-trading-day timeout while above SMA200, plus RSI14 <= 65.
- XLK is the waiting asset while out of TQQQ. The TQQQ repo tracks real XLK shares if they are manually recorded.

Recommendation as of 2026-05-15:

- Follow the TQQQ repo's manual safety-mode re-buy instructions.
- Do not treat the swing repo's TQQQ market reference as the real TQQQ result.
- Let the strategy rules decide.

## Month-End Comparison Rule

The swing repo's automated TQQQ line is only a simple market reference from the pilot start date.

For the real winner calculation, inspect the `tqqq-alert` repo directly:

- `position_state.json`
- `manual_exit_mode`, `manual_exit_price`, `manual_exit_date`, `cash`, and XLK parking fields if a manual sell/waiting-asset buy happened
- recent GitHub Actions runs
- any Telegram trade instructions
- current strategy code/commits

The TQQQ repo remains the source of truth for the real strategy.
