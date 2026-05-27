# Automation

Last updated: 2026-05-27

## Goal

This repo is now paused and kept as a research archive. It should not send automatic Telegram messages or compete with the active real systems.

## Frequency

Automatic runs are disabled:

- Weekly scan: paused.
- Month-end comparison: paused.
- Manual research reruns: still allowed through GitHub Actions.

Reason: the real stock behavior and bot-only benchmark now live in `real-stock-alert`, while `tqqq-alert` remains the real master system.

## GitHub Action

Workflow:

- `.github/workflows/main.yml`

Manual run:

```bash
gh workflow run main.yml -f mode=weekly
```

The workflow can still be run manually. It:

- installs dependencies,
- runs `script.py`,
- sends Telegram if secrets exist,
- commits `pilot_state.json`,
- commits `reports/latest_report.md`,
- commits dated reports in `reports/`.

Required repository secrets:

- `TELEGRAM_TOKEN`
- `TELEGRAM_CHAT_ID`

## External Scheduler

The external scheduler is paused:

- `scheduler/cloudflare/wrangler.toml` has no cron triggers.
- `scheduler/cloudflare/worker.js` has a `PAUSED` guard and does not dispatch the workflow.

Worker files:

- `scheduler/cloudflare/worker.js`
- `scheduler/cloudflare/wrangler.toml`

Old required Cloudflare secret, only needed if this archive is reactivated later:

- `GITHUB_TOKEN`

The token needs permission to dispatch workflows in `alonmorad9/swing-stock-alert`.

## Month-End Comparison

Every run updates `pilot_state.json` with:

- latest swing pilot value,
- latest swing return,
- latest bot-only benchmark value,
- latest difference versus the bot-only benchmark,
- current paper positions,
- latest TQQQ market reference value,
- latest TQQQ market reference return,
- current leader.

At month end, this repo is optional historical context only. The main comparison should inspect:

- the real `tqqq-alert` repo's `position_state.json`
- the real `real-stock-alert` repo's `position_state.json`

If we want to include the old demo paper pilot, inspect:

- `reports/latest_report.md`
- `reports/*.md`
- `pilot_state.json`

Assumption for the pilot:

- If the swing bot gave an instruction, assume the instruction was followed.
- The TQQQ repo remains the source of truth for the real TQQQ trade.
- The TQQQ line inside this repo is only a market reference, not the real live TQQQ strategy result.
