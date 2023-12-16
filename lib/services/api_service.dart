import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nodejstoflutter/constants/api_constanst.dart';
import 'package:nodejstoflutter/model/list_products.dart';

class APIService {

  Future<List<Map<String, dynamic>>> getPdfList(String userId) async {
    final response = await http.get(
      Uri.parse('https://easylist-vyor.onrender.com/api/user/getPdfList/$userId'),
    );

    if (response.statusCode == 200) {
      // JSON verisini dönüştür
      final List<dynamic> data = json.decode(response.body);

      // Liste içindeki her bir öğeyi Map'e dönüştür
      List<Map<String, dynamic>> pdfList = data.map((item) {
        return Map<String, dynamic>.from(item);
      }).toList();

      return pdfList;
    } else {
      throw Exception('PDF listesi alınamadı.');
    }
  }

  Future<List<ListProducts>> getListProduct(String userId) async {
    print("BID=> ${userId}");
    final response = await http.get(Uri.parse('https://easylist-vyor.onrender.com/api/user/getPdfListByBid/$userId'));
    if (response.statusCode == 200) {
      // Başarılı bir şekilde alındı, JSON'u dönüştür ve listeyi oluştur
      List<ListProducts> listProduct = [];
      List<dynamic> responseList = jsonDecode(response.body);

      for (var i = 0; i < responseList.length; i++) {
        listProduct.add(ListProducts.fromJson(responseList[i]));
      }

      print("Başarılı bir şekilde alındı.");
      return listProduct;
    } else {
      // Başarısız durum kodu, hata mesajını yazdır
      print("Hata Kodu: ${response.statusCode}");
      print("Hata Mesajı: ${response.body}");
      throw Exception("PDF listesini alma başarısız oldu");
    }
  }
  Future<String> addList(ListProducts newList) async {
    final response = await http.post(
      Uri.parse(urlListAdd),
      //headers: <String, String>{"Content-Type": "application/json;charset=UTF-8"},
      headers: <String, String>{'Content-Type': 'application/json; charset-UTF-8', },
      body: json.encode(newList.toJson()),
    );
    print(response.body);
    return response.body;
  }
  void deleteAllItems() async {
    final response = await http.delete(
      Uri.parse(urlListDelete),
    );

    if (response.statusCode == 200) {
      print('Tüm öğeler başarıyla silindi.');
    } else {
      print('Hata: ${response.reasonPhrase}');
    }
  }

  Future<void> deletePdf(String bid) async {
    print("BİD=>"+bid);
    final response = await http.delete(
      Uri.parse('https://easylist-vyor.onrender.com/api/user/deletePdf/$bid'),
    );
    print("Status Code=>${response.statusCode}");

    if (response.statusCode == 200) {
      print('PDF başarıyla silindi.');
    } else {
      print('PDF silme hatası: ${response.statusCode}');
    }
  }
  Future<void> deletePruduct(String id) async {
    print("İD=>"+id);
    final response = await http.post(
      Uri.parse('https://easylist-vyor.onrender.com/api/user/listitemdelete/$id'),
      //Uri.parse('http://192.168.1.47/api/user/listitemdelete/$id'),
        //print('https://easylist-vyor.onrender.com/api/user/listitemdelete/$id');
    );
    print("Status Code=>${response.statusCode}");

    if (response.statusCode == 200) {
      print('Ürün başarıyla silindi.');
    } else {
      print('Ürün silme hatası: ${response.statusCode}');
    }
  }




  Future<double?> getTotalAmount(String bid) async {
    final response = await http.get(Uri.parse('https://easylist-vyor.onrender.com/api/user/getTotalAmount/$bid'));

    if (response.statusCode == 200) {
      List<dynamic> responseBody = json.decode(response.body);

      if (responseBody.isNotEmpty) {
        Map<String, dynamic> result = responseBody[0];

        if (result.containsKey('totalAmount')) {
          double totalAmount = result['totalAmount']?.toDouble();
          print('Toplam Tutar: $totalAmount');
          return totalAmount;
        } else {
          print('totalAmount anahtarı bulunamadı.');
        }
      } else {
        print('Liste boş.');
      }
    } else {
      print('Hata Kodu: ${response.statusCode}');
      print('Hata Mesajı: ${response.body}');
    }

    return null;
  }

}

