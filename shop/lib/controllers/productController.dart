import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/Product.dart';
import 'package:shop/views/Home.dart';
import 'package:shop/views/profile.dart';

import '../api/Api.dart';

class ProductController extends GetxController {
  Product? productData;
  RxList<Product> products = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();

  }

  Future<void> fetchProducts() async {
    try {
      final List<Product> fetchedProducts = await getAllProducts();
      products.assignAll(fetchedProducts);
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  Future<List<Product>> getAllProducts() async {
    final url = '${API().url.toString()}product';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }



Future<Product> getProductById(String productId) async {
  final String apiUrl = '${API().url.toString()}product/$productId'; // Replace with your actual API endpoint

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> productData = json.decode(response.body);
      return Product.fromJson(productData);
    } else if (response.statusCode == 404) {
      throw Exception('Product not found');
    } else {
      throw Exception('Error fetching product');
    }
  } catch (error) {
    throw Exception('Error: $error');
  }
}



  
Future<void> sellProduct(
  String sellerId,
 String nomProduit,
 String prixProduitAfter,
String prixProduitBefore,
String description,
File imageFile) async {
  final url = Uri.parse('${API().url.toString()}product/addProduct');

  // Create a multipart request for the image upload
  var request = http.MultipartRequest('POST', url);

  if (imageFile != null) {
    // Attach the image file to the request
    request.files.add(await http.MultipartFile.fromPath('photoProduitPrincipale', imageFile.path));
  } else {
    print('(null)');
  }

  // Add the fields to the request body
  request.fields['sellerId'] = sellerId;
  request.fields['nomProduit'] = nomProduit;
  request.fields['prixProduitAfter'] = prixProduitAfter;
   request.fields['prixProduitBefore'] = prixProduitBefore;
    request.fields['description'] = description;


  try {
    final response = await request.send();

    // Handle different response statuses
    if (response.statusCode == 200) {
      // Registration successful
      print('Registration successful');
    } else if (response.statusCode == 400) {
      // Bad request
      print('Bad request');
 
      
    } else {
     
    }
  } catch (e) {
  }
}



Future<void> deleteProductById(String productId) async {
    final String apiUrl = '${API().url.toString()}product/id/$productId'; // Replace with your actual API endpoint

    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Get.snackbar(
        "Success",
        "Product Deleted Successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor:  Colors.green,
        colorText: Colors.white,
      );
       Get.to(HomePage());
        print('Product deleted successfully');
      } else if (response.statusCode == 404) {
        throw Exception('Product not found');
      } else {
        throw Exception('Error deleting product');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }


  Future<void> updateProductById(
    String productId,
    String nomProduit,
    String prixProduitAfter,
    String prixProduitBefore,
    String description,
  ) async {
    final String apiUrl = '${API().url.toString()}product/$productId'; // Replace with your actual API endpoint

    final updatedData = {
      'nomProduit': nomProduit,
      'prixProduitAfter': prixProduitAfter,
      'prixProduitBefore': prixProduitBefore,
      'description': description,
    };

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedData),
      );

      if (response.statusCode == 200) {
        Get.snackbar(
        "Success",
        "Product updated successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor:  Colors.green,
        colorText: Colors.white,
      );
        print('Product updated successfully');
        Get.to(HomePage());
      } else if (response.statusCode == 404) {
       
        throw Exception('Product not found');
      } else {
          Get.snackbar(
        "Error",
        "Error updating product",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor:  Colors.red,
        colorText: Colors.white,
      );
        throw Exception('Error updating product');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }



}
