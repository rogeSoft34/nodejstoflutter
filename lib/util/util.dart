import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nodejstoflutter/listadd.dart';
import 'package:nodejstoflutter/model/list_products.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../services/api_service.dart';

APIService apiService = APIService();

Future<Uint8List> generatePdf(final PdfPageFormat format,String userId,context) async {
  print("*********UserId: $userId");

  final List<ListProducts> data = await apiService.getListProduct(userId);

  print("UserId: $userId");
  if (data.isEmpty) {
    final emptyDoc = pw.Document();
    final emptyPdfBytes = await emptyDoc.save();

    showDialog(
      context:context , // Burada "context" uygun bir BuildContext olmalı
      builder: (context) => AlertDialog(
        title: Text("Boş Liste"),
        content: Text("Görüntülemek için en az 1 ürün eklemelisiniz.Ürün listeniz boş"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Listadd(),settings: RouteSettings(
                arguments: userId,
              ),), (route) => false);
               // Uyarıyı kapat
            },
            child: Text("Tamam"),
          ),
        ],
      ),

    );
    return Uint8List.fromList(emptyPdfBytes);  }


  final doc = pw.Document(title: 'EasyList');

  // Sayfa ekleyerek içeriği oluştur
  /*doc.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Text('Merhaba Dünya!'),
        );
      },
    ),
  );*/

  final font = await PdfGoogleFonts.nunitoBold();
  final logoImage = pw.MemoryImage((await rootBundle.load(
    'lib/assets/images/rogeKare.png',
  ))
      .buffer
      .asUint8List());
  final footerImage = pw.MemoryImage(
      (await rootBundle.load('lib/assets/images/rogeKare.png'))
          .buffer
          .asUint8List());
  final pageTheme = await _myPageTheme(format);

  final Future<pw.Widget> tableWidgetFuture = customTable(data);
  final pw.Widget tableWidget = await tableWidgetFuture;

  doc.addPage(pw.MultiPage(
      pageTheme: pageTheme,
      header: (final context) => pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Text("FIRMA ADI:"+data[0].companyto.toString(),style: pw.TextStyle(font:font)),
                pw.Text("TARIH:"+DateFormat("dd/MM/yyyy").format(data[0].datetime!)),
              ]),
          pw.Image(
              alignment: pw.Alignment.topCenter,
              logoImage,
              fit: pw.BoxFit.contain,
              width: 80),
          pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.BarcodeWidget(
                  data: 'info@rogesoft.com',
                  width: 49,
                  height: 49,
                  barcode: pw.Barcode.qrCode(),
                  drawText: false,
                ),
                pw.Padding(padding: pw.EdgeInsets.zero)
              ])
        ]
      ),
      footer: (final context) =>
          pw.Image(footerImage, fit: pw.BoxFit.scaleDown, width: 80),
      build: (final context) => [
            pw.Container(
                padding: pw.EdgeInsets.only(left: 30, bottom: 0),
                child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Padding(padding: pw.EdgeInsets.only(top: 20)),
                    ])),
            pw.Center(
                child:
                pw.Text(data[0].companyto.toString()+' Sipariş Ürün Listesi',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(font: font,
                        fontSize: 30, fontWeight: pw.FontWeight.bold))),
            pw.SizedBox(height: 21),
            tableWidget,
          ]));
  return doc.save();
}
Future<pw.Widget> customTable(List<ListProducts> data) async {
  final font = await PdfGoogleFonts.nunitoBold();
  final Uint8List imageData =
      (await rootBundle.load('lib/assets/images/rogeKare.png'))
          .buffer
          .asUint8List();
  final List<pw.TableRow> rows = [
    // Başlık satırı
    pw.TableRow(children: [
      pw.Text('Image',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
      pw.Text('Description',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
      pw.Text('Price',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
      pw.Text('Peers',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
      pw.Text('Total',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
    ]),
    // Veri satırları
    for (var item in data)

      pw.TableRow(
          decoration: pw.BoxDecoration(
              border: pw.TableBorder(top: pw.BorderSide(width: 1),
            bottom: pw.BorderSide(width: 1),left: pw.BorderSide(width: 1),right: pw.BorderSide(width: 1)

          )),
          children: [
            pw.Container(padding: pw.EdgeInsets.only(left:4,top:4,bottom: 4),
              child:pw.Image(
                  pw.MemoryImage(await getImageBytes(item.image.toString())),
                  fit: pw.BoxFit.cover,
                  height: 40,
                  width: 40),
  ),
            pw.Container(padding:pw.EdgeInsets.only(top:16,bottom: 16),
                width: 25,
                child: pw.Text(
                  item.description.toString(),
                  maxLines: 3,
                )),
            pw.Container(padding:pw.EdgeInsets.only(top:16,bottom: 16),
                child: pw.Text(item.price.toString()+" "+item.parabirimi.toString(),style: pw.TextStyle(font:font,fontWeight:pw.FontWeight.bold)),),
           pw.Container(padding:pw.EdgeInsets.only(top:16,bottom: 16),
               child: pw.Text(item.peers.toString(),style: pw.TextStyle(font:font,fontWeight:pw.FontWeight.bold))) ,
            pw.Container(padding:pw.EdgeInsets.only(top:16,bottom: 16),child: pw.Text(style: pw.TextStyle(font:font,fontWeight: pw.FontWeight.bold),(item.peers != null && item.price != null)
                ? (item.peers! * item.price!).toString()+" "+item.parabirimi.toString()
                : 'N/A'),),

          ]),

  

  ];


  return pw.Table(
    border: const pw.TableBorder(),
    children: rows,
  );
}
Future<Uint8List> compressPdf(Uint8List inputPdf) async {
  final pdf = pw.Document();
  final logoImage = pw.MemoryImage(inputPdf);

  pdf.addPage(pw.Page(
    build: (pw.Context context) {
      return pw.Center(
        child: pw.Image(logoImage),
      );
    },
  ));

  final compressedPdfBytes = await pdf.save();

  return compressedPdfBytes;
}
Future<Uint8List> loadOriginalPdfBytes() async {
  // Orijinal PDF dosyasını yükleyecek kodu buraya ekleyin
  // Bu fonksiyonu, orijinal PDF dosyanızın bytes'larını döndürecek şekilde güncelleyin
  // Örneğin, rootBundle.load ile yükleyebilirsiniz
  final ByteData data = await rootBundle.load('lib/assets/original.pdf');
  return data.buffer.asUint8List();
}

Future<Uint8List> getImageBytes(String imagePath) async {
  final File file = File(imagePath);
  return await file.readAsBytes();
}


Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
  final logoImage = pw.MemoryImage(
      (await rootBundle.load('lib/assets/images/rogeKare.png'))
          .buffer
          .asUint8List());
  return pw.PageTheme(
      margin: pw.EdgeInsets.symmetric(
          horizontal: 1 * PdfPageFormat.cm, vertical: 0.5 * PdfPageFormat.cm),
      textDirection: pw.TextDirection.ltr,
      orientation: pw.PageOrientation.portrait,
      buildBackground: (final context) => pw.FullPage(
          ignoreMargins: true,
          child: pw.Watermark(
              angle: 20,
              child: pw.Opacity(
                  opacity: 0.2,
                  child: pw.Image(
                      alignment: pw.Alignment.center,
                      logoImage,
                      fit: pw.BoxFit.cover)))));
}

Future<void> saveAsFile(
  final BuildContext context,
  final LayoutCallback build,
  final PdfPageFormat pageFormat,
) async {
  final bytes = await build(pageFormat);
  final appDocDir = await getApplicationDocumentsDirectory();
  final appDocPath = appDocDir.path;
  final file = File('$appDocPath/document.pdf');
  print('save as file ${file.path}....');
  await file.writeAsBytes(bytes);
  await OpenFile.open(file.path);
}

void showPrintedToast(final BuildContext context) {
 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
    "Pdf Başarı ile  Oluşturuldu",
  )));
}

void showSharedToast(final BuildContext context) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text("Pdf Başarı ile  Gönderildi")));
}
void listeBosToast(final BuildContext context) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text("Listeye herhangi bir ürün eklenmemiş")));
}
