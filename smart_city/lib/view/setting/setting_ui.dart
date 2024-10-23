import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_city/base/common/responsive_info.dart';
import 'package:smart_city/base/sqlite_manager/sqlite_manager.dart';
import 'package:smart_city/base/store/shared_preference_data.dart';
import 'package:smart_city/base/widgets/button.dart';
import 'package:smart_city/base/widgets/custom_alert_dialog.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_fonts.dart';
import 'package:smart_city/helpers/localizations/language_helper.dart';
import 'package:smart_city/l10n/l10n_extention.dart';
import 'package:smart_city/model/user/user_info.dart';
import 'package:smart_city/view/setting/component/change_language.dart';
import 'package:smart_city/view/setting/component/change_vehicle.dart';

import '../../base/services/app_service.dart';
import 'component/pdf_screen.dart';

class SettingUi extends StatefulWidget {
  const SettingUi({super.key});

  @override
  State<SettingUi> createState() => _SettingUiState();
}

class _SettingUiState extends State<SettingUi> {
  final Color color = Color.fromRGBO(243, 243, 243, 1.0).withOpacity(0.5);
  bool _isFingerprintEnabled = false;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: Color.fromRGBO(243, 243, 243, 1.0),
      appBar: AppBar(
        // backgroundColor: ConstColors.tertiaryColor,
        title: Text(
          L10nX.getStr.settings,
          style: ConstFonts()
              .copyWithTitle(fontSize: 25, color: ConstColors.surfaceColor),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            // color: Colors.white,
            size: 25,
          ),
          onPressed: () {
            context.go('/map');
          },
        ),
      ),
      // backgroundColor: ConstColors.tertiaryColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 5, bottom: 15),
              child: Text(
                L10nX.getStr.general,
                style: ConstFonts().copyWithTitle(
                    fontSize: 20, color: ConstColors.surfaceColor),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  // border: Border.all(color: Colors.black38),
                  borderRadius: BorderRadius.circular(10),
                  color: color),
              child: Column(
                children: [
                  _lineButton(
                      title: L10nX.getStr.your_profile,
                      icon: Icons.person,
                      onPressed: () async {
                        UserInfo? userInfo =
                            SqliteManager.getInstance.getCurrentLoginUserInfo();
                        context.go('/map/setting/profile', extra: userInfo);
                      }),
                  _lineButton(
                      title: L10nX.getStr.vehicle,
                      icon: Icons.directions_car,
                      onPressed: () async {
                        _openChangeVehicle();
                      }),
                  _lineButton(
                    title: L10nX.getStr.language,
                    icon: Icons.language,
                    onPressed: () {
                      _openChangeLanguage();
                    },
                    trailing: Text('${LanguageHelper().getCurrentLocale()}'),
                    // trailing: DropdownButtonHideUnderline(
                    //   child: DropdownButton<Locale>(
                    //     dropdownColor: ConstColors.surfaceColor,
                    //     value: _selectedLanguage,
                    //     items: _languages.map((language) {
                    //       Locale locale =
                    //           Locale(language.languageCode, language.countryCode);
                    //       return DropdownMenuItem<Locale>(
                    //         value: locale,
                    //         child: Text(
                    //           language.languageCode.toUpperCase(),
                    //           style: ConstFonts().copyWithTitle(fontSize: 17),
                    //         ),
                    //       );
                    //     }).toList(),
                    //     onChanged: (Locale? newValue) {
                    //       setState(() {
                    //         _selectedLanguage = newValue!;
                    //         LanguageHelper().changeLanguage(
                    //           LanguageInfo(
                    //             languageIndex: newValue.languageCode == 'vi'
                    //                 ? LANGUAGE_INDEX.VIETNAMESE
                    //                 : LANGUAGE_INDEX.ENGLISH,
                    //           ),
                    //           context,
                    //         );
                    //       });
                    //     },
                    //   ),
                    // ),
                  ),
                ],
              ),
            ),
            // _lineButton(
            //     title: L10nX.getStr.sign_in_fingerprint,
            //     icon: Icons.fingerprint_rounded,
            //     onPressed: () {},
            //     trailing: Switch(
            //       value: _isFingerprintEnabled,
            //       activeTrackColor: ConstColors.primaryColor,
            //       activeColor: Colors.white,
            //       inactiveThumbColor: Colors.white,
            //       inactiveTrackColor: ConstColors.tertiaryColor,
            //       onChanged: (bool newValue) async {
            //         if (newValue) {
            //           bool authenticated =
            //               await SqliteManager.getInstance.authenticate();
            //           if (authenticated) {
            //             await SharedPreferenceData.turnOnSignInBiometric();
            //             setState(() {
            //               _isFingerprintEnabled = true;
            //             });
            //           } else {
            //             InstanceManager().showSnackBar(
            //                 context: context,
            //                 text:
            //                     L10nX.getStr.authentication_biometric_failure);
            //           }
            //         } else {
            //           try {
            //             await SharedPreferenceData.turnOffSignInBiometric();
            //             InstanceManager().showSnackBar(
            //                 context: context,
            //                 text: L10nX.getStr.turn_off_sign_in_with_biometric);
            //             setState(() {
            //               _isFingerprintEnabled = false;
            //             });
            //           } catch (e) {
            //             InstanceManager().showSnackBar(
            //                 context: context,
            //                 text: L10nX
            //                     .getStr.cant_turn_off_sign_in_with_biometric);
            //           }
            //         }
            //       },
            //     )),

            // BlocBuilder<VehiclesBloc, VehiclesState>(builder: (context, state) {
            //   return _lineButton(
            //       title: state.vehicleType == VehicleType.pedestrians
            //           ? L10nX.getStr.switch_to_cyclist
            //           : L10nX.getStr.switch_to_pedestrian,
            //       icon: state.vehicleType == VehicleType.pedestrians
            //           ? Icons.directions_walk_rounded
            //           : Icons.directions_bike_rounded,
            //       onPressed: () {},
            //       trailing: Switch(
            //         value: state.vehicleType == VehicleType.cyclists,
            //         activeTrackColor: ConstColors.primaryColor,
            //         activeColor: Colors.white,
            //         inactiveThumbColor: Colors.white,
            //         inactiveTrackColor: ConstColors.tertiaryColor,
            //         onChanged: (bool newValue) async {
            //           if (newValue) {
            //             context.read<VehiclesBloc>().add(CyclistsEvent());
            //           } else {
            //             context.read<VehiclesBloc>().add(PedestriansEvent());
            //           }
            //         },
            //       ));
            // }),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 5, bottom: 15),
              child: Text(
                L10nX.getStr.about_app,
                style: ConstFonts().copyWithTitle(
                    fontSize: 20, color: ConstColors.surfaceColor),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.black38),
                borderRadius: BorderRadius.circular(10),
                color: color,
              ),
              child: Column(
                children: [
                  _lineButton(
                      title: L10nX.getStr.change_password,
                      icon: Icons.password_rounded,
                      onPressed: () {
                        _showChangePasswordDialog();
                      }),
                  _lineButton(
                      title: L10nX.getStr.notifications,
                      icon: Icons.notifications,
                      onPressed: () {},
                      trailing: Switch(
                        value: _isFingerprintEnabled,
                        activeTrackColor: ConstColors.primaryColor,
                        activeColor: Colors.white,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: ConstColors.tertiaryColor,
                        onChanged: (bool newValue) async {
                          // if (newValue) {
                          //   bool authenticated =
                          //       await SqliteManager.getInstance.authenticate();
                          //   if (authenticated) {
                          //     await SharedPreferenceData.turnOnSignInBiometric();
                          //     setState(() {
                          //       _isFingerprintEnabled = true;
                          //     });
                          //   } else {
                          //     InstanceManager().showSnackBar(
                          //         context: context,
                          //         text:
                          //             L10nX.getStr.authentication_biometric_failure);
                          //   }
                          // } else {
                          //   try {
                          //     await SharedPreferenceData.turnOffSignInBiometric();
                          //     InstanceManager().showSnackBar(
                          //         context: context,
                          //         text: L10nX.getStr.turn_off_sign_in_with_biometric);
                          //     setState(() {
                          //       _isFingerprintEnabled = false;
                          //     });
                          //   } catch (e) {
                          //     InstanceManager().showSnackBar(
                          //         context: context,
                          //         text: L10nX
                          //             .getStr.cant_turn_off_sign_in_with_biometric);
                          //   }
                          // }
                          setState(() {
                            _isFingerprintEnabled = newValue;
                          });
                        },
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 5, bottom: 15),
              child: Text(
                L10nX.getStr.about_app,
                style: ConstFonts().copyWithTitle(
                    fontSize: 20, color: ConstColors.surfaceColor),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.black38),
                borderRadius: BorderRadius.circular(10),
                color: color,
              ),
              child: Column(
                children: [
                  _lineButton(
                      title: L10nX.getStr.feedback,
                      icon: Icons.mail_rounded,
                      onPressed: () {
                        AppService()
                            .openEmailSupport('IdentifierConst.supportEmail');
                      }),
                  _lineButton(
                      title: L10nX.getStr.rate_this_app,
                      icon: Icons.star_rate_rounded,
                      onPressed: () {
                        // AppService().launchAppReview(context);
                      }),
                  _lineButton(
                      title: L10nX.getStr.privacy_policy,
                      icon: Icons.privacy_tip_rounded,
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (builder) {
                          return PdfScreen(
                              link:
                                  "assets/files/Chính sách bảo mật YAX.pdf",
                              pdfType: PdfType.asset,
                              name: L10nX.getStr.privacy_policy);
                        }));
                      }),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                await SharedPreferenceData.setLogOut();
                ResponsiveInfo.isTablet()
                    ? context.go('/')
                    : context.go('/login');
              },
              child: Center(
                  child: Button(
                          width: width - 50,
                          height: 50,
                          color: ConstColors.primaryColor,
                          isCircle: false,
                          child: Text(L10nX.getStr.log_out,
                              style: ConstFonts().copyWithTitle(fontSize: 18)))
                      .getButton()),
            )
          ],
        ),
      ),
    );
  }

  _initData() async {
    _isFingerprintEnabled = await SharedPreferenceData.checkSignInBiometric();
    setState(() {});
  }

  void _showChangePasswordDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialog.changePasswordDialog();
        });
  }

  Widget _lineButton(
      {required String title,
      required IconData icon,
      required Function() onPressed,
      Widget? trailing}) {
    return Container(
      margin: trailing == null ? EdgeInsets.only(right: 0) : EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(),
      child: ListTile(
        leading: Icon(
          icon,
          color: ConstColors.surfaceColor,
          size: 30,
        ),
        title: Text(
          title,
          style: ConstFonts()
              .copyWithTitle(fontSize: 16, color: ConstColors.surfaceColor),
        ),
        trailing: trailing ??
            Icon(
              Icons.navigate_next,
              size: 16,
              color: ConstColors.surfaceColor,
            ),
        onTap: onPressed,
      ),
    );
  }

  void _openChangeLanguage() {
    showModalBottomSheet(
      enableDrag: false,
      isScrollControlled: true,
      isDismissible: false,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.50,
        maxHeight: MediaQuery.of(context).size.height * 0.95,
      ),
      context: context,
      builder: (context) => const ChangeLanguage(),
    );
    // Navigator.of(context).push(MaterialPageRoute(builder: (builder) => ChangeLanguage()));
  }

  void _openChangeVehicle() {
    showModalBottomSheet(
      enableDrag: false,
      isScrollControlled: true,
      isDismissible: false,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.50,
        maxHeight: MediaQuery.of(context).size.height * 0.95,
      ),
      context: context,
      builder: (context) => const ChangeVehicle(),
    );
    // Navigator.of(context).push(MaterialPageRoute(builder: (builder) => ChangeLanguage()));
  }
}
