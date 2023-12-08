import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nodejstoflutter/model/user_details.dart';
import 'package:nodejstoflutter/model/user_register.dart';
import 'package:nodejstoflutter/newlist.dart';
import 'package:nodejstoflutter/screens/onboding/components/login_form_new.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';

class Api{

  //static const baseUrl="http://192.168.1.47:3000/api/";
  static const baseUrl="https://easylist-vyor.onrender.com/api/";

  static adduser(BuildContext context,Map udata) async {
    print("Create Bölümü Çalıştı ${udata}");
    
    var url=Uri.parse("${baseUrl}user/register");

    try {
      var res = await http.post(url, body: udata);
      print(res.statusCode);
      if (res.statusCode == 200) {
     Map data=jsonDecode(res.body);
      print(data);
     Navigator.push(context, MaterialPageRoute(builder: (context) => LogInFormNew(),));
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
       backgroundColor: Colors.green,

       content: Text(
         "Kullanıcı başarı ile oluşturuldu.",
         style: TextStyle(color: Colors.white),
       ),
     ));

      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,

          content: Text(
            "Girmiş olduğunuz bilgiler eksik lütfen tekrar deneyiniz.",
            style: TextStyle(color: Colors.white),
          ),
        ));
 print("failed");
      }
    }catch(err){
    debugPrint(err.toString());
  }
  }

  static Future<void> addUser1(BuildContext context,Map udata) async {
    var url=Uri.parse("${baseUrl}user/register");
    final response = await http.post(
      url,
        headers: {'Content-Type': 'application/json'},
      body: jsonEncode(udata)
    );

    if (response.statusCode == 200) {
      var data=jsonDecode(response.body);
      Navigator.push(context, MaterialPageRoute(builder: (context) => LogInFormNew(),));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,

        content: Text(
          "Kullanıcı başarı ile oluşturuldu.",
          style: TextStyle(color: Colors.white),
        ),
      ));
      //fetchUsers(); // Kullanıcı ekledikten sonra listeyi güncelle
      print(data +"Eklendiiii");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,

        content: Text(
          "Girmiş olduğunuz bilgiler eksik lütfen tekrar deneyiniz.",
          style: TextStyle(color: Colors.white),
        ),
      ));
      print("Eklenmedi, HTTP Durum Kodu: ${response.statusCode}");
    }
  }
  static Future<List<UserRegister>> getUsers1204() async {
    List<UserRegister> userList = [];

    var url = Uri.parse("${baseUrl}user/users");

    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);

        data.forEach((value) {
          var userDetailsData = value["userdetails"]; // userdetails'ı al

          // userdetails'ı ayrıştır ve UserDetailsModel kullanarak oluştur
          var userDetailsList = (userDetailsData as List)
              .map((detail) => UserDetailsModel.fromJson(detail))
              .toList();

          userList.add(UserRegister(
            id: value["_id"].toString(),
            name: value["name"],
            email: value["email"],
            password: value["password"],
            userdetails: userDetailsList,
          ));
        });

        return userList;
      } else {
        print("HTTP Status Code: ${res.statusCode}");
        return [];
      }
    } catch (err) {
      print("Error: $err");
      return [];
    }
  }

  static getUsers() async{
    List<UserRegister> userList=[];
    var url=Uri.parse("${baseUrl}user/users");
    try{
      final res=await http.get(url);
      if(res.statusCode==200){
        var data=jsonDecode(res.body);

        data.forEach(
            (value){
              var userDetailsData = value["userdetails"];
              var userDetailsList = (userDetailsData as List)
                  .map((detail) => UserDetailsModel.fromJson(detail))
                  .toList();
              userList.add(UserRegister(id: value["_id"].toString(),  name: value["name"],email: value["email"],password: value["password"],userdetails: userDetailsList),
              );
            print(userList);
            }
        );

        return userList;
      }
      else{
        return [];
      }
    }catch(err){
      print(err.toString());
    }
  }

  static  updateUser(id,body) async{
    var url=Uri.parse(baseUrl+"user/userupdate/$id");

    final res=await http.post(url,body:body);
    if(res.statusCode==200){
      print(jsonDecode(res.body));
    }else{
      print("failed to update data");
    }
  }
  static  deleteUser(id) async{
    var url=Uri.parse(baseUrl+"user/userdelete/$id");

    final res=await http.post(url);
    if(res.statusCode==200){

      print("BAŞARILIII");
    }else{
      print("failed to delete data");
    }
  }
  static  getUserDetails(id,body) async{
    var url=Uri.parse(baseUrl+"user/users/$id");

    final res=await http.post(url,body:body);
    if(res.statusCode==200){

      print("BAŞARILIII");
    }else{
      print("failed to delete data");
    }
  }


  static Future<String?>  login(BuildContext context,Map udata) async {
    var url=Uri.parse(baseUrl+"user/login");
    final response = await http.post(url,
      //headers: {'Content-Type': 'application/json'},
      body:udata
    );
    String getUserIdFromToken(String token) {
      Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
      // Burada JWT'den kullanıcı kimliğini çıkarın
      return decodedToken['userId'] as String;
    }

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['token'];
      final userId = getUserIdFromToken(token);
      print ("Giriş ok");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,

        content: Text(
          "Başarı ile giriş yaptınız",
          style: TextStyle(color: Colors.white),
        ),
      ));
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,

        content: Text(
          "Email ve ya şifreniz yanlış lütfen tekrar deneyiniz.",
          style: TextStyle(color: Colors.white),
        ),
      ));
      print('Giriş başarısız: ${response.body}');
    }
  }
 }



