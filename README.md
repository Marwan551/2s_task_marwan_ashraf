# Odoo Sales

A Flutter mobile client for Odoo sales teams. It supports secure sign-in, customer lookup and phone updates, offline customer caching with queued phone edits, and Sales Orders for internal users.

## Requirements

- Flutter stable with Dart `^3.13.5`
- An Odoo database and an account with access to Contacts
- The Sales app installed for Sales Orders
- A network-accessible Odoo URL; use HTTPS outside local development

The app uses Odoo's native JSON-RPC endpoint (`/jsonrpc`). A separately installed REST module is not required. Odoo versions, hosting configuration, and access policies vary; verify API availability with your administrator. This client does not currently implement XML-RPC or Odoo 19's JSON-2 API.

## Run

```sh
flutter pub get
flutter run
```

At sign-in, enter the Odoo base URL (for example, `https://company.odoo.com`), database name, username, and password. These are instance-specific: **there are no bundled or default credentials**. Ask your Odoo administrator for a test account. The app verifies the credentials and the user's `base.group_user` membership before saving the session. Credentials are stored using platform secure storage; prefer HTTPS so credentials are also protected in transit.

## Features

- Customer list: `res.partner` records with `customer_rank > 0`, name search, and pagination.
- Customer details: contact and address information; phone changes are written to Odoo.
- Offline support: previously loaded customers are cached locally. Phone changes made offline are queued and retried when connectivity returns; pending edits are marked in the UI.
- Sales Orders: internal users can browse orders, review order lines and totals, and confirm quotations. Odoo access rights remain authoritative for each operation.

## Build

```sh
flutter analyze
flutter test
flutter build apk --release
```

The APK is written to `build/app/outputs/flutter-apk/app-release.apk`. Release signing must be configured for your organization's distribution process before publishing.

## Notes and limitations

- Offline access is for customer records previously fetched while online. The initial login and all Sales Order operations require a working connection.
- Offline phone edits require a cached customer. The server remains the source of truth; sign-out is blocked until queued edits sync, and the local customer cache is cleared on sign-out.
- Customer cache and pending edits are stored locally. Do not use a shared device without the device's normal OS-level access controls.
- No Odoo URL, database, or test credentials are embedded in the source. No live Odoo instance was available for end-to-end verification.
