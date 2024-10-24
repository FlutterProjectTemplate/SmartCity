import 'package:flutter/material.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

enum PdfType { link, asset }

class PdfScreen extends StatefulWidget {
  final String link;
  final String name;
  PdfType? pdfType;

  PdfScreen({super.key, required this.link, required this.name, this.pdfType}) {
    pdfType = pdfType ?? PdfType.link;
  }

  @override
  _PdfScreenState createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.close,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        // backgroundColor: ConstColors.primaryColor,
        centerTitle: true,
        title: Text(
          widget.name,
          style: const TextStyle(
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: widget.pdfType == PdfType.link
          ? SfPdfViewer.network(widget.link)
          : SfPdfViewer.asset(widget.link),
    );
  }
}
