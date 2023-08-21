import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/controllers/authController.dart';
import 'package:shop/controllers/darkModeController.dart';
import 'package:shop/controllers/orderController.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';


 const List<String> list2 = <String>[
  'Ariana', 'Béja','Ben Arous', 'Bizerte', 'Gabès', 'Gafsa',
  'Jendouba', 'Kairouan', 'Kasserine', 'Kebili', 'Kef', 'Mahdia',
  'Manouba', 'Medenine', 'Monastir', 'Nabeul', 'Sfax', 'Sidi Bouzid', 'Siliana',
  'Sousse', 'Tataouine', 'Tozeur', 'Tunis' , 'Zaghouan'
];

class BuyNow extends StatefulWidget {
  @override
  _BuyNowState createState() => _BuyNowState();
}


class _BuyNowState extends State<BuyNow> {

 

 String dropdownValue2 = list2.first ;




  final _formKey = GlobalKey<FormState>();
  TextEditingController rue = TextEditingController();

  TextEditingController code = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController lastName= TextEditingController();
  TextEditingController phone = TextEditingController();
  final OrderController orderController = Get.put(OrderController());
  final AuthController _authController = Get.put(AuthController());
  var data = Get.arguments;
  bool isOrderPlaced = false; 
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkModeController.darkMode.value == false ? Colors.white : Color(0xff15202B),
      appBar: AppBar(
        
        backgroundColor: darkModeController.darkMode.value == false ? Colors.white : Color(0xff15202B),
        elevation: 0,
         scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body:  Form(
        key: _formKey,
        child: Padding(
           padding: const EdgeInsets.only(left : 16,right: 16),
          child: ListView(
            children: [
              
        
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  
                  Text(data[0].nomProduit ,style: GoogleFonts.abel(
                       letterSpacing: 1.5,
                        fontWeight: FontWeight.w700,
                        fontSize: 30,
                        color: Color.fromARGB(255, 122, 105, 77),
                      ),),
                  
                 Text("${data[0].prixProduitAfter} \$" ,style: GoogleFonts.pacifico(
                        fontWeight: FontWeight.w400,
                        fontSize: 22,
                        color:Color.fromARGB(255, 122, 105, 77),
                      ),),
                 
                ],
              ),
              SizedBox(height: 20,),
              
              Container(
                
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xffEEE0C9),
                      Colors.white.withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                
                child: DropdownButton(
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(15),
                  
                              items: list2.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Padding(
                                        padding: EdgeInsets.only(left:0),
                                        child: Text(value,style: TextStyle(fontSize: 20,letterSpacing: 2),))),
                                );
                              }).toList(),
                              value: dropdownValue2,
                              onChanged: (String? value) {
                                // This is called when the user selects an item.
                                setState(() {
                                  dropdownValue2 = value!;
                                 
                                });
                              },
                              underline: SizedBox(),
                              elevation: 17,
                               
                            ),
              ),
             SizedBox(height: 10,),
        TextFormField(
          controller: rue,
          decoration: InputDecoration(
            labelText: 'Rue',
            labelStyle: TextStyle(color: darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),),
          ),
          style: TextStyle(color: darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a value';
            }
            return null;
          },
        ),
        SizedBox(height: 10,),
        
        SizedBox(height: 10,),
        TextFormField(
          controller: code,
          decoration: InputDecoration(
            labelText: 'Code postal',
            labelStyle: TextStyle(color:  darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),),
          ),
          style: TextStyle(color:  darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a value';
            }
            return null;
          },
        ),
        SizedBox(height: 10,),
        TextFormField(
          controller: name,
          decoration: InputDecoration(
            labelText: 'Nom',
            labelStyle: TextStyle(color:  darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),),
          ),
          style: TextStyle(color:  darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a value';
            }
            return null;
          },
        ),
        SizedBox(height: 10,),
        TextFormField(
          controller: lastName,
          decoration: InputDecoration(
            labelText: 'Prenom',
            labelStyle: TextStyle(color:  darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),),
          ),
          style: TextStyle(color:  darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a value';
            }
            return null;
          },
        ),
        SizedBox(height: 10,),
        TextFormField(
          controller: phone,
          decoration: InputDecoration(
            labelText: 'Phone',
            labelStyle: TextStyle(color:  darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),),
          ),
          style: TextStyle(color:  darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a value';
            }
            return null;
          },
        ),

              SizedBox(height: 40.0),
               isOrderPlaced
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 60,
                      )
                    : 
              ConfirmationSlider(
                sliderButtonContent: Icon(Icons.arrow_forward,color: Color(0xffEEE0C9),),
                foregroundShape: BorderRadius.circular(30),
                backgroundShape: BorderRadius.circular(30),
                backgroundColor: Color(0xffEEE0C9),
                backgroundColorEnd: Colors.white.withOpacity(0.6),
                foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                onConfirmation: () async {

                  if (_formKey.currentState!.validate()) {
                      orderController.OrderProduct(
                       data[0].photoProduitPrincipale,
                      _authController.id.value,
                        data[0].sId,
                        rue.text,
                          dropdownValue2, 
                          code.text,
                           phone.text,
                            name.text,
                             lastName.text,
                              data[0].nomProduit, 
                              data[0].prixProduitAfter
                              );
                           
                        setState(() {
                                isOrderPlaced = true;
                              });
                    }
                  
                },
                text: 'SWIPE TO Buy',
                textStyle: TextStyle(
                  color: const Color.fromARGB(255, 5, 5, 5),
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  letterSpacing: 2
                ),
              )
             
            ],
          ),
        ),
      ),
    );
  }
}
