import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_city/base/common/responsive_info.dart';
import 'package:smart_city/constant_value/const_key.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../base/app_settings/app_setting.dart';
import '../../../constant_value/const_colors.dart';
import '../../../constant_value/const_fonts.dart';
import '../../../l10n/l10n_extention.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  bool enable = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
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
            Center(
              child: Image.asset(
                'assets/logo1.png',
                color: Colors.black,
                height: height * 0.2,
                width: ResponsiveInfo.isTablet() ? width * 0.3 : width * 0.4,
              ),
            ),
            Center(
              child: Column(
                children: [
                  // Text(
                  //   'Smart City Signals',
                  //   style: ConstFonts().copyWithHeading(color: Colors.black,
                  //   fontSize:  ResponsiveInfo.isTablet() ? 40 : 30),
                  // ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     setState(() {
                  //       enable = true;
                  //     });
                  //   },
                  //   child: Text('Contact us'),
                  // ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     setState(() {
                  //       enable = false;
                  //     });
                  //   },
                  //   child: Text('App Info'),
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _infoCard(
              key: const ValueKey("contactCard"), // Unique key for "Contact us"
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
              key: const ValueKey("appInfoCard"), // Unique key for "App Info"
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

  Widget _infoCard({
    required String title,
    required List<Map<String, String>> items,
    Key? key,
  }) {
    return Card(
      key: key, // Unique key for AnimatedSwitcher
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
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
