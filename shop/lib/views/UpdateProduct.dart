import 'dart:io';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/controllers/authController.dart';
import 'package:shop/controllers/darkModeController.dart';
import 'package:shop/controllers/productController.dart';

import '../models/Product.dart';



class UpdateProduct extends StatefulWidget {
  @override
  _UpdateProductState createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
   TextEditingController ProductPriceBeforDiscount = TextEditingController();
  TextEditingController ProductPriceNow = TextEditingController();
  TextEditingController ProductName = TextEditingController();
  TextEditingController ProductDiscrption = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthController authController = Get.put(AuthController());
  ProductController _productController = Get.put(ProductController());
  ImagePicker _picker = ImagePicker();
  File? selectedImage;
   late SharedPreferences prefs;
  DarkModeController darkModeController = Get.put(DarkModeController());
   // Function to load shared preferences and set dark mode value
  void _loadSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      darkModeController.changeDarkMode(prefs.getBool('darkMode') ?? false);
    });
  }
 

  bool isLoading = false;



 void _handleUpdateProduct(Product x) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      // Determine if a text field is empty or null
      final updatedProductName = ProductName.text.isEmpty ? x.nomProduit : ProductName.text;
      final updatedProductPriceBeforDiscount =
          ProductPriceBeforDiscount.text.isEmpty ? x.prixProduitBefore ?? '0' : ProductPriceBeforDiscount.text;
      final updatedProductPriceNow = ProductPriceNow.text.isEmpty ? x.prixProduitAfter : ProductPriceNow.text;
      final updatedProductDescription = ProductDiscrption.text.isEmpty ? x.description : ProductDiscrption.text;

      await _productController.updateProductById(
        x.sId.toString(),
        updatedProductName.toString(),
        updatedProductPriceNow.toString(),
        updatedProductPriceBeforDiscount.toString(),
        updatedProductDescription.toString(),
      );

      setState(() {
        isLoading = false;
      });
    }
  }

   var data=Get.arguments;

  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkModeController.darkMode.value == false ? Colors.white : Color(0xff15202B),
        foregroundColor: darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      backgroundColor: darkModeController.darkMode.value == false ? Colors.white : Color(0xff15202B),
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            Text(
              "Update Product",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),
              ),
            ),
            SizedBox(height: 20),
             Center(
  child: InkWell(
    onTap: () {
     showDialog(
  context: context,
  builder: (BuildContext context) {
    return Center(
      child: ClipOval(
        child: Image.network(
          data[0].photoProduitPrincipale.toString(),
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width*0.9, 
          height: MediaQuery.of(context).size.width*0.9, 
        ),
      ),
    );
  },
);

    },
    child: ClipOval(
      child: Image.network(
        data[0].photoProduitPrincipale.toString(),
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width*0.5, 
        height:MediaQuery.of(context).size.width*0.5, 
      ),
    ),
  ),
),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.77,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        controller: ProductName,
                        style: TextStyle(color:darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),), 
                        decoration: InputDecoration(
                          labelText: data[0].nomProduit,
                        ),
                       
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.77,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        style: TextStyle(color:darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),), 
                        controller: ProductPriceBeforDiscount,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: data[0].prixProduitBefore ?? 0,
                        ),
                        
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.77,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        controller: ProductPriceNow,
                         keyboardType: TextInputType.number,
                       style: TextStyle(color:darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),), 
                        decoration: InputDecoration(
                          labelText: data[0].prixProduitAfter,
                        ),
                      
                      
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.77,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        controller: ProductDiscrption,
                      
                       style: TextStyle(color:darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),), 
                        decoration: InputDecoration(
                          labelText: data[0].description,
                        ),
                       
                      
                      ),
                    ),
                    SizedBox(height: 15),
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
                           onPressed: isLoading ? null : () => _handleUpdateProduct(data[0]),
                          child: isLoading
                              ? CircularProgressIndicator(color: Colors.blue,)
                              :
                          Text(
                            "Update Product",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: 20,)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
    }
