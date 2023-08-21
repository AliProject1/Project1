import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/controllers/authController.dart';
import 'package:shop/controllers/darkModeController.dart';
import 'package:shop/views/Home.dart';

import '../controllers/productController.dart';

class SellProduct extends StatefulWidget {
  @override
  _SellProductState createState() => _SellProductState();
}

class _SellProductState extends State<SellProduct> {
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


  void _handleSellProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      
      await _productController.sellProduct(
        authController.id.value,
        ProductName.text,
        ProductPriceNow.text,
        ProductPriceBeforDiscount.text,
        ProductDiscrption.text,
        selectedImage!,
      );
      setState(() {
        isLoading = false;
      });
      Get.snackbar("Success", "Product Added Successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
          Get.to(HomePage());
    }
  }
  
   

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
            SizedBox(height: 70),
            Text(
              "Sell Product",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),
              ),
            ),
            SizedBox(height: 50),
             Center(
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Choose Image'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        GestureDetector(
                                          child: Text('Gallery'),
                                          onTap: () {
                                            _importImage();
                                            Navigator.pop(context);
                                          },
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                        ),
                                        GestureDetector(
                                          child: Text('Camera'),
                                          onTap: () {
                                            _takeImage();
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child:Stack(
  children: [
   Container(
  width: MediaQuery.of(context).size.width * 0.4,
  height: MediaQuery.of(context).size.width * 0.4,
  decoration: BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.3), // Shadow color
        spreadRadius: 2, // Spread radius of the shadow
        blurRadius: 5, // Blur radius of the shadow
        offset: Offset(0, 3), // Offset of the shadow
      ),
    ],
    shape: BoxShape.circle,
    color: darkModeController.darkMode.value == false ? Colors.white : Color(0xff15202B),
    border: Border.all(
      width: 4,
      color: Color.fromARGB(255, 211, 178, 124)
    ),
    image: selectedImage != null
        ? DecorationImage(
            image: FileImage(selectedImage!),
            fit: BoxFit.cover,
          )
        : null,
  ),
),

    if (selectedImage == null) // Display the default icon when no image is selected
      Positioned.fill(
        child: Icon(
          Icons.add_a_photo_outlined, // You can replace this with the desired default icon
          size: 40,
          color: Color.fromARGB(255, 211, 178, 124)// Customize the color of the default icon
        ),
      ),
  ],
))),
            SizedBox(height: 40),
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
                          labelText: "Product Name",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Product Name cannot be empty';
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
                        style: TextStyle(color:darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),), 
                        controller: ProductPriceBeforDiscount,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Product Price Before Discount",
                        ),
                        
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.77,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        controller: ProductPriceNow,
                         keyboardType: TextInputType.number,
                       style: TextStyle(color:darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),), 
                        decoration: InputDecoration(
                          labelText: "Product Price Now",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Product Price Now cannot be empty';
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
                        controller: ProductDiscrption,
                      
                       style: TextStyle(color:darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),), 
                        decoration: InputDecoration(
                          labelText: "Discrption",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Discrption cannot be empty';
                          }
                          return null;
                        },
                      
                      ),
                    ),
                    SizedBox(height: 24),
                    Card(
                      elevation: 25,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width * 0.6,
                        decoration: BoxDecoration(
                          gradient:  LinearGradient(
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
                          onPressed:  isLoading ? null : _handleSellProduct,
                          child: isLoading
                              ? CircularProgressIndicator(color: Colors.blue,)
                              :
                          Text(
                            "Sell Product",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
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
    );
  }
}
