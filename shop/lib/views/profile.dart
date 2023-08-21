import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/controllers/darkModeController.dart';
import 'package:shop/views/UpdateProduct.dart';
import '../controllers/authController.dart';
import '../controllers/orderController.dart';
import '../controllers/productController.dart';
import '../controllers/userController.dart';
import 'package:shop/models/Product.dart';

import 'UserOrders.dart';
import 'sellProduct.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final userController _userController = Get.put(userController());
  final OrderController _orderController = Get.put(OrderController());
   final AuthController _authController = Get.put(AuthController());
   final ProductController _productController = Get.put(ProductController());
  List<String> Products =[];
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
    _orderController.fetchUserOrders();
    _userController.getUser(_authController.id.toString()).then((value) => setState(() {
      Products = _userController.userData!.myProducts;
    }));
    _loadSharedPreferences(); 
  }

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;
    double maxWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: darkModeController.darkMode.value == false ? Colors.white : Color(0xff15202B),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff7B68EE).withOpacity(0.8),
                          darkModeController.darkMode.value == false ? Colors.white : Color(0xff15202B),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    width: double.infinity,
                    height: maxHeight * 0.3,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 145),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Container(
                                    width: maxWidth * 0.8,
                                    height: maxHeight * 0.45,
                                    child: _userController.userData?.photo != null || _userController.userData?.photo != ''
                                        ? Image.network(
                                            _userController.userData!.photo.toString(),
                                            fit: BoxFit.cover,
                                          )
                                        : Icon(
                                            Icons.person,
                                            size: 80,
                                            color: darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),
                                          ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child:  _userController.userData?.photo == null || _userController.userData?.photo == '' ?
                         ClipOval(
                            child: Container(
                                    width: 120,
                                    height: 120,
                                    color: darkModeController.darkMode.value == false ? Colors.white : Color(0xff15202B),
                           child: Icon(
                                    
                            
                                     Icons.person,
                                      size: 80,
                                     color: darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),
                                   ),)
                         ) 
                                 :
                        CircleAvatar(
                           radius: 60,
                          backgroundColor: darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),
                          child:  ClipOval(
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Image.network(
                                      _userController.userData!.photo.toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                   
                                ) ) 
                                
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                _userController.userData?.username.toString() ?? '',
                style: GoogleFonts.abhayaLibre(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),
                ),
              ),
              SizedBox(height: 16),

             Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 20,),
                          Text(
                            "My Products",
                            style: TextStyle(
                              color: darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Spacer(),
                         
                          IconButton(onPressed: (){
                            Get.to(SellProduct());
                          }, icon: Icon( Icons.add,color: darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),size: 30,),),
                           SizedBox(width: 20,),
                        ],
                      ),
              SizedBox(height: 16),
          Padding(
  padding: const EdgeInsets.only(left: 20, right: 20),
  child: SingleChildScrollView(
    scrollDirection: Axis.vertical, // Scroll vertically
    child: Column(
      children: List.generate(
        Products.length,
        (index) => FutureBuilder(
          future: _productController.getProductById(Products[index]),
          builder: (BuildContext context, AsyncSnapshot<Product> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Display a loading indicator while fetching data
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData) {
              return Container(); // Return an empty container if no data is available
            }

            final product = snapshot.data;

            return Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0), // Keep the top-left border radius
                  bottomLeft: Radius.circular(15.0), // Keep the bottom-left border radius
                ),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.zero, // Remove padding around the ListTile content
                onTap: () {
                  // Handle the tap event
                },
                leading: ClipRRect(
                  child: Container(
                    width: 80, // Adjust the width as needed
                    height: 80, // Adjust the height as needed
                    child: Image.network(
                      product!.photoProduitPrincipale ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(
                  product.nomProduit ?? '',
                  style: GoogleFonts.aboreto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff15202B),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.to(UpdateProduct(),arguments: [product]);
                      },
                      icon: Icon(Icons.edit,color: const Color.fromARGB(255, 29, 91, 142),),
                    ),
                    IconButton(
                      onPressed: () {
                        _productController.deleteProductById(product.sId.toString());
                      },
                      icon: Icon(Icons.delete,color: const Color.fromARGB(255, 184, 46, 36),),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ),
  ),
),


  Row(
                        
                        children: [
                          SizedBox(width: 20,),
                          Text(
                            "History",
                            style: TextStyle(
                              color: darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Spacer(),
                          TextButton(
                            onPressed: () {
                               Get.to(UserOrders());
                            },
                            child: Text(
                              "See All",
                              style: TextStyle(
                                color: darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),
                                fontSize: 16,
                              ),
                            ),
                          ),
                           SizedBox(width: 20,),
                        ],
                      ),
              Obx(() {
                if (_orderController.isdatalod.value) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (_orderController.order != null) {
                  return ListView.builder(
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
  itemCount: _orderController.order!.data!.length > 5 ? 5 : _orderController.order!.data!.length,
  itemBuilder: (context, index) {
    final order = _orderController.order!.data![index];
    final created = DateTime.parse(order.createdAt.toString());
    Color statusColor = order.status == 'pending' ? Colors.orange : Colors.green;
    Text statusText = order.status == 'pending'
        ? Text('pending', style: TextStyle(color: statusColor, fontSize: 16, fontWeight: FontWeight.w500,))
        : Text('Delivered', style: TextStyle(color: statusColor, fontSize: 16, fontWeight: FontWeight.w500,));
    Icon statusIcon = order.status == 'pending'
        ? Icon(Icons.delivery_dining_sharp , color: Colors.orange, size: 25,)
        : Icon(Icons.check_circle_outline, color: Colors.green, size: 25,);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Card(
        elevation: 10,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: SizedBox(
                          width: maxWidth * 0.8,
                          height:maxWidth * 0.8,
                          child: order.pphote == null
                              ? Icon(Icons.image)
                              : Image.network(
                                  order.pphote!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      );
                    },
                  );
                },
                child: ClipOval(
                  child: Material(
                    color: Colors.white,
                    child: InkWell(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: order.pphote == null
                            ? Icon(Icons.image)
                            : Image.network(
                                order.pphote!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Column(
                children: [
                  Text(
                    order.namep!,
                    style: GoogleFonts.acme(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "\$ ${order.pricep!}",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Text(
                "${created.day}/${created.month}/${created.year}",
                style: GoogleFonts.acme(
                  fontSize: 14,
                  fontWeight: FontWeight.w200,
                ),
              ),
              SizedBox(width: 8),
              statusText,
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  },
);

                } else {
                  return Center(
                    child: Text("No orders available."),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
