# System Handoff

Last updated: 2026-05-04

## Purpose

This repo is the second trading system. It should stay separate from the existing TQQQ alert bot.

Primary system:

- Existing repo: `tqqq-alert`
- Strategy: TQQQ long-only trend system
- Status: live/open trade

Second system:

- New repo: `swing-stock-alert`
- Strategy: weekly top-2 swing momentum rotation
- Status: research/pilot candidate

## Recommended Operating Plan

Do now:

- Continue managing the current TQQQ position under the existing TQQQ rules.
- Use this repo to run weekly swing scans.
- Treat swing alerts as pilot signals until enough live/paper evidence accumulates.

Do not do yet:

- Do not replace TQQQ with the swing strategy.
- Do not force frequent short profit-taking. The backtest rejected that idea.

## Strategy Decision

The weekly top-2 swing rotation is the best stock-swing candidate found so far.

The pullback profit-taking system was tested because it matched the user's instinct to take short profits and recycle capital. It underperformed:

- Too many trades.
- Too little compounding.
- Winners were cut too mechanically.

The better active approach is:

- Buy the strongest stocks.
- Hold while strength continues.
- Sell when strength breaks.

## Current TQQQ Trade Context

From the original TQQQ repo handoff:

- Ticker: `TQQQ`
- Avg cost: `$61.54`
- Shares: `40.4647`
- Entry date: `2026-04-29`
- Highest high since entry: `$65.84`
- Current trailing stop at handoff: about `$49.38`
- Next profit target: about `$138.47`

Recommendation as of 2026-05-04:

- Hold TQQQ under the current strategy.
- Do not manually take profit around a small gain.
- Let the strategy rules decide.
