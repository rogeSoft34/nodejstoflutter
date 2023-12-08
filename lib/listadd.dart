
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nodejstoflutter/constants/api_constanst.dart';
import 'package:nodejstoflutter/constants/color.dart';
import 'package:nodejstoflutter/model/list_products.dart';
import 'package:nodejstoflutter/newlist.dart';
import 'package:nodejstoflutter/services/api_service.dart';
import 'package:nodejstoflutter/services/google_ads.dart';
import 'package:nodejstoflutter/views/pdf_page1.dart';

class Listadd extends StatefulWidget {
  const Listadd({Key? key}) : super(key: key);

  @override

  State<Listadd> createState() => _ListaddState();
}

class _ListaddState extends State<Listadd> {
final GoogleAds googleAds=GoogleAds();

 // AuthService authService=AuthService();
  List<String> paraBirimi=['₺','\$','€'];
  String selectParaBirimi='₺';
  bool isChecked = false;
  String _description = "";

  DateTime dateTime=DateTime.now();
  int _peers = 0;
  double _price = 0;
  double _total = 0;
  String uid="12";

@override
void initState() {
   googleAds.loadBannerAd(adlLoaded: (){
     setState(() {

     });
   });
   googleAds.loadInterstitialAd();
    super.initState();
  }
  final _formKey = GlobalKey<
      FormState>(); // Formu butonda çağıra bilmek için bir key veriliyor onu bu şekilde key ile formda çaırıyoruz
  final ImagePicker _picker = ImagePicker();
  File? dosya;
  TextEditingController firmaNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController peersController = TextEditingController();
  TextEditingController paraBirimController = TextEditingController();


  Future<void> pickImage() async {
    try {
      var image = await _picker.pickImage(source: ImageSource.camera,imageQuality: 10);
      if (image == null) return;
      setState(() {
        dosya = File(image.path);
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> pickImageGallery() async {
    try {
      var image = await _picker.pickImage(source: ImageSource.gallery,imageQuality: 10);
      if (image == null) return;
      setState(() {
        dosya = File(image.path);
      });
    } catch (error) {
      print(error);
    }
  }

  APIService apiService = APIService();

  /*void initState() {
    super.initState();

    // ilk metin alanındaki değişiklikleri dinle
    firmaNameController.addListener(() {
      // ilk metin alanına bir şey yazıldığında
      if (firmaNameController.text.isNotEmpty) {
        // ikinci metin alanına odaklan
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });
  }*/

  @override
  Widget build(BuildContext context) {
    final userId = ModalRoute.of(context)!.settings.arguments as String;
    double deviceHight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    bool isTextFieldVisible = descriptionController.text.isEmpty ||
        priceController.text.isEmpty ||
        firmaNameController.text.isEmpty ||
        dosya!.path.isEmpty;

    return SafeArea(
      child: Scaffold(
          backgroundColor: HexColor(backgroundColor),
          body: SingleChildScrollView(
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(top: 10,left: 10),
                              child: IconButton(onPressed:(){Navigator.push(context, MaterialPageRoute(builder: (context) => NewList(),settings: RouteSettings(
                                arguments: userId,
                              ),));} ,icon: Icon(Icons.arrow_back,color: Colors.white,size: 30,),)),
                          Padding(
                              padding: EdgeInsets.only(top: 10,left: 10),
                              child:  Text(DateFormat("dd/MM/yyyy").format(dateTime),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.white),)),
                          Padding(
                            padding: const EdgeInsets.only(top: 10,right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.shopping_cart_checkout,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                Text(
                                  "$selectParaBirimi $_total",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10,right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Text(
                              "Ürün Ekleme Sayfası",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold),
                            ),

                          ],
                        ),
                      ),


                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Column(
                    children: [
                      if (googleAds.bannerAd!= null)
                        Container(
                          width:468 ,
                          height: 60,
                          child: AdWidget(ad: googleAds.bannerAd!,),
                        ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13)),
                        child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                dosya != null
                                    ? Image.file(
                                        dosya!,
                                        height: 70,
                                        width: 70,
                                        fit: BoxFit.cover,
                                      )
                                    : SizedBox.shrink(),
                                IconButton(
                                    onPressed: () {
                                      pickImage();
                                    },
                                    icon: Icon(Icons.photo_camera)),
                                IconButton(
                                    onPressed: () {
                                      pickImageGallery();
                                    },
                                    icon: Icon(Icons.perm_media_outlined)),
                              ],
                            )),
                      ),
                      Visibility(
                       // visible: isTextFieldVisible,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13)),
                          child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child:
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: deviceWidth/1.9,
                                  child: TextField(
                                    controller: firmaNameController,
                                    keyboardType: TextInputType.text,
                                    autofocus: true,
                                    // maxLines: 2,
                                    //maxLength: ,
                                    cursorColor: HexColor(mainColor),
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: HexColor(textBorder)),
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(13)),
                                      ),
                                      //focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: HexColor(mainColor))) ,

                                      labelText: 'Company(Firma Adı)',
                                      //hintText: 'Description',
                                      //icon: Icon(Icons.add)
                                      prefixIcon: Icon(Icons.description),
                                      //suffixIcon: Icon(Icons.content_copy_sharp),
                                      filled: true,
                                      fillColor: HexColor(backgroundColor),
                                      prefixIconColor: HexColor(mainColor),

                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(13)),
                                      ),
                                      focusColor: HexColor(mainColor),
                                      // hoverColor: HexColor(mainColor),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Center(
                                    child: DropdownButton<String>(
                                      value:selectParaBirimi ,
                                      items: paraBirimi.map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Center(child: Text(item,style: TextStyle(fontSize: 16),)),
                                      )).toList(),
                                      onChanged:(item)=>setState(() =>
                                      selectParaBirimi=item!

                                      ) ,
                                    ),
                                  ),
                                )

                              ],
                            ),
                          ),
                        ),
                      ),

                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13)),
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: TextField(
                            controller: descriptionController,
                            keyboardType: TextInputType.text,
                            autofocus: true,
                            // maxLines: 2,
                            //maxLength: ,
                            cursorColor: HexColor(mainColor),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: HexColor(textBorder)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(13)),
                              ),
                              //focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: HexColor(mainColor))) ,

                              labelText: 'Description(Açıklama)',
                              //hintText: 'Description',
                              //icon: Icon(Icons.add)
                              prefixIcon: Icon(Icons.description),
                              //suffixIcon: Icon(Icons.content_copy_sharp),
                              filled: true,
                              fillColor: HexColor(backgroundColor),
                              prefixIconColor: HexColor(mainColor),

                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(13)),
                              ),
                              focusColor: HexColor(mainColor),
                              // hoverColor: HexColor(mainColor),
                            ),
                          ),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13)),
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: TextField(
                            controller: priceController,

                            onChanged: (deger) {
                              _price = double.parse(deger) ?? 0;
                            },

                            keyboardType: TextInputType.number,
                            autofocus: true,
                            // maxLines: 2,
                            //maxLength: ,
                            cursorColor: HexColor(mainColor),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: HexColor(textBorder)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(13)),
                              ),
                              //focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: HexColor(mainColor))) ,

                              labelText: 'Price(Fiyat)',
                              //hintText: 'Description',
                              //icon: Icon(Icons.add)
                              prefixIcon: Icon(Icons.monetization_on_outlined),
                              //suffixIcon: Icon(Icons.content_copy_sharp),
                              filled: true,
                              fillColor: HexColor(backgroundColor),
                              prefixIconColor: HexColor(mainColor),

                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(13)),
                              ),
                              focusColor: HexColor(mainColor),
                              // hoverColor: HexColor(mainColor),
                            ),
                          ),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13)),
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: TextField(
                            controller: peersController,

                            onChanged: (deger) {
                              var sonuc = int.parse(deger) ?? 0;
                              setState(() {
                                _total = sonuc * _price;
                              });

                              print(sonuc * _price);
                            },

                            keyboardType: TextInputType.number,
                            // maxLines: 2,
                            //maxLength: ,
                            cursorColor: HexColor(mainColor),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: HexColor(textBorder)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(13)),
                              ),
                              //focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: HexColor(mainColor))) ,

                              labelText: 'QTY(Adet)',
                              //hintText: 'Description',
                              //icon: Icon(Icons.add)
                              prefixIcon: Icon(Icons.add),
                              //suffixIcon: Icon(Icons.content_copy_sharp),
                              filled: true,
                              fillColor: HexColor(backgroundColor),
                              prefixIconColor: HexColor(mainColor),

                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(13)),
                              ),
                              focusColor: HexColor(mainColor),
                              // hoverColor: HexColor(mainColor),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: deviceHight / 90,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                var data={
                                  "companyto": firmaNameController.text,
                                  "description": descriptionController.text,
                                  //"image":dosya?.path??"null",// boş geçmek için
                                  "image": dosya?.path,
                                  "price": priceController.text,
                                  "peers": peersController.text,
                                  "parabirimi":selectParaBirimi,
                                  "bid":userId,


                                };
                                sendPostRequest(userId, data);


                                print("************");

                                setState(() {
                                  isTextFieldVisible = false;
                                });

                                /*
                                bool _validate =
                                    _formKey.currentState!.validate();
                                if (_validate) {
                                  _formKey.currentState!.save();
                                  String result =
                                      'Açıklama:$_description\nAdet:$_peers\nFiyat:$_price';
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(result),
                                    backgroundColor: HexColor(mainColor),
                                  ));
                                }*/
                              },
                              child: Text('EKLE')),
                          ElevatedButton(
                              onPressed: () {
                                googleAds.showInterstitialAd();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PdfPage1(),settings: RouteSettings(
                                      arguments: userId,
                                    ),));

                              },

                              child: Text("Görüntüle"))
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),

    );
  }

  Future<void> sendPostRequest(String userId, Map<String, dynamic> pdfData) async {
    print("Post Fonksiyonu");
    print("USERID: $userId");
    print("PDF Data: $pdfData");

    print("Post Fonksiyonu");
    print("USERID:"+userId);
    //print(dosya);

    var response = await http.post(Uri.parse("https://easylist-vyor.onrender.com/api/user/addPdf/$userId"),
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(pdfData));
    print("USERID:"+userId);
    print( response.statusCode);
    if (response.statusCode == 201) {
      print('PDF eklendi.');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Ürün Başarıyla Listeye Eklendi!",
          style: TextStyle(color: Colors.white),
        ),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Resim ve tüm alanların  eklenmesi zorunludur.!",
            style: TextStyle(color: Colors.white),
          )));
    }
    print("PARABİRİMİ: "+selectParaBirimi);
    print("USERID:"+userId);

    descriptionController.text = "";
    priceController.text = "";
    peersController.text = "";
    dosya != "";


  }
  Future<void> sendPostUser() async {
    var response = await http.post(Uri.parse(urlUserGet),
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(<String, dynamic>{
          //"name": FirebaseFirestore.instance.doc(uid).get().then((gelenveri){gelenveri.data()!['name'];}),
          "id":uid

        }));

    if (response.statusCode == 200) {
      print("TEEEEEEST");
      print(uid);
     // print(FirebaseFirestore.instance.doc(uid).get().then((gelenveri){gelenveri.data()!['name'];}));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,

        content: Text(
          "Kişi Başarıyla Listeye Eklendi!",
          style: TextStyle(color: Colors.white),
        ),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Resim ve tüm alanların  eklenmesi zorunludur.!",
            style: TextStyle(color: Colors.white),
          )));
    }
  }

  Future<String> addList(ListProducts newList) async {
    final response = await http.post(
      Uri.parse(urlListAdd),
      //headers: <String, String>{"Content-Type": "application/json;charset=UTF-8"},
      headers: <String, String>{
        'Content-Type': 'application/json; charset-UTF-8',
      },
      body: json.encode(newList.toJson()),
    );
    print(response.body);
    return response.body;
  }

  void saveList() {
    ListProducts newList = ListProducts(
        description: "_description", image: "ddd", price: 234, peers: 24);
    apiService.addList(newList);
  }
}
