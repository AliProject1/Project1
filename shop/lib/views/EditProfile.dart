import 'dart:io';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/controllers/authController.dart';
import 'package:shop/controllers/darkModeController.dart';

import '../controllers/userController.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthController authController = Get.put(AuthController());
  ImagePicker _picker = ImagePicker();
  File? selectedImage;  
  final userController _userController = Get.put(userController());
 
  String? emailError;
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


  Future<void> _importImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Future<void> _takeImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  
  @override
  void initState() {
    super.initState();
 
    _loadSharedPreferences();
  }


     
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       foregroundColor: darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),
        backgroundColor:  darkModeController.darkMode.value == false ? Colors.white : Color(0xff15202B),
        title: Text("Edit Profile", style: TextStyle(color:  darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),)),
        centerTitle: true,
      ),
      backgroundColor:  darkModeController.darkMode.value == false ? Colors.white : Color(0xff15202B),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 70),
              Text(
                "Edit Profile",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color:  darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),
                ),
              ),
              SizedBox(height: 100),
              
            
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.77,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        controller: username,
                        style: TextStyle(color:darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),), 
                        cursorColor:  darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),

                        decoration: InputDecoration(
                          fillColor:  darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),

                          labelText: "Username",
                        ),
                        
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.77,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            emailError = null;
                          });
                        },
                        controller: email,
                         style: TextStyle(color:darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),), 
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                        ),
                       
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.77,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        controller: password,
                        obscureText: true,
                         style: TextStyle(color:darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),), 
                        decoration: InputDecoration(
                          labelText: "Password",
                        ),
                       
                      ),
                    ),
                    SizedBox(height: 64),
                    GestureDetector(
                      onTap: (){
                        _userController.updateUser(email.text, password.text, username.text);
                      
                      },
                      child: Card(
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
                          child: Center(
                            child: Text("Save Changes",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                         
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
    }
