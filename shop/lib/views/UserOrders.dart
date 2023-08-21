import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/controllers/darkModeController.dart';
import 'package:shop/controllers/orderController.dart';

class UserOrders extends StatefulWidget {
  const UserOrders({Key? key}) : super(key: key);

  @override
  State<UserOrders> createState() => _UserOrdersState();
}

class _UserOrdersState extends State<UserOrders> {
  final OrderController orderController = Get.put(OrderController());
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
    orderController.fetchUserOrders();
    _loadSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkModeController.darkMode.value == false ? Colors.white : Color(0xff15202B),
      appBar: AppBar(
        foregroundColor: darkModeController.darkMode.value == true ? Colors.white : Color(0xff15202B),
        backgroundColor: darkModeController.darkMode.value == false ? Colors.white : Color(0xff15202B),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Obx(
        () {
          if (orderController.isdatalod.value) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (orderController.order != null) {
            return ListView.builder(
              itemCount: orderController.order!.data!.length,
              itemBuilder: (BuildContext context, int index) {
                final order = orderController.order!.data![index];
                Color statusColor = order.status == 'pending'
                    ? Colors.orange
                    : Colors.green;
                Text statusText = order.status == 'pending'
                    ? Text('On the way', style: TextStyle(color: statusColor, fontSize: 16, fontWeight: FontWeight.w500,))
                    : Text('Delivered', style: TextStyle(color: statusColor, fontSize: 16, fontWeight: FontWeight.w500,));
                Icon statusIcon = order.status == 'pending'
                    ? Icon(Icons.delivery_dining_sharp , color: Colors.orange, size: 25,)
                    : Icon(Icons.check_circle_outline, color: Colors.green, size: 25,);

                return Card(
                  elevation: 25,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        GestureDetector(
  onTap: () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            width: 200,
            height: 200,
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
          width: 60,
          height: 60,
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
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                            "\$ ${order.pricep!}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                         Spacer(),
                      statusIcon,
                        SizedBox(width: 10),
                        statusText,
                          SizedBox(width: 15),
                       
                        
                  
                      ],
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
        },
      ),
    );
  }
}
