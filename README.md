# 🧊 Arctic Fresh - Frozen Food D2C Delivery

A production-grade, highly scalable Flutter mobile application engineered for Direct-to-Consumer (D2C) frozen food delivery. 

Built with an offline-first data layer, a strict cold-chain validation engine, and a premium "Dessert App" visual aesthetic.

## ✨ Features

- **Cold-Chain Logistics Engine**: Custom domain logic that mathematically verifies if a user's chosen delivery slot (and its temperature guarantee) matches the exact thermal requirements of the frozen items in their cart.
- **Offline-First Resilience**: Cart data is instantly written to local `Hive` boxes for a snappy UI, seamlessly syncing with Firebase when the user's connection is restored.
- **Transactional Order Backend**: Uses Cloud Functions and Firestore Transactions to strictly prevent race conditions during inventory reservations and price manipulations.
- **Premium Dribbble-Style UI**: A bespoke, warm coral palette with massive overlapping drop shadows, pill-shaped chips, and large edge-to-edge product photography.
- **Automated CI/CD**: Fully configured GitHub Actions (`flutter_ci.yml`) and Fastlane integration to push builds directly to Apple TestFlight and Google Play Internal Testing.

## 🏗 Architecture (Clean Architecture)

This project strictly adheres to Uncle Bob's Clean Architecture, utilizing a Feature-First folder structure:

```text
lib/
├── app/                  # App-wide config (Router, Theme, DI, Flavors)
├── core/                 # Shared utilities, Errors, Functional constructs (Result/Either)
└── features/             # Feature-first slices
    ├── cart/             
    ├── checkout/         
    ├── delivery/         
    ├── home/             
    ├── orders/           
    └── products/         
        ├── data/         # Models, Hive Local DB, Firestore Remote DB
        ├── domain/       # Entities, ColdChainServices, Repositories
        └── presentation/ # Bloc/Cubit State Management, Screens, Widgets
```

## 🛠 Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (SDK >= 3.3.0)
- **State Management**: `flutter_bloc` / `hydrated_bloc`
- **Routing**: `go_router`
- **Dependency Injection**: `get_it` / `injectable`
- **Local Database**: `hive` / `hive_flutter`
- **Backend**: Firebase (Auth, Firestore, Cloud Functions, App Check, Crashlytics)
- **JSON Serialization**: `freezed` / `json_serializable`

## 🚀 Getting Started

If you have Flutter installed on your machine, getting this project up and running is incredibly fast.

### 1. Initial Setup
Run the included bash script to automatically fetch packages and generate the necessary Freezed / JSON data models:
```bash
./setup_project.sh
```

### 2. Firebase Configuration
You will need to link this project to your own Firebase instance:
```bash
flutterfire configure
```

### 3. Run the App
```bash
flutter run -t lib/main_development.dart
```

## 🧪 Testing

The codebase includes scaffolding for all three layers of the testing pyramid:
- **Unit Tests**: Business logic and Bloc state transitions (`cart_bloc_test.dart`)
- **Domain Tests**: Complex logic matrices (`cold_chain_service_test.dart`)
- **Integration Tests**: End-to-end user flows (`checkout_flow_test.dart`)

Run all tests via:
```bash
flutter test
```
