import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_city/base/app_settings/app_setting.dart';
import 'package:smart_city/base/common/responsive_info.dart';
import 'package:smart_city/base/sqlite_manager/sqlite_manager.dart';
import 'package:smart_city/base/store/shared_preference_data.dart';
import 'package:smart_city/base/widgets/button.dart';
import 'package:smart_city/base/widgets/custom_alert_dialog.dart';
import 'package:smart_city/base/widgets/popup_confirm/confirm_popup_page.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_fonts.dart';
import 'package:smart_city/controller/vehicles_bloc/vehicles_bloc.dart';
import 'package:smart_city/helpers/localizations/language_helper.dart';
import 'package:smart_city/l10n/l10n_extention.dart';
import 'package:smart_city/services/api/delete_user/delete_api.dart';
import 'package:smart_city/services/api/get_vehicle/models/get_vehicle_model.dart';
import 'package:smart_city/view/setting/component/Change_speed_unit.dart';
import 'package:smart_city/view/setting/component/about_screen.dart';
import 'package:smart_city/view/setting/component/change_language.dart';
import 'package:smart_city/view/setting/component/change_vehicle.dart';
import 'package:smart_city/view/setting/component/privacy_policy.dart';

import '../../base/widgets/user_avatar.dart';
import '../../model/user/user_detail.dart';

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
  final bool _enabledDarkTheme = AppSetting.enableDarkMode;
  bool _isFingerprintEnabled = false;
  List<String> speedUnits = ['mph', 'km/h', 'm/s'];

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
          setState(() {});
        } else if (state.blocStatus == BlocStatus.failed) {
          EasyLoading.showToast(L10nX.getStr.failed_update_vehicle);
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
              style: ConstFonts().copyWithTitle(fontSize: 25, color: Colors.white),
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
                _lineButton(
                    title: L10nX.getStr.change_password,
                    subtitle: L10nX.getStr.secure_account,
                    // icon: Icons.password_rounded,
                    assets: 'assets/images/change-password.png',
                    onPressed: () {
                      _showChangePasswordDialog();
                    }),
                FutureBuilder(
                  future: userDetail?.getVehicleTypeInfo(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return _lineButton(
                        title: L10nX.getStr.vehicle,
                        assets: 'assets/images/vehicles.png',
                        subtitle: "-",
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
                      );
                    }
                    VehicleTypeInfo? vehicleTypeInfo = snapshot.data;
                    return _lineButton(
                      title: L10nX.getStr.vehicle,
                      // icon: Icons.directions_bike_outlined,
                      assets: 'assets/images/vehicles.png',
                      subtitle: vehicleTypeInfo?.text ?? "-",
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
                    );
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
                ),
                _lineButton(
                  title: L10nX.getStr.privacy_policy,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (builder) => SimpleWebViewExample()));
                  },
                  subtitle: L10nX.getStr.view_privacy_terms,
                  // icon: Icons.policy
                  assets: 'assets/images/privacy-policy.png',
                ),
                _lineButton(
                  title: L10nX.getStr.about_app,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (builder) => AboutScreen()));
                  },
                  subtitle: L10nX.getStr.contact_info,
                  // icon: Icons.info_outline,
                  assets: 'assets/images/about-app.png',
                ),
                _lineButton(
                  title: L10nX.getStr.delete_account,
                  onPressed: () {
                    ConfirmPopupPage(
                      title: L10nX.getStr.delete_account,
                      content: L10nX.getStr.delete_account_confirm,
                      onAccept: () async {
                        DeleteUserApi registerApi = DeleteUserApi();
                        bool deleteSuccessfully = await registerApi.call();
                        if (deleteSuccessfully) {
                          await SharedPreferenceData.setLogOut();
                          SqliteManager().deleteCurrentLoginUserInfo();
                          SqliteManager().deleteCurrentLoginUserDetail();
                          SqliteManager().deleteCurrentCustomerDetail();
                          context.go("/login");
                        }
                      },
                      onCancel: () {},
                    ).show(context);
                  },
                  subtitle: L10nX.getStr.delete_account,
                  // icon: Icons.info_outline,
                  assets: 'assets/images/user_delete.png',
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
                      '${L10nX.getStr.version} ${AppSetting.version}',
                      style: ConstFonts().copyWithInformation(fontSize: 12, fontWeight: FontWeight.w300, color: ConstColors.surfaceColor),
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
    UserDetail? userDetail = SqliteManager().getCurrentLoginUserDetail();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(color: ConstColors.tertiaryColor.withOpacity(0.02), borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.centerRight,
                child: UserAvatar(fit: BoxFit.fitHeight, avatar: (userDetail != null) ? userDetail.avatar ?? "" : "", size: 80),
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
                    (userDetail != null) ? userDetail.name ?? "-" : "-",
                    style: ConstFonts().copyWithTitle(fontSize: 24, color: ConstColors.surfaceColor),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    userDetail != null && userDetail.phone!= null ? userDetail.getPhoneUsFormat() : "-",
                    style: ConstFonts().copyWithSubHeading(fontSize: 16, color: ConstColors.surfaceColor),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${userDetail != null && userDetail.email != null ? userDetail.email : "Unknown"}',
                    style: ConstFonts().copyWithSubHeading(fontSize: 16, color: ConstColors.surfaceColor),
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
    UserDetail? userDetail = SqliteManager().getCurrentLoginUserDetail();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(color: ConstColors.tertiaryColor.withOpacity(0.02), borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            UserAvatar(fit: BoxFit.fitHeight, avatar: (userDetail != null) ? userDetail.avatar ?? "" : "", size: 120),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (userDetail != null) ? userDetail.name ?? "-" : "-",
                  style: ConstFonts().copyWithTitle(fontSize: 24, color: ConstColors.surfaceColor),
                ),
                const SizedBox(height: 5),
                Text(
                  userDetail != null && userDetail.phone != null ? userDetail.getPhoneUsFormat() : "-",
                  style: ConstFonts().copyWithSubHeading(fontSize: 16, color: ConstColors.surfaceColor),
                ),
                const SizedBox(height: 5),
                Text(
                  '${userDetail != null && userDetail.email != null ? userDetail.email : "Unknown"}',
                  style: ConstFonts().copyWithSubHeading(fontSize: 16, color: ConstColors.surfaceColor),
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

  Widget _lineButton({required String title, IconData? icon, String? assets, bool? isIconUrl, String? subtitle, required Function() onPressed, Color? backgroundColor, Color? color, Widget? trailing}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(20),
          color: backgroundColor ?? ConstColors.tertiaryColor.withOpacity(0.02)),
      child: ListTile(
        leading: (icon != null)
            ? Icon(
                icon,
                color: ConstColors.primaryColor,
                size: 30,
              )
            : (isIconUrl ?? false)
                ? Image.network(
                    assets ?? "",
                    width: 30,
                    height: 30,
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
                    style: ConstFonts().copyWithTitle(fontSize: 16, color: color ?? ConstColors.surfaceColor),
                  ),
                  Text(
                    subtitle ?? "",
                    style: ConstFonts().copyWithTitle(fontWeight: FontWeight.w400, fontSize: 14, color: color ?? ConstColors.surfaceColor),
                  )
                ],
              )
            : Text(
                title,
                style: ConstFonts().copyWithTitle(fontSize: 16, color: color ?? ConstColors.surfaceColor),
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.65),
      context: context,
      builder: (context) => widget,
    );
    // Navigator.of(context).push(MaterialPageRoute(builder: (builder) => ChangeLanguage()));
  }
}
