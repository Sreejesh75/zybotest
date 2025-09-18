🛍️ zybo E-Commerce App

A modern Flutter E-Commerce mobile application built with clean architecture, state management, and real APIs.
This project demonstrates how to implement OTP login, profile management, wishlist, product catalog, banners, and much more — all powered by Flutter.

✨ Features

✅ Authentication – OTP-based login & secure JWT token storage
✅ Products – Browse products with responsive UI
✅ Wishlist – Add/remove products using API integration
✅ Profile – View and update user profile details
✅ Search – Find products easily
✅ Banner – Display promotional banners dynamically
✅ Logout – Securely clear user session
✅ State Management – BLoC pattern for scalable architecture

	
	
🛠️ Tech Stack

Flutter (Dart)

BLoC  for state management

http package for API calls

SharedPreferences for local storage

REST APIs (secured with JWT tokens)

🚀 Getting Started
1️⃣ Clone the repository
git clone https://github.com/Sreejesh75/your-repo.git
cd your-repo

2️⃣ Install dependencies
flutter pub get

3️⃣ Run the app
flutter run

🔑 Environment Setup

Make sure to update your API Base URL and keys inside your service files if needed:

const String baseUrl = "https://skilltestflutter.zybotechlab.com/api/";

🧑‍💻 Project Structure
lib/
│── data/                # API services & models  
│── presentation/        # UI Screens & Widgets  
│── bloc/                # State management (BLoC)  
│── utils/               # Helpers, constants  
│── main.dart            # Entry point  

🤝 Contributing

Contributions are always welcome! 🎉
If you’d like to improve the app, feel free to fork the repo and create a PR.

📜 License

This project is licensed under the MIT License – feel free to use it for learning or building your own apps.

🔥 Built with ❤️ using Flutter
