# CUPEC Acquisition Tycoon

A Roblox prototype about buying useful assets, fixing operations, and building global sales. Forked from [Slime Factory Tycoon](https://github.com/DLinacre/slime-factory-tycoon), under the retained MIT license.

## Current status

- Source, 42 passing domain assertions, and a Studio-openable place are prepared. The complete acquisition/improvement flow passed an in-engine server/client acceptance run.
- Roblox Studio is installed on the development Mac.
- **Uploaded to Roblox as CUPEC Acquisition Tycoon. Public release is pending Roblox account eligibility.** Place ID: `135362854447570`; universe ID: `10774083670`.
- No paid products, pets, paid random rewards, ads, external web requests, or real-money trading are enabled.

## Play locally

1. Sign into Roblox Studio.
2. Open `releases/CUPEC-Acquisition-District.rbxlx`.
3. Press **F5 / Test**. The committed release export includes an edit-mode preview. Runtime regenerates the district on each server start. A fresh Rojo build contains scripts only until Play.
4. Use WASD to walk. Use the Portfolio panel or press E at your own business desk. P hides/shows the panel.
5. Acquire Siam Works for $300 of your $450 starting cash. Fund production improvements, buy Relay Logistics, then Atlas Exports.

Studio runs deliberately use temporary profiles, with a visible LOCAL PREVIEW label. They never read or overwrite live player saves. Progress resets between Studio sessions. Published servers use a separate real DataStore with per-session leases, autosave, and leave/shutdown saves. Those cloud interactions still need live validation.

## Development

The active Rojo project is `default.project.json`; it mounts only `cupec/` and the original `src/shared/Format.luau`. The old slime game remains in `src/`, but is not executed. Its original project is available as `upstream.project.json` and its documentation as `README.upstream.md`.

```sh
luau cupec/tests/economy.luau
luau cupec/tests/saves.luau
find cupec -name '*.luau' -print0 | xargs -0 luau-compile --null
rojo build default.project.json -o releases/CUPEC-Acquisition-District.rbxlx
```

Verified tooling: Rojo 7.7.1 and Luau 0.745. On the development Mac they are in `../tools/`.

## Design

- Four independent portfolios in one shared district.
- Three acquisitions, each with two operating improvements.
- Purchase price and book asset value shown separately; cash flow changes with a 75-second market cycle.
- A 15% operating synergy connects manufacturing with logistics.
- Prices and ownership are resolved by the server. The client sends an action and business ID, never an amount or player ID.
- The panel scrolls on short screens and can be collapsed to explore.
- All cash, companies and valuations are fictional game mechanics.

## Remaining acceptance checks

- Desktop and portrait layouts inspected in Studio; physical phone playtest remains.
- Buy and improve all three businesses: full client/server flow passed after fixing burst request handling. Own-plot spawns were verified.
- Two-client tests observed distinct spawns and independent profiles. A complete multiplayer acceptance pass is still pending: the initial runs caught dropped upgrades, then later Studio client launches timed out. No full multiplayer pass is claimed.
- On a private published test experience, verify leave/rejoin persistence, autosave, server handoff, and store outage behavior. Studio's pure tests validate the lease transforms, not Roblox cloud availability.
- Maximum players is configured to 4. The place is uploaded privately; genre is Simulation / Tycoon and a gameplay overview thumbnail is submitted. Public release is waiting at Roblox’s QR age-verification gate. Player-app acceptance and public join remain pending.

Do not describe the game as live until an actual Roblox URL and player join have been verified.

## Attribution

The MIT license and original copyright notice are retained in `LICENSE`. CUPEC uses the original number formatting module and adapts the upstream server-authoritative economy / UpdateAsync lease architecture. Most CUPEC gameplay, world generation and UI are new. Upstream marketing images and audio are not used in the CUPEC place.
