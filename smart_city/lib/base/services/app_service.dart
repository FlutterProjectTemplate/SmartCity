import 'package:url_launcher/url_launcher.dart';


class AppService {
  Future openLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Fluttertoast.showToast(msg: "Can't launch the url");
    }
  }

  Future openPhoneSupport(String supportPhone) async {
    final Uri smsLaunchUri = Uri(
      scheme: 'tel',
      path: supportPhone,
      queryParameters: <String, String>{
      },
    );
    if (await canLaunchUrl(smsLaunchUri)) {
      await launchUrl(smsLaunchUri);
    } else {
      // openToast1("Can't open the email app");
    }
  }
  
  Future openEmailSupport(String supportEmail) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      query: 'subject=About ${'sss'}&body=',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // openToast1("Can't open the email app");
    }
  }

  Future<void> openGoogleMaps(String s) async {
    s.replaceAll(" ", "+");
    s.replaceAll(",", "");
    final googleMapsUrl = 'https://maps.google.com/maps?q=$s';
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch Google Maps';
    }
  }

  // Future launchAppReview(context) async {
  //   await LaunchReview.launch(androidAppId: AppConfig.androidPackageName, iOSAppId: AppConfig.iosAppID, writeReview: false);
  //   if (Platform.isIOS) {
  //     if (AppConfig.iosAppID == '000000') {
  //       openToast("The iOS version is not available on the AppStore yet");
  //     }
  //   }
  // }
}
