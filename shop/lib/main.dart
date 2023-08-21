import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/controllers/authController.dart';
import 'package:shop/views/Home.dart';
import 'package:shop/views/signin.dart';
import 'package:connectivity/connectivity.dart';




Future<bool> checkInternetConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  return connectivityResult != ConnectivityResult.none;
}
void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? id = prefs.getString('id');
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
  SystemUiOverlay.bottom
]);
SystemChrome.setPreferredOrientations([
   DeviceOrientation.portraitUp,
  ]);

  AuthController _authController = Get.put(AuthController());
  bool hasInternet = await checkInternetConnection();

  Widget initialScreen;
  if (!hasInternet) {
    initialScreen = NoInternetPage();
  } else if (id != null ) {
    // User is logged in, redirect to the Wallet page
    _authController.id.value = id;
  
    initialScreen = HomePage(); 
   
  } else {
    initialScreen = SignIn();
  }

  runApp(MyApp(initialScreen));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;
   MyApp(this.initialScreen, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: initialScreen,
    );
  }
}


class NoInternetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'No Internet Connection',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}