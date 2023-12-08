import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:nodejstoflutter/newlist.dart';
import 'package:nodejstoflutter/screens/onboding/onboding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EasyList',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFEEF1F8),
    primarySwatch: Colors.blue,
    fontFamily: "Intel",
    inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    errorStyle: TextStyle(height: 0),
    border: defaultInputBorder,
    enabledBorder: defaultInputBorder,
    focusedBorder: defaultInputBorder,
    errorBorder: defaultInputBorder,
      ),
      ),
      home:  SplashScreen()
    );
  }
}

const defaultInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(16)),
  borderSide: BorderSide(
    color: Color(0xFFDEE3F2),
    width: 1,
  ),
);

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    String? token = await getToken();
    String getUserIdFromToken(String token) {
      Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
      // Burada JWT'den kullanıcı kimliğini çıkarın
      return decodedToken['userId'] as String;
    }

    if (token != null) {
      print("Token: $token");

      final userId = getUserIdFromToken(token);
      print ("Giriş ok");
      // Token'ı saklamak için SharedPreferences kullanabilirsiniz.
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);

      // Token'ı kullanarak istediğiniz sayfaya yönlendirme veya başka işlemler yapabilirsiniz.
      print('Token: $token');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NewList(),settings: RouteSettings(
          arguments: userId,
        ),),
      );
    } else {
      print("Token bulunamadı.");
      // Token yoksa, giriş ekranına yönlendirebilirsiniz.
      // Örneğin:
      Navigator.pushReplacement(
       context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
       );
    }
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}