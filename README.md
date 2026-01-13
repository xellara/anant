# Anant

<p align="center">
  <b>A Scalable, Multi-Vertical Application built with Flutter & Serverpod.</b><br>
  Bike Selling • Hotel Booking • Food Delivery • ...and more.
</p>

---

## 🏗 Architecture

The app is structured to support **dynamic services**, ensuring that different business verticals can coexist and scale independently. We utilize the **BLoC** pattern to strictly separate business logic from the UI, resulting in a modular, testable, and maintainable codebase.

---

## 📂 Project Structure

<details>
<summary><b>Click to expand file tree</b></summary>

```plaintext
lib/
├── blocs/                              # Business Logic Components
│   ├── auth/                           # Authentication (Login, Register)
│   ├── global/                         # Global App State
│   └── services/                       # Vertical-Specific Logic
│       ├── bike/                       # Bike Selling
│       ├── hotel/                      # Hotel Booking
│       └── food_delivery/              # Food Delivery
├── models/                             # Data Models
├── screens/                            # UI Screens
│   ├── auth/                           # Auth Pages
│   ├── home/                           # Home & Service Selection
│   └── services/                       # Vertical-Specific Screens
├── widgets/                            # Reusable UI Components
├── services/                           # External Services (API, Storage)
├── utils/                              # Helpers & Constants
├── main.dart                           # App Entry Point
└── routes.dart                         # Navigation Config
```
</details>

---

## 🚀 Build & Deployment Guide

### 🛠 Development (Running Locally)

| Component | Description | Command |
| :--- | :--- | :--- |
| **Server** | Starts the Serverpod backend. Ensure Docker/Neon is configured. | `cd anant_server`<br>`dart bin/main.dart` |
| **Client** | Runs the Flutter app in **Debug Mode** (points to Dev env). | `cd anant_flutter`<br>`flutter run -t lib/main_dev.dart` |

### 📦 Production (Running Locally)

To simulate the production environment on your local machine:

```bash
cd anant_flutter
flutter run --release -t lib/main_prod.dart
```

### 📱 Generating Build Artifacts

Navigate to `anant_flutter` and run the following commands to generate release builds:

| Artifact | Environment | Command |
| :--- | :--- | :--- |
| **APK** | **Development** | `flutter build apk --release -t lib/main_dev.dart` |
| **APK** | **Production** | `flutter build apk --release -t lib/main_prod.dart` |
| **AppBundle** | **Development** | `flutter build appbundle --release -t lib/main_dev.dart` |
| **AppBundle** | **Production** | `flutter build appbundle --release -t lib/main_prod.dart` |

---

## ☁️ Cloud Deployment (GCP)

We use Google Cloud Run for a serverless, scalable deployment.

### Server Deployment

| Environment | Project | Command |
| :--- | :--- | :--- |
| **Development** | `anant-dev-484011` | `cd anant_server`<br>`./deploy/gcp/console_gcr/cloud-run-deploy-dev.sh` |
| **Production** | `anant-prod` | `cd anant_server`<br>`./deploy/gcp/console_gcr/cloud-run-deploy-prod.sh` |

> **Note:** The production deployment uses **Neon DB** for the database layer.

### Web App Deployment

| Environment | Project | Command |
| :--- | :--- | :--- |
| **Development** | `anant-dev-484011` | `cd anant_flutter`<br>`./deploy/deploy_web_dev.sh` |
| **Production** | `anant-prod` | `anant-prod` | `cd anant_flutter`<br>`./deploy/deploy_web_prod.sh` |
