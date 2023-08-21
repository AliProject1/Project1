import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shop/controllers/authController.dart';
import 'package:shop/controllers/productController.dart';
import 'package:shop/models/Product.dart';
import '../api/Api.dart';
import '../models/cart.dart';

class CartController extends GetxController {
  cart? cart1;
  
  ProductController _productController = Get.find<ProductController>();
  AuthController _authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    getUserCart(_authController.id.toString());
    
  }




  Future<void> addToCart(String userId, String productId) async {
    final String apiUrl = '${API().url.toString()}cart'; // Replace with your actual API endpoint

    final Map<String, dynamic> requestData = {
      'userId': userId,
      'productId': productId,
    };

    try {
      final response = await http.post(Uri.parse(apiUrl),
          body: jsonEncode(requestData),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        // Successfully added to cart
        final responseBody = jsonDecode(response.body);
        Get.snackbar('Success', 'Product added to cart',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        print('Product added to cart: $responseBody');
      } else {
        // Error occurred
        Get.snackbar('Error', 'Failed to add product to cart',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        print('Failed to add product to cart. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      // Exception occurred
      Get.snackbar('Error', 'Failed to add product to cart',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      print('Error adding product to cart: $error');
    }
  }

  Future<void> getUserCart(String userId) async {
    final String apiUrl = '${API().url.toString()}cart/find/$userId'; // Replace with your actual API endpoint

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        cart1 = cart.fromJson(responseBody); // Make sure your Cart.fromJson constructor is correctly implemented
      } else {
        print('Failed to get user cart. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error getting user cart: $error');
    }
  }





  Future<void> deleteProductFromCart(String userId, String productId) async {
  final String apiUrl = '${API().url.toString()}cart'; 

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  final Map<String, dynamic> requestBody = {
    'userId': userId,
    'productId': productId,
  };

  try {
    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      Get.showSnackbar(GetBar(
        message: 'Product deleted from cart',
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
      ));
      print('Product deleted from cart');
    } else {
      Get.showSnackbar(GetBar(
        message: 'Failed to delete product from cart',
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      ));
      print('Failed to delete product from cart');
    }
  } catch (error) {
    Get.showSnackbar(GetBar(
      message: 'Error deleting product from cart',
      duration: Duration(seconds: 2),
      backgroundColor: Colors.red,
      snackPosition: SnackPosition.BOTTOM,
    ));
    print('Error deleting product from cart: $error');
  }
}
}
