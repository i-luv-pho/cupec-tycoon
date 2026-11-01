# CUPEC Business City — development build

A 3D acquisition/operations city for four players. Each player has a separate district with twelve businesses, enterable premises, operating terminals and a portfolio UI. Original CUPEC world and gameplay built on the retained MIT Slime Factory Tycoon foundation. Original prototype remains in `releases/CUPEC-Acquisition-District.rbxlx`.

The user selected a bigger city tycoon and authorized three days of development on 1 November 2026. The original small prototype must not be released. Work sessions are scheduled for 2 and 3 November, with final testing/publication follow-up on 4 November at 06:45 Bangkok time. That is a target, conditional on acceptance and Roblox eligibility.

## Current gameplay

- Twelve acquisitions per player across machinery supply, industrial supply, food trading, ingredients, packaging, steel, auto components, food production, electronics and medical equipment.
- Four districts, 48 premises total, roads, streetlights, plaza, benches and distinct interiors.
- Buy businesses, fund two or three operating improvements, visit them and use the operations terminal inside for additional fictional game cash. Operations require proximity and ownership, with a 45-second per-business cooldown enforced by the server.
- Portfolio tabs scroll horizontally. VISIT BUSINESS travels within your own district. WASD walks, E interacts, P toggles the portfolio. Base walking speed is 26.
- Without active work bonuses, the automated progression simulation acquires the final business at 2,299 seconds and completes improvements at 2,592 seconds. This is a balance simulation, not a promise of real player session length.

## DBD case studies

The user requested lightly changed company names with real DBD information. `data/dbd-city-cases.json` is a curated snapshot of twelve exact-ID corporate cases from the existing private company database. Only public corporate identifiers, registered business objectives, financial figures, source URLs and capture dates are copied. No directors, shareholder identities, contacts, private notes or addresses are included.

`cupec/shared/CaseStudies.luau` and the DBD CASE DATA view expose historical annual THB revenue, total assets, net profit, equity and reporting year, with the source legal name and registration ID. The source capture is historical and not freshly verified. Missing amounts remain unavailable. The dataset is not evidence that any business is for sale or underperforming. In-game aliases, asking prices, cash per second, improvements and operating outcomes are fictional scenarios. Reported annual financials are never represented as live cash flow or a seller asking price.

Regenerate the curated module/config aliases with `python3 ../tools/import_city_cases.py` while the external SSD is accessible. Source records remain read-only; this script does not alter the company database.

## Validation and remaining work

77 domain assertions pass (30 economy, 12 save-lease transforms, 35 city progression/operations). All Luau compiles, and Rojo builds the current export.

In Studio, four districts / 48 premises / twelve menu tabs were verified. Acquisition, travel, walking inside, proximity operation cash reward, and cooldown rejection passed. The DBD case overlay subsequently rendered correctly. An iPhone XR touch simulation verified the menu starts closed, native movement/jump controls remain available, and the portfolio toggle opens the scrollable menu.

The expanded version is uploaded and privately published as cloud version 4. An actual owner cloud playtest loaded the city at `https://play.roblox.com/games/start?placeId=135362854447570`. Physical phone play and cloud save/rejoin are still pending. Private owner play is distinct from public release.

Still required: deeper operating jobs/contracts, onboarding/objectives, mobile/touch rendered acceptance, full 2–4 player isolation, real cloud save/rejoin, visual polish and actual public joining. The original prototype's single-client flow passed; that does not establish full acceptance of this expansion.

Studio uses temporary memory profiles labelled LOCAL PREVIEW. Live servers use session-leased UpdateAsync saves. Pure lease tests do not prove cloud save availability.

## Build

```sh
../tools/luau/luau cupec/tests/economy.luau
../tools/luau/luau cupec/tests/saves.luau
../tools/luau/luau cupec/tests/city.luau
find cupec -name '*.luau' -print0 | xargs -0 ../tools/luau/luau-compile --null
../tools/rojo build default.project.json -o releases/CUPEC-Business-City-DBD-Day1.rbxlx
```

Open the new export in Studio and press Test. A fresh Rojo export generates its world at runtime. Tool versions: Rojo 7.7.1, Luau 0.745.

## Publication status

Existing private upload: **CUPEC Acquisition Tycoon**, place `135362854447570`, universe `10774083670`, owned by `robloxname123007`. Identity verification shows Complete. Public release was explicitly rejected by the new-creator waiting period; account reaches two days old 3 November 2026 at 05:40:57 Bangkok. No public release or native player-app join is claimed; private cloud-browser joining is verified. The city expansion replaced the private cloud prototype as version 4; actual owner cloud joining succeeded. Public release and physical phone acceptance remain pending.

No paid assets, purchases or ads. Preserve source licenses and verify the actual URL and player join before calling it live.

## Attribution

Original upstream: https://github.com/DLinacre/slime-factory-tycoon . MIT notice retained in LICENSE, original README/project/source retained. CUPEC reuses the number formatter and adapts the authoritative-economy/session-lease pattern. Most active gameplay, city and UI are original. No upstream marketing art or audio is used. Imperium was evaluated as a candidate but is not used in this city build.
