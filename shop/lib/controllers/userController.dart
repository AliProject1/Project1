import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../api/Api.dart';
import '../models/User.dart';
import '../views/Home.dart';
import 'authController.dart';




class userController extends GetxController {
final AuthController _authController = Get.put(AuthController());

User? userData;



Future<void> getUser(String id) async {
    final url = '${API().url.toString()}user/id/$id';
    final headers = {
      'Content-Type': 'application/json', };

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      userData = User.fromJson(data);
     
      if (userData != null) {
        print(userData!.email.toString());
      } else {
        
        throw Exception('User data is null');
      }
    } else {
      
      throw Exception('Failed to load user data');
    }
  }

  







Future<void> updateUser(String email,String password,String name) async {
  final url = Uri.parse('${API().url.toString()}user/${_authController.id.value}');
 
if (password == "") {
    password = userData!.password.toString();
   
  }
  if (name == "") {
    name = userData!.username.toString();
  }
  if (email == "") {
    email = userData!.email.toString();
  }

  try {
    // Make the HTTP PUT request
    final response = await http.put(
      url, // Use the 'url' variable directly here
      headers: {
        'Content-Type': 'application/json', // Set the content-type header to JSON
      },
      body: jsonEncode({
          'email': email,
          'password': password,
          'username': name,
        }),
    );

    if (response.statusCode == 200) {
      // User updated successfully
      final updatedUser = json.decode(response.body);
     
      print(updatedUser);
      Get.to(HomePage());
    } else {
      // Handle API error
      print('Failed to update user. Status code: ${response.statusCode}');
    }
  } catch (e) {
    // Handle network or other errors
    print('Error while updating user: $e');
  }
}






}
