# Swing Stock Pilot Report - 2026-05-04

Mode: `weekly`
Pilot start: `2026-05-04`

## Market Filter

- QQQ close: $672.03
- QQQ SMA200: $603.43
- Market filter: ON

## Pilot Performance

| System | Value | Return | Max DD | Trades |
| --- | ---: | ---: | ---: | ---: |
| Swing top-2 rotation | 1.00x | 0.0% | 0.0% | 0 |
| TQQQ reference | 1.00x | 0.0% | n/a | live bot owns exits |

Current leader since pilot start: **TQQQ reference**

## Weekly Rotation Candidates

| Rank | Ticker | Close | Initial Stop | 63d Return | 20d Return |
| ---: | --- | ---: | ---: | ---: | ---: |
| 1 | INTC | $97.99 | $86.23 | 100.8% | 93.0% |
| 2 | MRVL | $164.41 | $144.68 | 109.1% | 50.2% |

## Rejected Profit-Taking Pullback Scan

These are tracked only for research. This strategy is not the recommended primary system.

| Rank | Ticker | Close | Initial Stop | 63d RS | 20d Return |
| ---: | --- | ---: | ---: | ---: | ---: |
| 1 | AMAT | $390.30 | $362.67 | 11.5% | 10.7% |
| 2 | LRCX | $257.37 | $234.44 | 1.0% | 16.6% |

## Guardrails

- This swing repo is a demo/pilot for the month.
- The active TQQQ repo remains the source of truth for the open TQQQ trade.
- This repo runs at low frequency to avoid competing with the TQQQ bot for Yahoo data.
- Assume pilot actions are followed only for comparison tracking.
