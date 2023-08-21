import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/controllers/authController.dart';
import 'package:shop/controllers/darkModeController.dart';
import 'package:shop/views/Home.dart';
import 'package:shop/views/signup.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthController authController = Get.put(AuthController());
  String? emailError;
  String? passwordError;
  bool isLoading = false;
   late SharedPreferences prefs;
  DarkModeController darkModeController = Get.put(DarkModeController());
   // Function to load shared preferences and set dark mode value
  void _loadSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      darkModeController.changeDarkMode(prefs.getBool('darkMode') ?? false);
    });

  }

  @override
  void initState() {
    super.initState();
   
    _loadSharedPreferences();
  }
  
  Future<void> _handelSignIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
        emailError = ""; 
      });

      // Call the sign-in method
      await authController.loginUser(email.text, password.text);

     if (authController.loginResponse == "Invalid email") {
      
        setState(() {
          emailError = "Email does not exist";
          isLoading = false;
        });
      
      } 
      else if (authController.loginResponse == "Wrong password") {
        
        setState(() {
          passwordError = "Incorrect password";
          isLoading = false;
        });
      }
      else {
        // Registration success, navigate to another screen
        setState(() {
          emailError = ""; // Reset emailError for future sign-up attempts
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: darkModeController.darkMode.value == false ? 
        const  LinearGradient(
            colors: [
              Color(0xffADC4CE),
             Color(0xff5db1df),
            ],
             begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
          ):
          LinearGradient(
            colors: [
            Color(0xff7B68EE).withOpacity(0.8),
              Color.fromARGB(255, 1, 2, 2),
            ],
             begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
          )

        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 70),
              ClipOval(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.43,
                  width: MediaQuery.of(context).size.width * 0.77,
                  
                  child: ClipOval(
                    child: Image.asset(
                      "lib/images/3843753-removebg-preview.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                alignment: Alignment.center,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.77,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          onChanged: (value) {
                            setState(() {
                              emailError = null;
                              passwordError = null;
                            });
      
                          },
                          controller: email,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                           
                            labelStyle: TextStyle(color: Colors.white),
                            labelText: "Email",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email cannot be empty';
                            }
                            if(emailError != null) {
                              return emailError;
                            }
                            if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-z]+$").hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.77,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: TextFormField(
                          style :TextStyle(color: Colors.white),
                          controller: password,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: Colors.white),
                            fillColor: Colors.white,
                            labelText: "Password",
                          ),
                          onChanged: (value) {
                            setState(() {
                              passwordError = null;
                              emailError = null;
                            });
      
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password cannot be empty';
                            }
                            if(passwordError != null) {
                              return passwordError;
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 24),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.77,
                        child: Row(
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colors.white
                              ),
                            ),
                            SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                Get.to(Signup(),
                                    transition: Transition.downToUp,
                                    duration: Duration(milliseconds: 500));
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 15,
                                  color:  Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Card(
                        elevation: 25,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.07,
                          width: MediaQuery.of(context).size.width * 0.6,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                               Color(0xffEEE0C9),
                               Color.fromARGB(255, 211, 178, 124).withOpacity(0.7),
                              ],
                              begin: Alignment.topLeft,
                               end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                            child: isLoading ? CircularProgressIndicator(color: Colors.blue,) :
                             Text(
                              "Sign In",
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: isLoading ? null : _handelSignIn,
                              
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
