
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/views/EditProfile.dart';
import 'package:shop/views/UserOrders.dart';
import 'package:shop/views/signin.dart';
import '../../controllers/authController.dart';
import '../../controllers/darkModeController.dart';
import '../../controllers/productController.dart';
import '../../controllers/userController.dart';
import '../CartPage.dart';
import '../Home.dart';
import '../profile.dart';
import '../sellProduct.dart';
import 'infocard.dart';


class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
   final userController _userController = Get.put(userController());
  final AuthController _authController = Get.put(AuthController());
  final ProductController _productController = Get.put(ProductController());
  
 
  late SharedPreferences prefs;
  DarkModeController darkModeController = Get.put(DarkModeController());
   // Function to load shared preferences and set dark mode value
  void _loadSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      darkModeController.changeDarkMode(prefs.getBool('darkMode') ?? false);
    });
  }

  // Function to handle changes to dark mode
  void _handleDarkModeChange(bool value) async {
    setState(() {
      darkModeController.changeDarkMode(value);
    });
    // Save the dark mode value to shared preferences
    await prefs.setBool('darkMode', value);
  }


  _logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('id');
  prefs.remove('token');
  Get.to(SignIn());
  }


   @override
  void initState() {
    super.initState();
    _loadSharedPreferences();
  }

 final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.dark_mode,color: Colors.white,);
      }
      return const Icon(Icons.light_mode,color: Colors.black,);
    },
  );
 
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [ Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
                                                       gradient: LinearGradient(
                                colors: [Color(0xffADC4CE),
                                         Color(0xff5db1df),
                                         ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                                       ),
                                                    
                                                     ),
          child: ListView(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: darkModeController.darkMode.value ==false ? Colors.white : Color(0xff15202B),
                            size: 30,
                          ),
                          onPressed: () {
                            Get.to(HomePage()); },
                        ),
                       Spacer(),
                        IconButton(
  onPressed: () {
    _handleDarkModeChange(!darkModeController.darkMode.value);
  },
  icon: darkModeController.darkMode.value == false
      ? Icon(Icons.light_mode, color: Colors.white,)
      : Icon(Icons.dark_mode, color: Colors.black,),
),
SizedBox(
  width: 24,
),
                        
                        
                      ],
                    ),
                    InfoCard(
                      color: darkModeController.darkMode.value ==false ? Colors.white : Color(0xff15202B),
                      imageUrl: _userController.userData!.photo.toString(),
                      name: _userController.userData!.username.toString(),
                      bio: _userController.userData!.email.toString(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 22, top: 15, right: 15),
                      child:  Divider(color:darkModeController.darkMode.value ==false ? Colors.white : Color(0xff15202B), height: 10),
                    ),
                    
                      SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                        ),
                        Icon(
                          Icons.person,
                          color: darkModeController.darkMode.value ==false ? Colors.white : Color(0xff15202B),
                        ),
                        TextButton(
                          onPressed: () {
                          Get.to(ProfilePage());
                          },
                          style: TextButton.styleFrom(
                            primary: Color(0xFF33669A),
                          ),
                          child: Text(
                            'Profile',
                            style: TextStyle(
                              fontSize: 18,
                             color:  darkModeController.darkMode.value ==false ? Colors.white : Color(0xff15202B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                      SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                        ),
                        Icon(
                          Icons.edit,
                          color: darkModeController.darkMode.value ==false ? Colors.white : Color(0xff15202B),
                        ),
                        TextButton(
                          onPressed: () {
                          Get.to(EditProfile());
                          },
                          style: TextButton.styleFrom(
                            primary: Color(0xFF33669A),
                          ),
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 18,
                             color:  darkModeController.darkMode.value ==false ? Colors.white : Color(0xff15202B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                   
                   

                     SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                        ),
                        Icon(
                          Icons.shopping_cart_outlined,
                          color: darkModeController.darkMode.value ==false ? Colors.white : Color(0xff15202B),
                        ),
                        TextButton(
                          onPressed: () {
                          Get.to(CartPage());
                          },
                          style: TextButton.styleFrom(
                            primary: Color(0xFF33669A),
                          ),
                          child: Text(
                            'My cart',
                            style: TextStyle(
                              fontSize: 18,
                             color:  darkModeController.darkMode.value ==false ? Colors.white : Color(0xff15202B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                   
          

          SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                        ),
                        Icon(
                          Icons.list_alt,
                          color: darkModeController.darkMode.value ==false ? Colors.white : Color(0xff15202B),
                        ),
                        TextButton(
                          onPressed: () {
                          Get.to(UserOrders());
                          },
                          style: TextButton.styleFrom(
                            primary: Color(0xFF33669A),
                          ),
                          child: Text(
                            'Your orders',
                            style: TextStyle(
                              fontSize: 18,
                             color:  darkModeController.darkMode.value ==false ? Colors.white : Color(0xff15202B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),



                    
          SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                        ),
                        Icon(
                          Icons.storefront,
                          color: darkModeController.darkMode.value ==false ? Colors.white : Color(0xff15202B),
                        ),
                        TextButton(
                          onPressed: () {
                          Get.to(SellProduct());
                          },
                          style: TextButton.styleFrom(
                            primary: Color(0xFF33669A),
                          ),
                          child: Text(
                            'Add Product to sell',
                            style: TextStyle(
                              fontSize: 18,
                             color:  darkModeController.darkMode.value ==false ? Colors.white : Color(0xff15202B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                   
                  
                   
                  
      
           


        
                
  ]),
        ),





         darkModeController.darkMode.value ==false ? 
     Positioned(
  bottom: MediaQuery.of(context).size.height * 0.19,
  right: -MediaQuery.of(context).size.width * 0.20,
  child: Stack(
    children: [
      Container(
        width: MediaQuery.of(context).size.width * 0.55,
        height: MediaQuery.of(context).size.width ,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.8),
              blurRadius: 25,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Transform.rotate(
          angle: -0.2,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.width * 0.8,
            child: Image.asset('lib/images/light.jpg', fit: BoxFit.cover),
          ),
        ),
      ),
    ],
  ),
) : 
     Positioned(
  bottom: MediaQuery.of(context).size.height * 0.19,
  right: -MediaQuery.of(context).size.width * 0.20,
  child: Stack(
    children: [
      Container(
        width: MediaQuery.of(context).size.width * 0.55,
        height: MediaQuery.of(context).size.width ,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.8),
              blurRadius: 25,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Transform.rotate(
          angle: -0.2,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.width * 0.8,
            child: Image.asset('lib/images/dark.jpg', fit: BoxFit.cover),
          ),
        ),
      ),
    ],
  ),
),


         Positioned(
        bottom: -MediaQuery.of(context).size.height * 0.035,
        right: -MediaQuery.of(context).size.width * 0.045,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:  darkModeController.darkMode.value ==false ? Colors.white : Color(0xff15202B),
              ),
              child: ElevatedButton(
                onPressed: (){
                  _logout();
                 
                
                },
                child: Text('Logout',style: TextStyle(color: darkModeController.darkMode.value ==true ? Colors.white : Color(0xff15202B),fontSize: 18,fontWeight: FontWeight.w500),),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(8.0),
                  primary: darkModeController.darkMode.value ==false ? Colors.white : Color(0xff15202B),
                  
                ),
              ),
            ),)
        ],
      ),
    );    
  }
}





