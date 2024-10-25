import 'package:flutter/material.dart';
import './theme/theme.dart';
import 'auth/authentication.dart';
import 'screens/home.dart';
import 'screens/on_boarding.dart';
import 'screens/sign_up.dart';

void main() {
  runApp(Due());
}

class Due extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Wash App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/onboarding': (context) => OnboardingPage(),
        '/signup': (context) => SignupLoginPage(),
        '/home': (context) => HomePage(),
      },
      home: FutureBuilder<bool>(
        future: _authService.isLoggedIn(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            // If user is logged in, navigate to HomePage, otherwise Onboarding
            if (snapshot.data == true) {
              return HomePage();
            } else {
              return OnboardingPage();
            }
          }
        },
      ),
    );
  }
}