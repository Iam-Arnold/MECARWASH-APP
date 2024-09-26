import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/authentication.dart'; // Assuming this is your auth service

class SignupLoginPage extends StatefulWidget {
  @override
  _SignupLoginPageState createState() => _SignupLoginPageState();
}

class _SignupLoginPageState extends State<SignupLoginPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _loginPhoneController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();
  final TextEditingController _signupPhoneController = TextEditingController();
  final TextEditingController _signupPasswordController =
      TextEditingController();
  final TextEditingController _signupConfirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();

  int _selectedIndex = 0;
  bool _isLoading = false;

  // Function to validate and format phone number
  String? validatePhoneNumber(String phoneNumber) {
    phoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

    if (phoneNumber.startsWith('255')) {
      phoneNumber = '0' + phoneNumber.substring(3);
    } else if (phoneNumber.startsWith('+255')) {
      phoneNumber = '0' + phoneNumber.substring(4);
    } else if (!phoneNumber.startsWith('0')) {
      return 'Phone number must start with 0, 255, or +255';
    }

    if (phoneNumber.length != 10) {
      return 'Phone number must be exactly 10 digits';
    }

    return null;
  }

  // Function to validate passwords
  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password cannot be empty';
    }
    return null;
  }

  // Function to validate if passwords match
  String? validateConfirmPassword(String? confirmPassword) {
    if (confirmPassword != _signupPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Function to handle login
  Future<void> _handleLogin(BuildContext context) async {
    if (_loginFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading spinner
      });

      try {
        await _authService.login(); // Authenticate user
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        // Handle login failure (e.g., show error message)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed, please try again.')),
        );
      } finally {
        setState(() {
          _isLoading = false; // Hide loading spinner
        });
      }
    }
  }

  // Function to handle registration
  Future<void> _handleRegister(BuildContext context) async {
    if (_signupFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading spinner
      });

      try {
        await _authService
            .login(); // Mock registration, same login logic for now
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        // Handle registration failure (e.g., show error message)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed, please try again.')),
        );
      } finally {
        setState(() {
          _isLoading = false; // Hide loading spinner
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // Blue background header with dynamic content
                  Container(
                    height: screenHeight * 0.4,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/car_washbg.jpg'), // Replace with your background image
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.4), // Blue overlay
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Animated text for dynamic header content
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 500),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                  opacity: animation, child: child);
                            },
                            child: _selectedIndex == 0
                                ? Column(
                                    key: ValueKey<int>(_selectedIndex),
                                    children: [
                                      Text(
                                        'Welcome Back!',
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Login to continue',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white70,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  )
                                : Column(
                                    key: ValueKey<int>(_selectedIndex),
                                    children: [
                                      Text(
                                        'Join Us Today!',
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Register to get started',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white70,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Tabs for switching between Login and Signup
                  TabBar(
                    onTap: _onTabTapped, // Change selected index on tab click
                    labelColor: Colors.lightBlueAccent,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.lightBlueAccent,
                    tabs: [
                      Tab(text: 'Login'),
                      Tab(text: 'Register'),
                    ],
                  ),

                  // Form below the header using TabBarView
                  Expanded(
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(), // Prevent swipe
                      children: [
                        _buildLoginForm(context), // Login Form
                        _buildSignupForm(context), // Signup Form
                      ],
                    ),
                  ),

                  // Show loading spinner while authenticating
                  if (_isLoading)
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Login Form
  Widget _buildLoginForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _loginPhoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.lightBlueAccent,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                return validatePhoneNumber(value ?? '');
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _loginPasswordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.lightBlueAccent,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
              ),
              obscureText: true,
              validator: (value) {
                return validatePassword(value);
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/forgot-password');
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.lightBlueAccent),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _handleLogin(context), // Call login handler
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Login',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Signup Form
  Widget _buildSignupForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _signupFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _signupPhoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.lightBlueAccent,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                return validatePhoneNumber(value ?? '');
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _signupPasswordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.lightBlueAccent,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
              ),
              obscureText: true,
              validator: (value) {
                return validatePassword(value);
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _signupConfirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.lightBlueAccent,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
              ),
              obscureText: true,
              validator: (value) {
                return validateConfirmPassword(value);
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  _handleRegister(context), // Call register handler
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Register',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
