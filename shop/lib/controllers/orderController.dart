import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shop/controllers/authController.dart';

import '../api/Api.dart';
import '../models/order.dart';

class OrderController extends GetxController {
    RxString orederResponse = ''.obs;
    RxBool isdatalod = false.obs;
    Order? order;
    final AuthController _authController = Get.put(AuthController());


    @override
  void onInit() {
    super.onInit();
    fetchUserOrders();
  }
    
   void  fetchUserOrders() async {
     try{
       isdatalod(true);
       http.Response response = await http.get(
         Uri.tryParse("${API().url.toString()}order/${_authController.id.value}")!,
         
         headers: {
           'content-type' : 'application/json',
         }
       );
       if(response.statusCode == 200){
         var result = jsonDecode(response.body);
         order =  Order.fromJson(result);
         print(order!.data!.length);
       }else{
         print("zeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeb");
       }
     }catch(e){
       print('Error while getting data is $e');
     }finally{
      isdatalod (false);
     }

   }


Future<void> OrderProduct(
    String urlpho,
    String userId,
    String productId,
    String rue,
    String wileya,
    String codePostal,
    String phone,
    String nameUser,
    String lastName,
    String nameProduct,
    String priceProduct) async {
  final url = '${API().url.toString()}order';


  final response = await http.post(
    Uri.parse(url),
    body: {
      'userId': userId,
      'productID': productId,
      'rue': rue,
      'wileya': wileya,
      'code_postal': codePostal,
      'phone': phone,
      'nameUser': nameUser,
      'lastName': lastName,
      'namep': nameProduct,
      'pricep': priceProduct,
      'pphote': urlpho,
    },
  );

  if (response.statusCode == 200) {
    orederResponse.value = 'Order added successfully';
    print(urlpho);
    print("Order added successfully");
  } else {
    orederResponse.value = 'Error: ${response.statusCode}';
    print("Error: ${response.statusCode}");
  }
}

}