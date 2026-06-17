# 🩺 CareSync (MediBook) – Doctor Appointment Booking App

CareSync is a modern, full-stack **doctor appointment booking application** built using **Flutter** and **Supabase**. It provides a seamless experience for patients to discover doctors, book appointments, and manage their health schedules, while giving doctors a powerful dashboard to manage their availability and patients.

---

## 🚀 Features

### 👤 Patient Features

* User authentication (Login / Register via Supabase Auth)
* Browse and search doctors by specialty or name
* View doctor profiles, consultation fees, and ratings
* Check real-time availability slots
* Book appointments easily
* View upcoming and past appointments
* Manage personal profile

### 🧑‍⚕️ Doctor Features

* Dedicated doctor dashboard
* Manage availability schedule
* Accept / reject appointment requests
* View patient details
* Track appointments history
* Update profile and consultation fee

---

## 🛠️ Tech Stack

* **Frontend:** Flutter (Dart)
* **Backend:** Supabase (Auth, Database, Storage)
* **State Management:** BLoC (`flutter_bloc` & `bloc`)
* **Routing:** `go_router`
* **Local Storage:** `hive` & `hive_flutter`
* **Payment Gateway:** Stripe (`flutter_stripe`)
* **UI/UX Enhancements:**
  * Google Fonts
  * Lottie Animations
  * Shimmer Effects (via `skeletonizer`)
  * Cached Network Images (`cached_network_image`)
  * Device-agnostic design (`flutter_screenutil`)

---

## 📱 App Flow Overview

### Patient Flow

Splash ➔ Onboarding ➔ Authentication ➔ Home ➔ Search Doctor ➔ Doctor Details ➔ Book Appointment ➔ Payment (Stripe) ➔ Confirmation ➔ My Appointments

### Doctor Flow

Login ➔ Dashboard ➔ Manage Appointments ➔ Schedule Management ➔ Profile Settings

---

## 🗄️ Database Structure (Supabase)

### Profiles

* `id` (UUID, Primary Key)
* `name` (text)
* `email` (text)
* `role` (role_type: patient/doctor)
* `photo_url` (text)
* `phone` (text)
* `created_at` (timestamptz)

### Doctors

* `id` (UUID, Primary Key)
* `profile_id` (UUID, Foreign Key to Profiles)
* `specialization` (text)
* `experience` (int)
* `fee` (numeric)
* `about` (text)
* `rating` (numeric)

### Appointments

* `id` (UUID, Primary Key)
* `patient_id` (UUID, Foreign Key to Profiles)
* `doctor_id` (UUID, Foreign Key to Doctors)
* `date` (date)
* `time` (time)
* `status` (status_type: pending/confirmed/cancelled)
* `created_at` (timestamptz)

### Availability

* `id` (UUID, Primary Key)
* `doctor_id` (UUID, Foreign Key to Doctors)
* `date` (date)
* `start_time` (time)
* `end_time` (time)
* `is_booked` (boolean)

### Reviews

* `id` (UUID, Primary Key)
* `patient_id` (UUID, Foreign Key to Profiles)
* `doctor_id` (UUID, Foreign Key to Doctors)
* `rating` (int)
* `comment` (text)

---

## 🎯 Project Goals

This project is designed as a **portfolio-level application** to demonstrate:

* Clean Flutter architecture
* Real-world backend integration (Supabase)
* Role-based system (Patient & Doctor)
* Production-ready UI/UX design
* Scalable app structure

---

## 📦 Key Packages Used

* **`supabase_flutter`** – Backend integration (Authentication & Database)
* **`flutter_bloc`** – Scalable state management
* **`go_router`** – Declarative navigation and routing
* **`hive_flutter`** – High performance local storage
* **`flutter_stripe`** – Native Stripe payment processing
* **`dio`** & **`http`** – Advanced and lightweight HTTP client support
* **`flutter_screenutil`** – Responsive screen size adaptation
* **`cached_network_image`** – Network image caching
* **`skeletonizer`** – Modern shimmer/skeleton loading effects
* **`lottie`** – Rich vector animations
* **`image_picker`** – Image capturing and upload support
* **`build_runner`** (Dev Dependency) – Local assets and adapter code generation

---

## 🧠 Architecture

The project follows a modular and scalable structure:

```
lib/
 ├── core/
 │    ├── theme/          # App design tokens and theme settings
 │    ├── routing/        # GoRouter navigation setup
 │    ├── errors/         # Error handling classes
 │    └── utils/          # Core helper functions and extensions
 ├── features/
 │    ├── auth/           # Login, registration, and onboarding features
 │    ├── patient/        # Patient-specific views (Home, Doctor Search)
 │    ├── doctor/         # Doctor-specific views (Dashboard, Availability)
 │    └── appointments/   # Booking flows and appointment management
 ├── services/            # Remote and local database services
 ├── models/              # Global data models
 └── shared/              # Shared widgets (buttons, input fields)
```

---

## 🎨 UI Design

* Clean and modern medical aesthetic
* Soft blue primary theme
* Rounded cards and buttons
* Minimal and trustworthy interface
* Mobile-first responsive design

---

## 📸 Screens (Planned / Included)

* Splash Screen
* Onboarding Screens
* Login / Register
* Patient Home
* Doctor Search
* Doctor Profile
* Appointment Booking Flow
* Payment Integration (Stripe checkout)
* Confirmation Screen
* Patient Appointments
* Doctor Dashboard

---

## 🛠️ Getting Started & Commands

To manage code generation and cleanup, VS Code tasks are configured under `.vscode/tasks.json`. You can easily execute the following helper actions:

- **Run code generation**: `fvm flutter pub run build_runner build --delete-conflicting-outputs`
- **Watch changes**: `fvm flutter pub run build_runner watch --delete-conflicting-outputs`
- **Clean and reinstall packages**: `fvm flutter clean && fvm flutter pub get`

---

## 📄 License

This project is open-source and available under the MIT License.

---

## ⭐ Show Your Support

If you like this project, feel free to give it a ⭐ on GitHub!
