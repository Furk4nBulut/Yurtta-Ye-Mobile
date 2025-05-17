# yurttaye

KYK Yurt Yemek Takibi Mobil Uygulaması

## Planlanan Proje Yapısı
yurt_menu_app/
├── android/
│   ├── app/
│   │   ├── src/
│   │   │   ├── main/
│   │   │   │   ├── AndroidManifest.xml
│   │   │   │   ├── res/
│   │   │   │   │   ├── drawable/
│   │   │   │   │   └── values/
│   │   │   │   │       └── strings.xml
│   │   │   │   └── kotlin/
│   │   │   │       └── MainActivity.kt
│   │   │   └── build.gradle
│   │   └── build.gradle
├── ios/
│   ├── Runner/
│   │   ├── Info.plist
│   │   ├── Assets.xcassets/
│   │   │   ├── AppIcon.appiconset/
│   │   │   └── LaunchImage.imageset/
│   │   └── Runner.xcodeproj/
│   └── Podfile
├── lib/
│   ├── core/
│   │   ├── config/
│   │   │   ├── app_config.dart
│   │   │   └── theme.dart
│   │   ├── constants/
│   │   │   ├── api_endpoints.dart
│   │   │   └── colors.dart
│   │   ├── extensions/
│   │   │   └── string_extensions.dart
│   │   └── utils/
│   │       └── network_manager.dart
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   └── user.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── auth_repository.dart
│   │   │   │   └── services/
│   │   │   │       └── auth_service.dart
│   │   │   ├── presentation/
│   │   │   │   ├── screens/
│   │   │   │   │   ├── login_screen.dart
│   │   │   │   │   └── register_screen.dart
│   │   │   │   └── viewmodels/
│   │   │   │       └── auth_viewmodel.dart
│   │   └── menu/
│   │       ├── data/
│   │       │   ├── models/
│   │       │   │   └── menu_item.dart
│   │       │   ├── repositories/
│   │       │   │   └── menu_repository.dart
│   │       │   └── services/
│   │       │       └── menu_service.dart
│   │       ├── presentation/
│   │       │   ├── screens/
│   │       │   │   ├── menu_screen.dart
│   │       │   │   └── menu_detail_screen.dart
│   │       │   ├── widgets/
│   │       │   │   ├── menu_card.dart
│   │       │   │   └── category_filter.dart
│   │       │   └── viewmodels/
│   │       │       └── menu_viewmodel.dart
│   ├── l10n/
│   │   ├── app_en.arb
│   │   └── app_tr.arb
│   └── main.dart
├── assets/
│   ├── images/
│   │   ├── logo.png
│   │   └── placeholder.jpg
│   └── fonts/
│       └── Roboto.ttf
├── test/
│   ├── unit/
│   │   ├── menu_service_test.dart
│   │   └── menu_viewmodel_test.dart
│   └── widget/
│       └── menu_screen_test.dart
├── integration_test/
│   └── app_test.dart
├── pubspec.yaml
├── analysis_options.yaml
├── .gitignore
├── README.md
└── LICENSE# Yurtta-Ye-Mobile
