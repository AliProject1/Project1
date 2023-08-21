import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/views/Home.dart';
import 'package:shop/views/signin.dart';

import '../api/Api.dart';
import '../models/User.dart';




class AuthController extends GetxController {

  
  RxString registrationResponse = ''.obs;
  RxString loginResponse = ''.obs;
  RxString id =''.obs;
  RxString token =''.obs;
  RxString otp =''.obs;



  
Future<void> registerUser(String email, String password, String username, File imageFile) async {
  final url = Uri.parse('${API().url.toString()}auth/register');

  // Create a multipart request for the image upload
  var request = http.MultipartRequest('POST', url);

  if (imageFile != null) {
    // Attach the image file to the request
    request.files.add(await http.MultipartFile.fromPath('photo', imageFile.path));
  } else {
    print('(null)');
  }

  // Add the fields to the request body
  request.fields['email'] = email;
  request.fields['password'] = password;
  request.fields['username'] = username;


  try {
    final response = await request.send();

    // Handle different response statuses
    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      final decodedData = jsonDecode(data);
      final message = decodedData['id'];
      registrationResponse.value = message.toString();
     Get.to(SignIn());
      print('Registration ID: $message');
   
    } else if (response.statusCode == 400) {
      // Registration failed
      final data = await response.stream.bytesToString();
      final message = jsonDecode(data)['message'];
      registrationResponse.value = message.toString();
     
      print(registrationResponse.value);
    } else {
      // Unexpected error
      registrationResponse.value = '${response.statusCode}';
      print(registrationResponse.value);
    }
  } catch (e) {
    // Exception occurred during registration
    registrationResponse.value = '$e';
  }
}

Future<void> registerUserwithouimage(
    String email, String password, String username)async {
  final url = Uri.parse('${API().url.toString()}auth/register');

  // Create a multipart request for the image upload
  var request = http.MultipartRequest('POST', url);

  // Add the fields to the request body
  request.fields['email'] = email;
  request.fields['password'] = password;
  request.fields['username'] = username;
  

  try {
    final response = await request.send();

    // Handle different response statuses
    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      final decodedData = jsonDecode(data);
      final message = decodedData['id'];

      registrationResponse.value = message.toString();
      Get.to(SignIn());
      print('Registration ID: $message');
    
    } else if (response.statusCode == 400) {
      // Registration failed
      final data = await response.stream.bytesToString();
      final message = jsonDecode(data)['message'];
      registrationResponse.value = message.toString();
      print(registrationResponse.value);
    } else {
      // Unexpected error
      registrationResponse.value = '${response.statusCode}';
      print(registrationResponse.value);
    }
  } catch (e) {
    // Exception occurred during registration
    registrationResponse.value = '$e';
  }
}





  // Method to log in a user
  Future<void> loginUser(String email, String password) async {
    final apiUrl = '${API().url.toString()}auth/login'; // Replace with your API endpoint

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      // Handle different response statuses
      if (response.statusCode == 200) {
        // Login successful
        final data = jsonDecode(response.body);
             
        final idValue = data['id'];
       id.value = idValue;
         
        
          SharedPreferences prefs = await SharedPreferences.getInstance();
       
         await prefs.setString('id', idValue);
          Get.to(HomePage(),
                                  transition: Transition.fadeIn,
                                  duration: Duration(milliseconds: 
                                900));


 
        
     
      } else if (response.statusCode == 400) {
        // Login failed
        final data = jsonDecode(response.body);
        final message = data['message'];
        loginResponse.value = message.toString();
        
      } else {
        // Unexpected error
        loginResponse.value = 'tnekna';
      }
    } catch (e) {
      // Exception occurred during login
      loginResponse.value = '$e';
    }

  }
















}
