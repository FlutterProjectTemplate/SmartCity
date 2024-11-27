import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_city/base/app_settings/app_setting.dart';
import 'package:smart_city/base/common/responsive_info.dart';
import 'package:smart_city/base/routes/routes.dart';
import 'package:smart_city/base/sqlite_manager/sqlite_manager.dart';
import 'package:smart_city/base/store/shared_preference_data.dart';
import 'package:smart_city/base/widgets/button.dart';
import 'package:smart_city/base/widgets/custom_alert_dialog.dart';
import 'package:smart_city/base/widgets/custom_container.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_fonts.dart';
import 'package:smart_city/controller/vehicles_bloc/vehicles_bloc.dart';
import 'package:smart_city/helpers/localizations/app_notifier.dart';
import 'package:smart_city/helpers/localizations/bloc/main.exports.dart';
import 'package:smart_city/helpers/localizations/language_helper.dart';
import 'package:smart_city/l10n/l10n_extention.dart';
import 'package:smart_city/view/setting/component/Change_speed_unit.dart';
import 'package:smart_city/view/setting/component/about_screen.dart';
import 'package:smart_city/view/setting/component/change_language.dart';
import 'package:smart_city/view/setting/component/change_vehicle.dart';
import 'package:smart_city/view/setting/component/privacy_policy.dart';
import 'package:smart_city/view/setting/component/profile_screen.dart';

import '../../base/instance_manager/instance_manager.dart';
import '../../base/widgets/user_avatar.dart';
import '../../model/user/user_detail.dart';
import '../../model/user/user_info.dart';
import 'component/country_flag.dart';
import 'component/pdf_screen.dart';

class SettingUi extends StatefulWidget {
  final VehiclesBloc? vehiclesBloc;

  const SettingUi({
    super.key,
    required this.vehiclesBloc,
  });

  @override
  State<SettingUi> createState() => _SettingUiState();
}

class _SettingUiState extends State<SettingUi> {
  final Color color = Color.fromRGBO(243, 243, 243, 1.0).withOpacity(0.5);
  bool _enabledDarkTheme = AppSetting.enableDarkMode;
  bool _isFingerprintEnabled = false;
  List<String> speedUnits = ['mph', 'km/h', 'm/s'];
  final Map<VehicleType, String> transportString = {
    for (int i = 0; i < VehicleType.values.length; i++)
      VehicleType.values[i]:
          InstanceManager().getVehicleString(VehicleType.values[i]),
  };
  final Map<VehicleType, String> transport = InstanceManager().getTransport();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    // vehiclesBloc.add(OnChangeVehicleEvent(VehicleType.bicycle));

    UserDetail? userDetail = SqliteManager().getCurrentLoginUserDetail();
    Locale locale = LanguageHelper().getCurrentLocale();
    String language = LanguageHelper().getDisplayName();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocConsumer<VehiclesBloc, VehiclesState>(
      bloc: widget.vehiclesBloc,
      listener: (context, state) {
        if (state.blocStatus == BlocStatus.success) {
          setState(() {

          });
        } else if (state.blocStatus == BlocStatus.failed) {
          EasyLoading.showToast('Failed to update vehicle');
        } else {
          print(state.blocStatus.toString());
        }
      },
      builder: (context, state) {
        return Scaffold(
          extendBody: true,
          backgroundColor: ConstColors.onPrimaryColor,
          appBar: AppBar(
            backgroundColor: ConstColors.tertiaryContainerColor,
            title: Text(
              L10nX.getStr.settings,
              style:
                  ConstFonts().copyWithTitle(fontSize: 25, color: Colors.white),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 25,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          // backgroundColor: ConstColors.tertiaryColor,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                ResponsiveInfo.isPhone() ? buildMobileInfo() : buildTabletInfo(),
                const SizedBox(height: 20),
                Column(
                  children: [
                    _lineButton(
                        title: L10nX.getStr.your_profile,
                        subtitle: "Change your information",
                        // icon: Icons.person,
                        assets: 'assets/images/user.png',
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => ProfileScreen()));
                          // _showUpdateProfile();
                        }),
                    _lineButton(
                        title: L10nX.getStr.language,
                        // icon: Icons.language,
                        assets: 'assets/images/languages.png',
                        subtitle: '${language} (${locale.countryCode})',
                        // assets: 'assets/images/language.png',
                        onPressed: () {
                          _openBottomSheet(ChangeLanguage());
                        },
                        trailing: CountryFlag(
                          countryCode:
                              LanguageHelper().getCurrentLocale().countryCode!,
                        )
                        ),
                  ],
                ),
                _lineButton(
                    title: L10nX.getStr.change_password,
                    subtitle: "Secure your account",
                    // icon: Icons.password_rounded,
                    assets: 'assets/images/change-password.png',
                    onPressed: () {
                      _showChangePasswordDialog();
                    }),
                _lineButton(
                  title: L10nX.getStr.vehicle,
                  // icon: Icons.directions_bike_outlined,
                  assets: 'assets/images/vehicles.png',
                  subtitle: userDetail != null
                      ? transportString[state.vehicleType] ?? "unknown"
                      : "-",
                  onPressed: () {
                    _openBottomSheet(ChangeVehicle(
                      vehiclesBloc: widget.vehiclesBloc!,
                      onChange: (type) {
                        if (type != null) {
                          setState(() {});
                        }
                      },
                    ));
                  },
                ),
                _lineButton(
                  title: L10nX.getStr.change_speed_unit,
                  subtitle: AppSetting.getSpeedUnit,
                  // icon: Icons.speed,
                  assets: 'assets/images/speed-unit.png',
                  onPressed: () {
                    _openBottomSheet(ChangeUnitSpeed(
                      onChange: (check) {
                        if (check) {
                          setState(() {});
                        }
                      },
                    ));
                  },
                  // trailing: DropdownButtonHideUnderline(
                  //   child: DropdownButton<String>(
                  //     dropdownColor: ConstColors.onPrimaryColor,
                  //     value: AppSetting.getSpeedUnit,
                  //     items: speedUnits.map((unit) {
                  //       return DropdownMenuItem<String>(
                  //         value: unit,
                  //         child: Text(
                  //           unit,
                  //           style: ConstFonts().copyWithTitle(
                  //               fontSize: 17, color: ConstColors.surfaceColor),
                  //         ),
                  //       );
                  //     }).toList(),
                  //     onChanged: (String? newValue) {
                  //       setState(() {
                  //         SqliteManager()
                  //             .setStringForKey('speedUnit', newValue ?? '');
                  //         context
                  //             .read<MainBloc>()
                  //             .add(MainChangeDarkModeEvent());
                  //       });
                  //     },
                  //   ),
                  // ),
                ),
                _lineButton(
                  title: L10nX.getStr.privacy_policy,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => SimpleWebViewExample()));
                  },
                  subtitle: "View our privacy terms",
                  // icon: Icons.policy
                  assets: 'assets/images/privacy-policy.png',
                ),
                _lineButton(
                  title: L10nX.getStr.about_app,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (builder) => AboutScreen()));
                  },
                  subtitle: "Contact email, Phone number",
                  // icon: Icons.info_outline,
                  assets: 'assets/images/about-app.png',
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    await SharedPreferenceData.setLogOut();
                    context.go('/login');
                  },
                  child: Center(
                      child: Button(
                    width: width / 2,
                    height: 50,
                    color: ConstColors.primaryColor,
                    // gradient: LinearGradient(
                    //   colors: [
                    // Color(0xFF66A266),
                    // ConstColors.primaryColor,
                    // ConstColors.primaryContainerColor,
                    // ],
                    // stops: [0.0, 0.5, 1.0],
                    // begin: Alignment.topCenter,
                    // end: Alignment.bottomCenter,
                    // ),
                    isCircle: false,
                    child: Text(
                      L10nX.getStr.log_out,
                      style: ConstFonts().copyWithTitle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ).getButton()),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Version ${AppSetting.version}',
                      style: ConstFonts().copyWithInformation(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: ConstColors.surfaceColor),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildMobileInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
            color: ConstColors.tertiaryColor.withOpacity(0.02),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.centerRight,
                child: UserAvatar(
                    avatar: (userDetail != null)
                        ? userDetail?.avatar ?? ""
                        : "",
                    size: 80),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (userDetail != null)
                        ? userDetail?.name ?? "-"
                        : "-",
                    style: ConstFonts().copyWithTitle(
                        fontSize: 24,
                        color: ConstColors.surfaceColor),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${userDetail != null && userDetail?.phone != null ? userDetail?.phone : "-"}',
                    style: ConstFonts().copyWithSubHeading(
                        fontSize: 16,
                        color: ConstColors.surfaceColor),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${userDetail != null && userDetail?.email != null ? userDetail?.email : "Unknown"}',
                    style: ConstFonts().copyWithSubHeading(
                        fontSize: 16,
                        color: ConstColors.surfaceColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTabletInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
            color: ConstColors.tertiaryColor.withOpacity(0.02),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            UserAvatar(
                avatar: (userDetail != null)
                    ? userDetail?.avatar ?? ""
                    : "",
                size: 80),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (userDetail != null)
                      ? userDetail?.name ?? "-"
                      : "-",
                  style: ConstFonts().copyWithTitle(
                      fontSize: 24,
                      color: ConstColors.surfaceColor),
                ),
                const SizedBox(height: 5),
                Text(
                  '${userDetail != null && userDetail?.phone != null ? userDetail?.phone : "-"}',
                  style: ConstFonts().copyWithSubHeading(
                      fontSize: 16,
                      color: ConstColors.surfaceColor),
                ),
                const SizedBox(height: 5),
                Text(
                  '${userDetail != null && userDetail?.email != null ? userDetail?.email : "Unknown"}',
                  style: ConstFonts().copyWithSubHeading(
                      fontSize: 16,
                      color: ConstColors.surfaceColor),
                ),
              ],
            ),
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

  void _showUpdateProfile() {
    showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialog.updateProfileDialog();
        });
  }

  Widget _lineButton(
      {required String title,
      IconData? icon,
      String? assets,
      String? subtitle,
      required Function() onPressed,
      Color? backgroundColor,
      Color? color,
      Widget? trailing}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(20),
          color:
              backgroundColor ?? ConstColors.tertiaryColor.withOpacity(0.02)),
      child: ListTile(
        leading: (icon != null)
            ? Icon(
                icon,
                color: ConstColors.primaryColor,
                size: 30,
              )
            : Image.asset(
                assets ?? "",
                width: 30,
                height: 30,
              ),
        title: (subtitle != null)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: ConstFonts().copyWithTitle(
                        fontSize: 16, color: color ?? ConstColors.surfaceColor),
                  ),
                  Text(
                    subtitle ?? "",
                    style: ConstFonts().copyWithTitle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: color ?? ConstColors.surfaceColor),
                  )
                ],
              )
            : Text(
                title,
                style: ConstFonts().copyWithTitle(
                    fontSize: 16, color: color ?? ConstColors.surfaceColor),
              ),
        trailing: trailing ??
            Icon(
              Icons.navigate_next,
              size: 28,
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

  void _openBottomSheet(Widget widget) {
    showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      isDismissible: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.65),
      context: context,
      builder: (context) => widget,
    );
    // Navigator.of(context).push(MaterialPageRoute(builder: (builder) => ChangeLanguage()));
  }
}
