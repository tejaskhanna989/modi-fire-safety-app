from reportlab.lib.pagesizes import A4
from reportlab.lib.units import mm
from reportlab.lib import colors
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib.enums import TA_LEFT, TA_CENTER
from reportlab.platypus import (
    BaseDocTemplate, PageTemplate, Frame, Paragraph, Spacer, Table, TableStyle,
    PageBreak, Image, KeepTogether, ListFlowable, ListItem, NextPageTemplate,
)
from reportlab.platypus.tableofcontents import TableOfContents

OUT = "/home/user/modi-fire-safety-app/docs/Modi_Fire_Safety_User_Manual.pdf"
LOGO = "/home/user/modi-fire-safety-app/assets/brand/flame_logo.png"

NAVY = colors.HexColor("#14263D")
RED = colors.HexColor("#D9272E")
GREY_BG = colors.HexColor("#F4F6F8")
CHARCOAL = colors.HexColor("#1C2127")
SLATE = colors.HexColor("#5E6772")
LINE = colors.HexColor("#DDE2E8")

base = ParagraphStyle("base", fontName="Helvetica", fontSize=10, leading=14.5,
                      textColor=CHARCOAL, spaceAfter=6)
body = base
small = ParagraphStyle("small", parent=base, fontSize=8.5, leading=11, textColor=SLATE)
h1 = ParagraphStyle("h1", parent=base, fontName="Helvetica-Bold", fontSize=18,
                    leading=22, textColor=NAVY, spaceBefore=4, spaceAfter=10)
h2 = ParagraphStyle("h2", parent=base, fontName="Helvetica-Bold", fontSize=12.5,
                    leading=16, textColor=NAVY, spaceBefore=10, spaceAfter=4)
h3 = ParagraphStyle("h3", parent=base, fontName="Helvetica-Bold", fontSize=10.5,
                    leading=14, textColor=CHARCOAL, spaceBefore=6, spaceAfter=2)
note = ParagraphStyle("note", parent=base, fontSize=9.5, leading=13.5,
                      textColor=NAVY, backColor=GREY_BG, borderPadding=(6, 6, 6, 6),
                      spaceBefore=6, spaceAfter=10)
cell = ParagraphStyle("cell", parent=base, fontSize=9, leading=12, spaceAfter=0)
cell_b = ParagraphStyle("cell_b", parent=cell, fontName="Helvetica-Bold", textColor=NAVY)
toc1 = ParagraphStyle("toc1", parent=base, fontName="Helvetica-Bold", fontSize=10.5,
                      leading=17, textColor=NAVY, leftIndent=0)
toc2 = ParagraphStyle("toc2", parent=base, fontSize=9.5, leading=14, leftIndent=12)


class Doc(BaseDocTemplate):
    def __init__(self, filename, **kw):
        BaseDocTemplate.__init__(self, filename, **kw)
        frame = Frame(20 * mm, 22 * mm, A4[0] - 40 * mm, A4[1] - 42 * mm, id="body")
        cover = Frame(20 * mm, 22 * mm, A4[0] - 40 * mm, A4[1] - 44 * mm, id="cover")
        self.addPageTemplates([
            PageTemplate(id="cover", frames=[cover], onPage=self._cover_page),
            PageTemplate(id="body", frames=[frame], onPage=self._body_page),
        ])

    def _cover_page(self, canv, doc):
        canv.saveState()
        canv.setFillColor(NAVY)
        canv.rect(0, A4[1] - 6 * mm, A4[0], 6 * mm, stroke=0, fill=1)
        canv.setFillColor(RED)
        canv.rect(0, A4[1] - 8 * mm, A4[0], 2 * mm, stroke=0, fill=1)
        canv.restoreState()

    def _body_page(self, canv, doc):
        canv.saveState()
        canv.setStrokeColor(LINE)
        canv.line(20 * mm, 16 * mm, A4[0] - 20 * mm, 16 * mm)
        canv.setFont("Helvetica", 8)
        canv.setFillColor(SLATE)
        canv.drawString(20 * mm, 10 * mm, "Modi Fire Safety  |  Customer App User Manual (Demo MVP)  |  v0.1.0")
        canv.drawRightString(A4[0] - 20 * mm, 10 * mm, "Page %d" % doc.page)
        canv.restoreState()

    def afterFlowable(self, flowable):
        if isinstance(flowable, Paragraph):
            style = flowable.style.name
            if style == "h1":
                self.notify("TOCEntry", (0, flowable.getPlainText(), self.page))
            elif style == "h2":
                self.notify("TOCEntry", (1, flowable.getPlainText(), self.page))


def P(text, style=body):
    return Paragraph(text, style)


def bullets(items):
    return ListFlowable(
        [ListItem(P(i, base), leftIndent=12, value="circle") for i in items],
        bulletType="bullet", start="circle", leftIndent=12, bulletFontSize=6,
        bulletColor=NAVY, spaceBefore=0, spaceAfter=6,
    )


def steps(items):
    return ListFlowable(
        [ListItem(P(i, base), leftIndent=16) for i in items],
        bulletType="1", leftIndent=16, bulletFontName="Helvetica-Bold",
        bulletFontSize=9.5, bulletColor=NAVY, spaceAfter=6,
    )


def table(rows, widths, header=True):
    data = []
    for r_i, row in enumerate(rows):
        style = cell_b if (header and r_i == 0) else cell
        data.append([P(str(c), style) for c in row])
    t = Table(data, colWidths=widths, repeatRows=1 if header else 0)
    ts = [
        ("VALIGN", (0, 0), (-1, -1), "TOP"),
        ("GRID", (0, 0), (-1, -1), 0.5, LINE),
        ("LEFTPADDING", (0, 0), (-1, -1), 6),
        ("RIGHTPADDING", (0, 0), (-1, -1), 6),
        ("TOPPADDING", (0, 0), (-1, -1), 4),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 4),
    ]
    if header:
        ts.append(("BACKGROUND", (0, 0), (-1, 0), GREY_BG))
    t.setStyle(TableStyle(ts))
    return t


def section(title, intro=None):
    out = [P(title, h1)]
    if intro:
        out.append(P(intro))
    return out


story = []

# ---------------- Cover ----------------
story.append(Spacer(1, 40 * mm))
story.append(Image(LOGO, width=34 * mm, height=48 * mm, kind="proportional", hAlign="LEFT"))
story.append(Spacer(1, 10 * mm))
story.append(P("Modi Fire Safety", ParagraphStyle("ct", parent=h1, fontSize=30, leading=36)))
story.append(P("Customer App — User Manual", ParagraphStyle("cs", parent=h1, fontSize=18,
                                                       leading=24, textColor=RED)))
story.append(Spacer(1, 6 * mm))
story.append(P("Version 0.1.0 (Phase 3 demo MVP)", base))
story.append(P("Prepared November 2026 for Modi International", base))
story.append(Spacer(1, 14 * mm))
story.append(P("<b>Important:</b> This build is a demonstration. Catalogue items, prices, "
               "equipment, orders and service records are illustrative. Nothing is sent to "
               "Modi International, no payment is taken, and no order is placed with a supplier. "
               "All data is kept only in the memory of this device and is lost when the app closes.",
               note))
story.append(NextPageTemplate("body"))
story.append(PageBreak())

# ---------------- Contents ----------------
story.append(P("Contents", ParagraphStyle("contents_title", parent=h1)))
toc = TableOfContents()
toc.levelStyles = [toc1, toc2]
story.append(toc)
story.append(PageBreak())

# ---------------- 1. Introduction ----------------
story += section("1. Introduction")
story.append(P("The Modi Fire Safety Customer App gives customers one place to browse fire safety "
               "products, request quotations, book servicing, refilling and inspections, register "
               "their equipment, and review their orders and history. Individual and business "
               "customers use the same app."))
story.append(P("This manual describes every screen and action in the current build and states, for "
               "each feature, whether it works in full or is shown as a demonstration."))
story.append(P("1.1 Feature status at a glance", h2))
story.append(table([
    ["Feature", "Status in this build"],
    ["Home dashboard and quick actions", "Available"],
    ["Product catalogue, search, product details", "Available (demo catalogue)"],
    ["Shopping cart", "Available (in memory)"],
    ["Demo checkout and order history", "Simulated. No payment, no real order"],
    ["Quotation requests", "Simulated. Stored on this device only"],
    ["Servicing, refilling and inspection requests", "Simulated. Stored on this device only"],
    ["Equipment register and demo QR visual", "Available. QR visual is not scannable"],
    ["Individual and business profile", "Available. Stored on this device only"],
    ["Fire safety assistant", "Planned. Placeholder screen only"],
    ["Notifications", "Planned. Placeholder screen only"],
], [95 * mm, 75 * mm]))
story.append(Spacer(1, 4))
story.append(P("Note: The app is labelled DEMO and SIMULATED wherever data is not connected to "
               "a real service. Treat every price, reference number and status as illustrative.", small))

# ---------------- 2. Getting started ----------------
story.append(PageBreak())
story += section("2. Getting started")
story.append(P("2.1 Installing the app on Android", h2))
story.append(steps([
    "On your phone, open the GitHub Releases page for this project and download the latest "
    "APK file (named modi-fire-safety-apk-build-N.apk).",
    "Open the downloaded file. If Android asks, allow installs from this source (Settings > "
    "Apps > Special access > Install unknown apps).",
    "Tap Install, then Open. The app ID is com.modifire.safety.demo.",
]))
story.append(P("The app needs Android 5.0 (API 21) or later and an internet connection only to "
               "download and update the build. Nothing you enter is uploaded.", small))
story.append(P("2.2 First launch", h2))
story.append(P("The app opens on the <b>Home</b> tab. No sign-in is required. A demo profile is not "
               "created automatically; you can create one at any time from the <b>Profile</b> tab "
               "(see Section 10)."))
story.append(P("2.3 Labels you will see", h2))
story.append(table([
    ["Label", "Meaning"],
    ["DEMO", "Shown in the top bar. The whole app runs in demo mode."],
    ["DEMO ITEM / DEMO CATALOGUE", "The product or catalogue is illustrative."],
    ["LOCAL DEMO ASSET / LOCAL DEMO PROFILE", "The record exists only on this device."],
    ["SIMULATED / (DEMO) status text", "The action is a simulation. No real transaction happens."],
    ["Illustrative data", "Figures and dates are sample values, not real records."],
], [60 * mm, 110 * mm]))

# ---------------- 3. Navigation ----------------
story.append(PageBreak())
story += section("3. Navigation")
story.append(P("3.1 Bottom navigation bar", h2))
story.append(P("The bar at the bottom of the screen has five tabs. The active tab is highlighted in "
               "navy:"))
story.append(table([
    ["Tab", "What it opens"],
    ["Home", "Dashboard with quick actions, popular essentials and a service reminder."],
    ["Catalogue", "Product categories, search and product grid."],
    ["Services", "Servicing, refilling and inspection requests and their history."],
    ["Orders", "Demo orders and service history."],
    ["Profile", "Your demo profile and shortcuts to all records."],
], [35 * mm, 135 * mm]))
story.append(P("3.2 Top bar icons", h2))
story.append(table([
    ["Icon", "Action"],
    ["Brand (flame logo and MODI / FIRE SAFETY)", "Identifies the app. It is not a button."],
    ["Bell", "Notifications. Planned: currently shows a placeholder message."],
    ["Shopping bag", "Opens the demo cart. A number badge shows how many items are in it."],
    ["Sparkle", "Fire safety assistant. Planned: currently shows a placeholder message."],
], [60 * mm, 110 * mm]))
story.append(P("3.3 Going back", h2))
story.append(P("Use the back arrow in the top bar or your phone's back gesture or button. Screens "
               "you open from a tab return to that tab."))

# ---------------- 4. Home ----------------
story.append(PageBreak())
story += section("4. Home dashboard")
story.append(P("4.1 Hero panel", h2))
story.append(P("A navy panel with the heading <i>Protection you can count on</i>. The button "
               "<b>Explore catalogue</b> opens the product catalogue."))
story.append(P("4.2 Quick actions", h2))
story.append(table([
    ["Tile", "Opens", "Use it to"],
    ["Request quote", "Quotation request form", "Ask for bulk or project pricing."],
    ["Service & refill", "Service request form", "Book a technician for servicing or refilling."],
    ["Equipment", "Equipment register", "Register and track your fire safety equipment."],
    ["Ask assistant", "Assistant placeholder", "Planned. Safety guidance will appear here later."],
], [35 * mm, 50 * mm, 85 * mm]))
story.append(P("4.3 Popular essentials", h2))
story.append(P("A horizontal list of catalogue items. Tap a card to open its product details. The "
               "items come from the same demo catalogue as the Catalogue tab."))
story.append(P("4.4 Service reminder", h2))
story.append(P("An illustrative reminder card with a <b>DUE SOON</b> badge. It is sample data and does "
               "not reflect any real equipment. A reminder will become a live feature once "
               "equipment is linked to a real service schedule."))
story.append(P("4.5 Trust strip", h2))
story.append(P("Three labels at the bottom of the Home tab: <i>Illustrative data</i>, "
               "<i>API-configurable</i> and <i>Local demo build</i>. They remind you of the build's "
               "status."))

# ---------------- 5. Catalogue ----------------
story.append(PageBreak())
story += section("5. Product catalogue")
story.append(P("Open the <b>Catalogue</b> tab to browse products by category. The screen has a search "
               "field (<i>Search demo products</i>), a row of category filters beginning with "
               "<b>All</b>, and a grid of product cards."))
story.append(P("5.1 Categories", h2))
story.append(table([
    ["Category", "Example demo items"],
    ["Extinguishers", "Dry Powder, CO2, Foam and Water Mist Extinguishers"],
    ["Alarms & detectors", "Smoke Detector, Heat Detector, Manual Call Point, Fire Alarm Panel"],
    ["Hoses & reels", "Fire Hose Reel, Canvas Hose"],
    ["Fire blankets", "Fire Blanket"],
    ["Protective equipment", "Safety Helmet, Safety Gloves"],
    ["First aid", "First Aid Kit"],
    ["Safety signage", "Exit Signage"],
    ["Kitchen systems", "Kitchen Suppression System"],
], [50 * mm, 120 * mm]))
story.append(P("5.2 Browsing and filtering", h2))
story.append(steps([
    "Tap a category filter (for example <b>Alarms &amp; detectors</b>) to show only that category.",
    "Tap <b>All</b> to return to the full list.",
    "Use the search field to filter by name or demo tag. If nothing matches, the screen shows "
    "<i>No demo products found</i>.",
]))
story.append(P("5.3 Product details", h2))
story.append(P("Tap any product card to open its details. The page shows the product name, a "
               "DEMO ITEM label, the illustrative price, and the section <i>About this demo entry</i>. "
               "Use <b>Add to demo cart</b> to add one unit. Use <b>Add and view cart</b> to add it "
               "and go straight to the cart. A confirmation message reads <i>Added to the demo cart</i>."))
story.append(P("If a product cannot be loaded, the app shows <i>Product unavailable</i>. Return to "
               "the catalogue and open the product again.", small))

# ---------------- 6. Search ----------------
story += section("6. Search")
story.append(P("Search opens a dedicated screen with the search field focused. Type part of a product "
               "name or a demo tag and tap a result to view its details. Search covers the same demo "
               "catalogue as the Catalogue tab."))

# ---------------- 7. Cart ----------------
story.append(PageBreak())
story += section("7. Demo cart")
story.append(P("Open the cart from the shopping bag icon in the top bar. The number badge shows the "
               "total quantity of items."))
story.append(table([
    ["Control", "Action"],
    ["+ and - buttons", "Increase or decrease the quantity of a line."],
    ["Remove (trash) icon", "Remove a product from the cart."],
    ["Items / Subtotal", "Shows the number of units and an illustrative subtotal."],
    ["Clear demo cart", "Empties the cart after you confirm."],
    ["Proceed to demo checkout", "Opens the checkout review screen."],
    ["Browse catalogue", "Shown when the cart is empty. Opens the catalogue."],
], [55 * mm, 115 * mm]))
story.append(P("The cart is kept in memory for the current session. It is cleared when the app is "
               "closed or the device is restarted.", small))

# ---------------- 8. Checkout & orders ----------------
story.append(PageBreak())
story += section("8. Demo checkout and orders")
story.append(P("8.1 Demo checkout", h2))
story.append(steps([
    "From the cart, tap <b>Proceed to demo checkout</b>. If the cart is empty the screen shows "
    "<i>Nothing to check out</i>.",
    "Review the <b>Review demo order</b> list, the <b>Contact snapshot</b> and the illustrative "
    "subtotal. The contact snapshot shows your saved demo profile, or <i>No demo profile saved</i> "
    "if you have not created one.",
    "Tap <b>Place demo order</b>. The app records a demo order and opens its details.",
]))
story.append(P("Checkout is simulated. No payment gateway is contacted, no card or bank details are "
               "requested, and no supplier receives the order.", note))
story.append(P("8.2 Orders &amp; history", h2))
story.append(P("The <b>Orders</b> tab (also reached from <b>Profile &gt; Orders &amp; history</b>) lists "
               "demo orders and the service history. Each order shows its reference, date, item count "
               "and status:"))
story.append(table([
    ["Status", "Meaning in this build"],
    ["PLACED (DEMO)", "The demo order has been recorded."],
    ["PROCESSING (DEMO)", "Shown as in progress. Illustrative only."],
    ["COMPLETED (DEMO)", "Shown as finished. Illustrative only."],
], [50 * mm, 120 * mm]))
story.append(P("Tap an order to see its line items (product, quantity and price) and the illustrative "
               "total. Two sample orders are included so the list is not empty on first launch.", body))

# ---------------- 9. Services & equipment ----------------
story.append(PageBreak())
story += section("9. Services, refilling and equipment")
story.append(P("9.1 Requesting a service", h2))
story.append(P("Open the <b>Services</b> tab, or use <b>Service &amp; refill</b> on the Home tab. The "
               "screen explains the three request types:"))
story.append(table([
    ["Type", "Description"],
    ["Servicing", "A routine service visit for registered equipment."],
    ["Refilling", "A refill for registered equipment."],
    ["Inspection", "An inspection of registered equipment."],
], [35 * mm, 135 * mm]))
story.append(P("To raise a request:", h3))
story.append(steps([
    "Tap <b>Raise request</b> on the Services tab, or open the service form from the Home tab.",
    "Choose the request type (Servicing, Refilling or Inspection).",
    "Choose the equipment from your register, or select <b>Not registered / other</b>. If you choose "
    "this option, describe the equipment; the description is required.",
    "Pick a <b>preferred date</b> and add optional notes.",
    "Tap <b>Submit demo service request</b>. A confirmation shows the reference number. Tap "
    "<b>Done</b> to return.",
]))
story.append(P("Submitted requests appear under <b>Request history</b>, with a status of SUBMITTED, "
               "IN PROGRESS or COMPLETED. Nothing is sent to a technician.", body))

story.append(P("9.2 Equipment register", h2))
story.append(P("The equipment register is your list of fire safety assets, reached from the Equipment "
               "quick action or from <b>Profile &gt; Equipment register</b>. Two sample assets are "
               "included on first launch."))
story.append(P("<b>To register equipment:</b>", body))
story.append(steps([
    "Tap <b>Register equipment</b>.",
    "Enter the <b>Equipment name</b> (required), <b>Asset tag</b> (required, for example "
    "AST-DEMO-003), and <b>Location</b> (required, for example a site or floor). <b>Notes</b> are "
    "optional.",
    "Tap <b>Register demo equipment</b>. A simulated token is generated locally.",
]))
story.append(P("9.3 Equipment detail", h2))
story.append(P("Tap an asset to see its asset tag, location, registration date and notes, its "
               "service history, and a simulated QR-style visual with a demo token. The visual is "
               "labelled as <b>not scannable</b>. Use <b>Copy token</b> to copy the token text. "
               "Tap <b>Request service for this asset</b> to start a service request for it."))
story.append(P("The QR-style visual is decorative and carries no real asset data. It cannot be scanned "
               "by a QR reader.", note))

# ---------------- 10. Quotations ----------------
story.append(PageBreak())
story += section("10. Quotation requests")
story.append(P("Use <b>Request quote</b> on the Home tab, or <b>Profile &gt; New quotation request</b>, to "
               "ask for pricing on a set of products."))
story.append(steps([
    "Enter the <b>Company / customer name</b>, <b>Contact person</b>, <b>Phone</b> and <b>Email</b>. "
    "These four fields are required.",
    "Select one or more demo products and set a quantity for each. At least one product must be "
    "selected; otherwise the app shows <i>Select at least one demo product</i>.",
    "Add optional notes about the project or site.",
    "Tap <b>Submit demo quotation request</b>. A confirmation shows the reference number.",
]))
story.append(P("Submitted requests are listed under <b>Quotation requests</b> (also reached from "
               "<b>Profile</b>), newest first. Each entry shows the reference, the selected products "
               "and the notes. A message on that screen confirms that requests are "
               "<i>stored locally on this device. Nothing was transmitted</i>.", body))

# ---------------- 11. Profile ----------------
story.append(PageBreak())
story += section("11. Profile: individual and business accounts")
story.append(P("The <b>Profile</b> tab holds your demo customer details and shortcuts to your records:"))
story.append(bullets([
    "Orders &amp; history",
    "Equipment register",
    "Quotation requests",
    "New quotation request",
    "Service requests",
]))
story.append(P("11.1 Creating a profile", h2))
story.append(P("Tap <b>Create profile</b> (or <b>Edit demo profile</b> once one exists). Choose the account "
               "type at the top of the form:"))
story.append(table([
    ["Field", "Individual (B2C)", "Business (B2B)"],
    ["Full name", "Required", "Not used (contact person is used)"],
    ["Company name", "Not used", "Required"],
    ["Contact person", "Not used", "Required"],
    ["Phone", "Required", "Required"],
    ["Email", "Required (must contain @)", "Required (must contain @)"],
    ["Business address", "Not used", "Required"],
    ["GSTIN (optional demo field)", "Not used", "Optional"],
], [52 * mm, 60 * mm, 58 * mm]))
story.append(P("Tap <b>Save demo profile</b>. The profile then shows your details, the account type and a "
               "<b>LOCAL DEMO PROFILE</b> badge. Individuals and businesses can use the same app; only the "
               "fields differ.", body))
story.append(P("Your profile is used to fill in the contact snapshot at checkout. Changing the account type "
               "does not delete earlier requests.", small))

# ---------------- 12. Notifications & assistant ----------------
story += section("12. Planned modules")
story.append(P("<b>Notifications</b> (bell icon) and the <b>fire safety assistant</b> (sparkle icon and "
               "the Ask assistant tile) are not yet built. Opening them shows a placeholder screen that "
               "explains they are planned for a later phase. The assistant will use a local rule engine "
               "for safety guidance; it will not give live advice in this build."))

# ---------------- 13. Data & privacy ----------------
story.append(PageBreak())
story += section("13. Your data and limitations")
story.append(bullets([
    "<b>Local only.</b> Profiles, quotations, service requests, registered equipment, orders and cart "
    "contents are kept in the app's memory. Nothing is uploaded to Modi International.",
    "<b>Reset on restart.</b> Closing the app or restarting the phone clears your demo records and "
    "restores the sample data.",
    "<b>No payments.</b> Checkout records a demo order only. No money is charged.",
    "<b>No login.</b> There are no accounts or passwords in this build.",
    "<b>Illustrative content.</b> Prices, product specifications, dates, equipment and service "
    "statuses are samples.",
    "<b>Not for safety decisions.</b> Do not rely on this build for real purchasing, servicing or "
    "compliance decisions. Contact Modi International for real support.",
]))

# ---------------- 14. FAQ ----------------
story += section("14. Troubleshooting and FAQ")
story.append(table([
    ["Question", "Answer"],
    ["My request or profile disappeared.", "Demo records are kept only in memory and are cleared when "
     "the app closes. Create them again while the app is open."],
    ["The Orders list shows records I did not create.", "Two sample orders are included for demonstration."],
    ["Checkout says nothing to check out.", "Add at least one product to the cart first."],
    ["The quotation will not submit.", "Complete the name, contact person, phone and email fields, and "
     "select at least one product."],
    ["The service form asks for a description.", "You chose Not registered / other. Describe the equipment, "
     "or pick a registered asset."],
    ["The catalogue shows Unable to load demo catalogue.", "Close and reopen the app. If it persists, "
     "reinstall the latest APK."],
    ["Can I scan the QR code on an asset?", "No. The QR-style visual is a demonstration and is not scannable."],
    ["Why does the bell or assistant show a placeholder?", "Notifications and the assistant are planned "
     "for later phases."],
    ["The app will not install.", "Allow installs from your browser or file manager in Android settings, "
     "then try again. The app needs Android 5.0 or later."],
], [62 * mm, 108 * mm]))

# ---------------- 15. Glossary ----------------
story.append(PageBreak())
story += section("15. Glossary")
story.append(table([
    ["Term", "Meaning"],
    ["B2C", "Individual customer account."],
    ["B2B", "Business customer account (company name, contact person, business address, optional GSTIN)."],
    ["Asset tag", "Your own identifier for a piece of equipment, for example AST-DEMO-003."],
    ["Demo token", "A simulated code generated for a registered asset. Not a real QR payload."],
    ["Quotation request", "A request for pricing. Stored on this device only in this build."],
    ["Service request", "A request for servicing, refilling or inspection. Stored on this device only."],
    ["Reference", "A demo reference number shown after a request is submitted."],
    ["GSTIN", "Goods and Services Tax Identification Number. Optional, demo field only."],
], [40 * mm, 130 * mm]))

story.append(Spacer(1, 10 * mm))
story.append(P("Modi Fire Safety Customer App is a demonstration build. Product names, prices and "
               "records shown in the app are illustrative and do not represent real offers. "
               "For real purchasing, servicing or support, contact Modi International directly.", small))


def build():
    doc = Doc(OUT, pagesize=A4, leftMargin=20 * mm, rightMargin=20 * mm,
              topMargin=22 * mm, bottomMargin=22 * mm,
              title="Modi Fire Safety Customer App — User Manual",
              author="Modi International", subject="User manual for the demo MVP")
    doc.multiBuild(story)
    print("written", OUT)


if __name__ == "__main__":
    build()
