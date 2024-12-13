import 'package:flutter/services.dart';
import 'package:phone_number_text_input_formatter/phone_number_text_input_formatter.dart';

class googleMapApi {
  static const String key = "AIzaSyBqgoZTlVMY8IXaDuQix7TjCsX47zrMh3Q";
}

class ConstInfo {
  static const String releaseDate = "November 2024";
  static const String developedBy = "Smart city Signals";
  static const String company = "Smart city Signals";
  static const String emailContact = "admin@smartcitysignals.com";
  // static const String location = "AIzaSyBqgoZTlVMY8IXaDuQix7TjCsX47zrMh3Q";
  static const String phone = "+1 (408) 916‑8141";
  static const String website = "https://www.smartcitysignals.com/";
  static List<TextInputFormatter>? inputFormattersUSPhoneFormat = [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
    const NationalPhoneNumberTextInputFormatter(
      prefix: '',
      countryCode: '',
      groups: [
        (length: 3, leading: ' (', trailing: ') '),
        (length: 3, leading: '', trailing: '-'),
        (length: 4, leading: '', trailing: ' '),
      ],
    ),
  ];
}