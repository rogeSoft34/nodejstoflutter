import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nodejstoflutter/model/list_products.dart';
import 'package:nodejstoflutter/services/api_service.dart';


class ListEdit extends StatefulWidget {
  const ListEdit({super.key});

  @override
  State<ListEdit> createState() => _ListEditState();
}

class _ListEditState extends State<ListEdit> {
  APIService apiService = APIService();

  @override
  Widget build(BuildContext context) {
    final userId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(centerTitle: true,
        title: Text("Liste Düzenleme"),
      ),
      body: FutureBuilder<List<ListProducts>>(
        future: apiService.getListProduct(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("Veri çekme hatası: ${snapshot.error}");
          } else {
            List<ListProducts> data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length == 0 ? 1 : data.length, // Eğer data boşsa itemCount'ı 1 yap
              itemBuilder: (context, index) {
                if (data.isEmpty) {
                  // Eğer data boşsa, boş liste mesajını göster
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        'Liste boş',
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                      ),
                    ),
                  );
                } else {
                  // Eğer data doluysa, normal ListTile'ı göster
                  return Card(
                    child: ListTile(
                      title: Center(
                        child: Text(
                          data[index].description.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      leading: FutureBuilder<Uint8List>(
                        future: getImageBytes(data[index].image.toString()),
                        builder: (context, imageSnapshot) {
                          if (imageSnapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (imageSnapshot.hasError) {
                            return Text("Resim yükleme hatası: ${imageSnapshot.error}");
                          } else {
                            return Image(
                              image: MemoryImage(imageSnapshot.data!),
                              height: 70,
                              width: 70,
                              fit: BoxFit.cover,
                            );
                          }
                        },
                      ),
                      subtitle: Center(
                        child: Text(
                          "Fiyat:${data[index].price.toString()}${data[index].parabirimi.toString()}  Adet:${data[index].peers.toString()}",
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete,color: Colors.redAccent,),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Ürününüz silinecektir"),
                              content: Text("Silmek istediğinizden emin misiniz."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    apiService.deletePruduct(data[index].id.toString());
                    
                                    setState(() {
                                      data.removeAt(index);
                                    });
                    
                                    // Uyarıyı kapat
                                    Navigator.of(context).pop(); // Dialog penceresini kapat
                                  },
                                  child: Text("Tamam"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}Future<Uint8List> getImageBytes(String imagePath) async {
  final File file = File(imagePath);
  return await file.readAsBytes();
}