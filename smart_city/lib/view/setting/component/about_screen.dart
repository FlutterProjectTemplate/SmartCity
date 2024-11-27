import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_city/constant_value/const_key.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../base/app_settings/app_setting.dart';
import '../../../constant_value/const_colors.dart';
import '../../../constant_value/const_fonts.dart';
import '../../../l10n/l10n_extention.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.onPrimaryColor,
      appBar: AppBar(
        backgroundColor: ConstColors.tertiaryContainerColor,
        title: Text(
          L10nX.getStr.about_app,
          style: ConstFonts().copyWithTitle(fontSize: 25, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoCard(
              title: "Contact us",
              items: [
                {'label': 'Company', 'value': constInfo.company},
                {'label': 'Contact', 'value': constInfo.emailContact},
                {'label': 'Phone', 'value': constInfo.phone},
                {'label': 'Website', 'value': constInfo.website},
              ],
            ),
            const SizedBox(height: 20),
            _infoCard(
              title: L10nX.getStr.about_app,
              items: [
                {'label': 'Version', 'value': AppSetting.version},
                {'label': 'Developed by', 'value': constInfo.developedBy},
                {'label': 'Release Date', 'value': constInfo.releaseDate},
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(
      {required String title, required List<Map<String, String>> items}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: ConstFonts().copyWithTitle(
                fontSize: 20,
                color: ConstColors.primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            ...items
                .map((item) => _infoRow(item['label']!, item['value']!))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: ConstFonts().copyWithSubHeading(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          if (label.toLowerCase() == 'website')
            GestureDetector(
              onTap: () => _launchURL(value),
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.blue,
                ),
              ),
            )
          else
            Text(
              value,
              style: ConstFonts().copyWithSubHeading(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    final uri = Uri.parse('$url');
    // if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    // } else {
    //   throw 'Could not launch $url';
    // }
  }
}
