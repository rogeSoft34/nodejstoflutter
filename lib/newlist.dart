import 'package:nodejstoflutter/constants/color.dart';
import 'package:nodejstoflutter/listadd.dart';
import 'package:nodejstoflutter/screens/onboding/onboding_screen.dart';
import 'package:nodejstoflutter/views/pdf_page1.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:nodejstoflutter/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewList extends StatefulWidget {
  const NewList({Key? key}) : super(key: key);

  @override

  State<NewList> createState() => _NewListState();
}

class _NewListState extends State<NewList> {
  int selectedIndex=0;

  DateTime dateTime=DateTime.now();
  APIService apiService=APIService();
  @override

  Widget build(BuildContext context) {
    double deviceHight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    final userId = ModalRoute.of(context)!.settings.arguments as String;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Anasayfa"),actions: [ElevatedButton.icon(onPressed: ()async{await clearToken();

        // Giriş sayfasına yönlendir
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnboardingScreen()),
        );}, icon: Icon(Icons.login_outlined), label: Text("Çıkış"))]),
        body:
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: deviceWidth,
                height: deviceHight / 6,
                decoration: BoxDecoration(
                    color: Colors.purple,
                    image: DecorationImage(
                      image: AssetImage("lib/assets/images/header.png"),
                      fit: BoxFit.cover,
                    )),
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(DateFormat("dd/MM/yyyy").format(dateTime),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.white),)),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
          
                          Text(
                            "YENİ LİSTE",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: deviceWidth,
                height: deviceHight / 4
                ,child:
              Card(margin: EdgeInsets.all(13),child: Column(crossAxisAlignment:CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center ,children: [
                Text("YENİ LİSTE EKLE",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: HexColor(mainColor)),),
                IconButton(icon: Icon(Icons.add_box,size: 90,color: HexColor(mainColor)),onPressed: ()async{
                  apiService.deletePdf(userId);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Listadd(),settings: RouteSettings(
                    arguments: userId,
                  ),
                  ),
                  );},)
              ],),),),
              Container(
                width: deviceWidth,
                height: deviceHight / 4
                ,child:
              Card(margin: EdgeInsets.all(13),child: Column(crossAxisAlignment:CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center ,children: [
                Text("DEVAM EDEN LİSTEYİ GİT",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: HexColor(mainColor)),),
                IconButton(icon: Icon(Icons.remove_red_eye,size: 90,color: HexColor(mainColor),),onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Listadd(),settings: RouteSettings(
                  arguments: userId,
                ),
                ),
                );},)
              ],),),),
            ],
          ),
        ),
    /* bottomNavigationBar: NavigationBar(destinations: [
       NavigationDestination(icon: Icon(Icons.add), label: "Ekle"),
       NavigationDestination(icon: Icon(Icons.add), label: "Ekle"),
     ],
     selectedIndex: selectedIndex,
     ),*/ ),
    );
  }
}

// Token'ı temizleyen metod
Future<void> clearToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
}

// Çıkış yap butonu örneği
