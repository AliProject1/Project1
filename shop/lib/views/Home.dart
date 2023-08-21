import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/controllers/authController.dart';
import 'package:shop/controllers/darkModeController.dart';
import '../controllers/cartController.dart';
import '../controllers/productController.dart';
import '../controllers/userController.dart';
import 'CartPage.dart';
import 'ProductDetails.dart';
import 'SideBar/Sidebar.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userController _userController = Get.put(userController());
  final AuthController _authController = Get.put(AuthController());
  final ProductController _productController = Get.put(ProductController());
  final CartController _cartController = Get.put(CartController());
  bool _isLoading = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
   late SharedPreferences prefs;
  DarkModeController darkModeController = Get.put(DarkModeController());
   // Function to load shared preferences and set dark mode value
  void _loadSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      darkModeController.changeDarkMode(prefs.getBool('darkMode') ?? false);
    });
    String? id = prefs.getString('id');
      if (id != null) {
        _authController.id.value = id;
      }

  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _productController.fetchProducts();
    _loadSharedPreferences();
  }

  Future<void> _loadUserData() async {
    try {
      await _productController.getAllProducts();
      await _userController.getUser(_authController.id.toString());
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
     double maxHeight = MediaQuery.of(context).size.height;
    double maxWidth = MediaQuery.of(context).size.width;
    return _isLoading ? Scaffold(
          backgroundColor: darkModeController.darkMode.value == false ? Colors.white : Color(0xff15202B),
          body: Center(
            child: CircularProgressIndicator(),
          ),
        )
    : Scaffold(
      drawer: SideBar(),
     
      backgroundColor: darkModeController.darkMode.value == false ? Colors.white : Color(0xff15202B),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
                 onRefresh: () async {
                  Future.delayed(Duration(seconds: 2), () {
                    setState(() {
                      _isLoading = false; // Set loading state to false after 2 seconds
                    });
                  });
                 _productController.fetchProducts();
                },
        child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                     Row(
                       children: [
                         IconButton(onPressed: (){
                          Get.to(SideBar(),transition: Transition.leftToRight,duration: Duration(milliseconds: 600));
                         }, icon: 
                         Icon(Icons.menu,color: darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),size: 30,)),
                         Spacer(),
                         IconButton(onPressed: (){
                          _cartController.getUserCart(_authController.id.toString());
                          Get.to(CartPage(),transition: Transition.leftToRight,duration: Duration(milliseconds: 600));
                         }, icon: 
                         Icon(Icons.shopping_cart_outlined,color: darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),size: 30,)),
                       ],
                     ),
                      
                    _productController.products.length  == 0 ? 
                    Center(
      child: Text(
        'There are no products.',
        style: TextStyle(
          fontSize: 18,
          color: darkModeController.darkMode.value == false
              ? Color(0xff15202B)
              : Colors.white,
        ),
      ),
    )
           :ListView.builder(
  shrinkWrap: true,
  reverse: true,
  physics: NeverScrollableScrollPhysics(),
  itemCount: _productController.products.length,
  itemBuilder: (BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          Get.to(
            ProductDetails(),
            arguments: [
              _productController.products[index],
            ],
            transition: Transition.leftToRight,
            duration: Duration(milliseconds: 600),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: darkModeController.darkMode.value == false
                ? Colors.white
                : Color(0xff15202B),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: darkModeController.darkMode.value == true
                    ? Colors.white.withOpacity(0.1)
                    : Color(0xff15202B).withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: (MediaQuery.of(context).size.width - 8) / 2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                          ),
                          child: Card(
                            elevation: 0,
                            child: Container(
                              width: double.infinity,
                              height: maxHeight * 0.2,
                              child: Image.network(
                                _productController.products[index].photoProduitPrincipale ?? '',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 35),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _productController.products[index].nomProduit ?? '',
                              style: GoogleFonts.aboreto(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: darkModeController.darkMode.value == false
                                    ? Color(0xff15202B)
                                    : Colors.white,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${_productController.products[index].prixProduitAfter} DT',
                              style: GoogleFonts.aboreto(
                                fontSize: 14,
                                color: darkModeController.darkMode.value == false
                                    ? Color(0xff15202B)
                                    : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  _productController.products[index].prixProduitBefore == null || _productController.products[index].prixProduitBefore == '' ?
                   SizedBox()
                  :Positioned(
                    bottom: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${_productController.products[index].prixProduitBefore} DT',
                              style: GoogleFonts.aboreto(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 14,
                                color:Colors.red
                              ),),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  },
)




                 
                
                   
                  ],
                ),
              ),
      ),
    );
  }
}
