import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class ConstFonts{
  final TextStyle heading = GoogleFonts.outfit(fontSize:40,fontWeight: FontWeight.w500,color: Colors.white);
  TextStyle copyWithHeading({double? fontSize,FontWeight? fontWeight,Color? color}){
    return GoogleFonts.outfit(fontSize: fontSize??heading.fontSize,fontWeight: fontWeight??heading.fontWeight,color: color??heading.color);
  }
  final TextStyle subHeading = GoogleFonts.outfit(fontSize:22,fontWeight: FontWeight.w300,color: Colors.white);
  TextStyle copyWithSubHeading({double? fontSize,FontWeight? fontWeight,Color? color}){
    return GoogleFonts.outfit(fontSize: fontSize??subHeading.fontSize,fontWeight: fontWeight??subHeading.fontWeight,color: color??subHeading.color);
  }
  final TextStyle onPrimaryContainerFonts = GoogleFonts.outfit(fontSize:20,fontWeight: FontWeight.w400,color: Colors.white);
  final TextStyle onPrimaryFonts = GoogleFonts.outfit(fontSize:16,fontWeight: FontWeight.w400,color: Colors.white);
  final TextStyle title = GoogleFonts.outfit(fontSize:18,fontWeight: FontWeight.w500,color: Colors.white);
  TextStyle copyWithTitle({double? fontSize,FontWeight? fontWeight,Color? color}){
    return GoogleFonts.outfit(fontSize: fontSize??title.fontSize,fontWeight: fontWeight??title.fontWeight,color: color??title.color);
  }
}