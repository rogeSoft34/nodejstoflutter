import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nodejstoflutter/util/util.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart'as pw;
//import '../util/util.dart';
class PdfPage1 extends StatefulWidget {
  const PdfPage1({Key? key}) : super(key: key);

  @override
  State<PdfPage1> createState() => _PdfPage1State();
}

class _PdfPage1State extends State<PdfPage1> {
  PrintingInfo? printingInfo;


  @override
  void initState() {
    super.initState();
    _init();


  }
  Future<void>_init()async{
    final info=await Printing.info();
    setState(() {
      printingInfo=info;

    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = ModalRoute.of(context)!.settings.arguments as String;
    pw.RichText.debug=true;
    final actions=<PdfPreviewAction>[
      if(!kIsWeb)
        const PdfPreviewAction(icon:Icon(Icons.save), onPressed:saveAsFile)
    ];
    return Scaffold(
      appBar: AppBar(title: Text("PDF ÇIKTI"),),
      body: PdfPreview(
        maxPageWidth: 700,
        actions: actions,
        onPrinted:showPrintedToast ,
        onShared:showSharedToast ,


        build:(format)=>generatePdf(format,userId,context),

      ),
    );
  }
}



