Yurtta Ye - Web and Mobile Application
Overview
Yurtta Ye is a comprehensive platform designed to streamline food ordering and management for dormitory residents. The system consists of two main components:

Yurtta-Ye-MVC-Web: A web application built with ASP.NET Core MVC, providing a robust backend and user interface for managing food orders, menus, and user accounts.
Yurtta-Ye-Mobile: A mobile application developed using Flutter, offering a user-friendly interface for residents to browse menus, place orders, and track their orders on the go.

Both applications work together to provide a seamless experience for users, enabling efficient food ordering and management within dormitory settings.
Features
Yurtta-Ye-MVC-Web

User Management: Register, login, and manage user profiles (admin and resident roles).
Menu Management: Admins can create, update, and delete daily or weekly menus.
Order Processing: Residents can view available menus, place orders, and track order status.
Responsive Design: Built with Bootstrap for a consistent experience across devices.
Database Integration: Utilizes Entity Framework Core with SQL Server for data persistence.

Yurtta-Ye-Mobile

Cross-Platform Support: Runs on both iOS and Android using Flutter.
Menu Browsing: View daily/weekly menus with detailed food descriptions.
Order Placement: Place orders directly from the mobile app with real-time updates.
Push Notifications: Receive updates on order status and menu changes.
Firestore Integration: Stores order and user data using Google Firestore for scalability.
OpenWeatherMap API: Displays local weather information for a personalized user experience.

Technologies Used
Web Application

Backend: ASP.NET Core MVC
Frontend: HTML, CSS, Bootstrap
Database: SQL Server with Entity Framework Core
Authentication: ASP.NET Identity
Hosting: Configurable for IIS or cloud platforms like Azure

Mobile Application

Framework: Flutter (Dart)
Database: Google Firestore
API: OpenWeatherMap API for weather data
State Management: Provider or Riverpod (based on project setup)
Platforms: iOS, Android

Installation and Setup
Prerequisites

Web:
.NET SDK 6.0 or later
SQL Server (Express or full version)
Visual Studio 2022 or later (recommended)


Mobile:
Flutter SDK (latest stable version)
Android Studio or Xcode for emulator/simulator
Google Cloud account for Firestore setup
OpenWeatherMap API key



Web Application Setup

Clone the Repository:git clone https://github.com/bulutsoft-dev/Yurtta-Ye-MVC-Web.git
cd Yurtta-Ye-MVC-Web


Configure Database:
Update the connection string in appsettings.json to point to your SQL Server instance.
Run migrations:dotnet ef database update




Run the Application:dotnet run


Access the web app at http://localhost:5000 (or the configured port).

Mobile Application Setup

Clone the Repository:git clone https://github.com/Furk4nBulut/Yurtta-Ye-Mobile.git
cd Yurtta-Ye-Mobile


Install Dependencies:flutter pub get


Configure Firestore:
Set up a Firestore project in the Google Cloud Console.
Add the google-services.json (Android) or GoogleService-Info.plist (iOS) to the respective project directories.


Configure OpenWeatherMap API:
Obtain an API key from OpenWeatherMap.
Add the API key to the app configuration (e.g., in a .env file or constants file).


Run the Application:flutter run


Test on an emulator, simulator, or physical device.

Usage

Web: Admins can log in to manage menus and orders, while residents can browse menus, place orders, and view order history.
Mobile: Residents can use the app to check menus, place orders, and receive real-time updates on order status and weather conditions.

Contributing
Contributions are welcome! Please follow these steps:

Fork the repository (web or mobile).
Create a new branch (git checkout -b feature/your-feature).
Commit your changes (git commit -m "Add your feature").
Push to the branch (git push origin feature/your-feature).
Open a pull request.

License
This project is licensed under the MIT License. See the LICENSE file in each repository for details.
Contact
For questions or feedback, reach out to the project maintainers:

Web: bulutsoft-dev
Mobile: Furk4nBulut

