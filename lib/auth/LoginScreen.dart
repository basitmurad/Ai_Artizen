// import 'package:artizen/home/DashboardScreen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import '../home/AIArtizenDashboard.dart';
// import '../widgets/text_field_widget.dart';
//
// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _isPasswordVisible = false;
//   bool _isLoading = false;
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   void _playButtonSound() {
//     // TODO: Implement button click sound
//     print('Button click sound played');
//   }
//
//   Future<void> _login() async {
//     if (_formKey.currentState!.validate()) {
//       _playButtonSound();
//       setState(() {
//         _isLoading = true;
//       });
//
//       try {
//         final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: _emailController.text.trim(),
//           password: _passwordController.text.trim(),
//         );
//
//         // Navigate to AIArtizenDashboard on successful login
//         Navigator.pushReplacement(
//           context,
//           PageRouteBuilder(
//             pageBuilder: (context, animation, secondaryAnimation) => AIArtizenDashboard(),
//             transitionsBuilder: (context, animation, secondaryAnimation, child) {
//               return SlideTransition(
//                 position: Tween<Offset>(
//                   begin: const Offset(1.0, 0.0),
//                   end: Offset.zero,
//                 ).animate(CurvedAnimation(
//                   parent: animation,
//                   curve: Curves.easeInOut,
//                 )),
//                 child: child,
//               );
//             },
//             transitionDuration: Duration(milliseconds: 500),
//           ),
//         );
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: [
//                 Icon(Icons.check_circle, color: Colors.white),
//                 SizedBox(width: 8),
//                 Text('Login successful! Welcome to AI Artizen'),
//               ],
//             ),
//             backgroundColor: Colors.green,
//             duration: Duration(seconds: 2),
//           ),
//         );
//       } on FirebaseAuthException catch (e) {
//         String errorMsg;
//         if (e.code == 'user-not-found') {
//           errorMsg = 'No user found for that email.';
//         } else if (e.code == 'wrong-password') {
//           errorMsg = 'Wrong password provided.';
//         } else {
//           errorMsg = 'Login failed. ${e.message}';
//         }
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: [
//                 Icon(Icons.error_outline, color: Colors.white),
//                 SizedBox(width: 8),
//                 Text(errorMsg),
//               ],
//             ),
//             backgroundColor: Colors.red,
//             duration: Duration(seconds: 3),
//           ),
//         );
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }
//
//   // Future<void> _login() async {
//   //   if (_formKey.currentState!.validate()) {
//   //     _playButtonSound();
//   //     setState(() {
//   //       _isLoading = true;
//   //     });
//   //
//   //     // Simulate login process
//   //     await Future.delayed(Duration(seconds: 2));
//   //
//   //     setState(() {
//   //       _isLoading = false;
//   //     });
//   //
//   //     // Navigate to Dashboard after successful login
//   //     Navigator.pushReplacement(
//   //       context,
//   //       PageRouteBuilder(
//   //         pageBuilder: (context, animation, secondaryAnimation) => AIArtizenDashboard(),
//   //         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//   //           // Slide transition from right to left
//   //           return SlideTransition(
//   //             position: Tween<Offset>(
//   //               begin: const Offset(1.0, 0.0),
//   //               end: Offset.zero,
//   //             ).animate(CurvedAnimation(
//   //               parent: animation,
//   //               curve: Curves.easeInOut,
//   //             )),
//   //             child: child,
//   //           );
//   //         },
//   //         transitionDuration: Duration(milliseconds: 500),
//   //       ),
//   //     );
//   //
//   //     // Show success message
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(
//   //         content: Row(
//   //           children: [
//   //             Icon(Icons.check_circle, color: Colors.white),
//   //             SizedBox(width: 8),
//   //             Text('Login successful! Welcome to AI Artizen'),
//   //           ],
//   //         ),
//   //         backgroundColor: Colors.green,
//   //         duration: Duration(seconds: 2),
//   //       ),
//   //     );
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(20),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             SizedBox(height: 20),
//
//             TextFieldWidget(
//               hintText: 'Email',
//               prefixIcon: Icons.email_outlined,
//               textEditingController: _emailController,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your email';
//                 }
//                 if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//                   return 'Please enter a valid email';
//                 }
//                 return null;
//               },
//             ),
//
//             SizedBox(height: 20),
//
//             TextFieldWidget(
//               hintText: 'Password',
//               prefixIcon: Icons.lock_outline,
//               suffixIcon: IconButton(
//                 icon: Icon(
//                   _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
//                   color: Colors.grey[600],
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     _isPasswordVisible = !_isPasswordVisible;
//                   });
//                 },
//               ),
//               textEditingController: _passwordController,
//               obscureText: !_isPasswordVisible, // Add this line
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your password';
//                 }
//                 if (value.length < 6) {
//                   return 'Password must be at least 6 characters';
//                 }
//                 return null;
//               },
//             ),
//
//             SizedBox(height: 12),
//
//             // Forgot Password
//             Align(
//               alignment: Alignment.centerRight,
//               child: TextButton(
//                 onPressed: () {
//                   _playButtonSound();
//                   // TODO: Implement forgot password
//                 },
//                 child: Text(
//                   'Forgot Password?',
//                   style: TextStyle(
//                     color: Color(0xFF667eea),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ),
//
//             SizedBox(height: 20),
//
//             // Login Button
//             SizedBox(
//               height: 56,
//               child: ElevatedButton(
//                 onPressed: _isLoading ? null : _login,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFF667eea),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   elevation: 3,
//                 ),
//                 child: _isLoading
//                     ? CircularProgressIndicator(color: Colors.white)
//                     : Text(
//                   'Login',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//
//             SizedBox(height: 30),
//
//             // Demo Login Button (for testing purposes)
//             Container(
//               height: 48,
//               child: OutlinedButton(
//                 onPressed: _isLoading
//                     ? null
//                     : () {
//                   // Quick demo login without validation
//                   _playButtonSound();
//                   Navigator.pushReplacement(
//                     context,
//                     PageRouteBuilder(
//                       pageBuilder: (context, animation, secondaryAnimation) => Dashboardscreen(),
//                       transitionsBuilder: (context, animation, secondaryAnimation, child) {
//                         return FadeTransition(
//                           opacity: animation,
//                           child: ScaleTransition(
//                             scale: Tween<double>(begin: 0.8, end: 1.0).animate(
//                               CurvedAnimation(parent: animation, curve: Curves.easeOut),
//                             ),
//                             child: child,
//                           ),
//                         );
//                       },
//                       transitionDuration: Duration(milliseconds: 400),
//                     ),
//                   );
//                 },
//                 style: OutlinedButton.styleFrom(
//                   side: BorderSide(color: Color(0xFF667eea), width: 2),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                 ),
//                 child: Text(
//                   'Demo Login (Skip Validation)',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF667eea),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../home/AIArtizenDashboard.dart';
import '../widgets/text_field_widget.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _firebaseInitialized = false;

  // Firebase instances
  FirebaseAuth? _auth;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    try {
      // Ensure Firebase is initialized
      await Firebase.initializeApp();

      // Initialize Firebase Auth
      _auth = FirebaseAuth.instance;

      setState(() {
        _firebaseInitialized = true;
      });

      print('Firebase initialized successfully for login');
    } catch (e) {
      print('Error initializing Firebase: $e');

      // Show error to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8),
                Text('Failed to initialize Firebase. Please restart the app.'),
              ],
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _playButtonSound() {
    // TODO: Implement button click sound
    print('Button click sound played');
  }

  Future<void> _login() async {
    if (!_firebaseInitialized || _auth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning, color: Colors.white),
              SizedBox(width: 8),
              Text('Firebase is not ready. Please wait and try again.'),
            ],
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      _playButtonSound();
      setState(() {
        _isLoading = true;
      });

      try {
        print('Attempting to login with email: ${_emailController.text.trim()}');

        final UserCredential userCredential = await _auth!.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        print('Login successful for user: ${userCredential.user?.uid}');

        // Navigate to AIArtizenDashboard on successful login
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => AIArtizenDashboard(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                )),
                child: child,
              );
            },
            transitionDuration: Duration(milliseconds: 500),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Login successful! Welcome to AI Artizen'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } on FirebaseAuthException catch (e) {
        print('FirebaseAuthException: ${e.code} - ${e.message}');

        String errorMsg = _getFirebaseErrorMessage(e.code);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text(errorMsg)),
              ],
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
          ),
        );
      } catch (e) {
        print('General login error: $e');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8),
                Text('An unexpected error occurred. Please try again.'),
              ],
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getFirebaseErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No account found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'invalid-credential':
        return 'Invalid email or password. Please check your credentials.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      default:
        return 'Login failed. Please try again.';
    }
  }

  Future<void> _resetPassword() async {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.info, color: Colors.white),
              SizedBox(width: 8),
              Text('Please enter your email address first.'),
            ],
          ),
          backgroundColor: Colors.blue,
        ),
      );
      return;
    }

    try {
      await _auth!.sendPasswordResetEmail(email: _emailController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Expanded(child: Text('Password reset email sent to ${_emailController.text.trim()}')),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 4),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMsg = e.code == 'user-not-found'
          ? 'No account found with this email address.'
          : 'Failed to send reset email. Please try again.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Text(errorMsg),
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while Firebase is initializing
    if (!_firebaseInitialized) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF667eea)),
            SizedBox(height: 16),
            Text(
              'Initializing Firebase...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),

            TextFieldWidget(
              hintText: 'Email',
              prefixIcon: Icons.email_outlined,
              textEditingController: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),

            SizedBox(height: 20),

            TextFieldWidget(
              hintText: 'Password',
              prefixIcon: Icons.lock_outline,
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey[600],
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              textEditingController: _passwordController,
              obscureText: !_isPasswordVisible,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),

            SizedBox(height: 12),

            // Forgot Password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _firebaseInitialized ? () {
                  _playButtonSound();
                  _resetPassword();
                } : null,
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: _firebaseInitialized ? Color(0xFF667eea) : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Login Button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: (_isLoading || !_firebaseInitialized) ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF667eea),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 3,
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            SizedBox(height: 30),

            // Demo Login Button (for testing purposes)
            Container(
              height: 48,
              child: OutlinedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                  // Quick demo login without validation
                  _playButtonSound();
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => AIArtizenDashboard(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                              CurvedAnimation(parent: animation, curve: Curves.easeOut),
                            ),
                            child: child,
                          ),
                        );
                      },
                      transitionDuration: Duration(milliseconds: 400),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color(0xFF667eea), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'Demo Login (Skip Validation)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF667eea),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Debug info (remove in production)
            if (!_firebaseInitialized)
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Firebase is initializing... Please wait.',
                        style: TextStyle(
                          color: Colors.orange[800],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
