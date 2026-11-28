# Modi Fire Safety — customer website (MVP demo)

A static site with no build step and no backend. Open `index.html` directly, or serve the folder:

    python3 -m http.server 8080 --directory website

## Pages
- `index.html` — home
- `catalogue.html` — categories, search, add to quotation request
- `quote.html` — quotation request form (saved in this browser only)
- `services.html` — servicing, refilling and inspection requests (saved in this browser only)
- `requests.html` — track saved requests and look them up by reference

## Data
Products and categories come from the app's catalogue. Do not edit `assets/js/data.js` by hand.
Regenerate it from the repository root after changing `lib/data/mock/mock_catalogue.dart`:

    python3 website/tools/build_data.py

## Demo limits
- Prices are illustrative. Nothing is sent to Modi International.
- Requests and quote selections are stored in `localStorage` under keys starting with `modi.demo.`.
- No third-party fonts, CDNs or frameworks are used.

## Files
- `assets/css/site.css` — design tokens (match the app palette) and components
- `assets/js/app.js` — shared helpers (`window.ModiSite`)
- `assets/js/catalogue.js`, `quote.js`, `services.js`, `requests.js` — page behaviour
