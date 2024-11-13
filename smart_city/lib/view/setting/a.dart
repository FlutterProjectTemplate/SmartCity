import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_city/base/app_settings/app_setting.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/l10n/l10n_extention.dart';
import 'package:smart_city/model/user/user_detail.dart';
import 'package:smart_city/view/setting/component/Change_speed_unit.dart';
import 'package:smart_city/view/setting/component/change_dark_mode.dart';

import '../../base/sqlite_manager/sqlite_manager.dart';
import '../../base/store/shared_preference_data.dart';
import '../../base/widgets/custom_alert_dialog.dart';
import '../../helpers/localizations/language_helper.dart';
import 'component/change_language.dart';
import 'component/change_vehicle.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  UserDetail? userDetail = SqliteManager().getCurrentLoginUserDetail();

  @override
  Widget build(BuildContext context) {
    Locale locale = LanguageHelper().getCurrentLocale();
    String language = LanguageHelper().getDisplayName();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings',
            style: TextStyle(fontWeight: FontWeight.w600)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  context.go('/map/setting/profile');
                },
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                        child: Icon(
                          Icons.person,
                          size: 35,
                          color: ConstColors.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userDetail?.name ?? "-",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              userDetail?.email ?? "-",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () {
                          context.go('/map/setting/profile');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(),

            // Settings Groups
            _buildSettingsGroup(
              'Account',
              [
                _buildSettingItem(
                  context,
                  icon: Icons.security_outlined,
                  title: 'Security',
                  subtitle: 'Change password',
                  onTap: () {
                    _showChangePasswordDialog();
                  },
                ),
                _buildSettingItem(
                  context,
                  icon: Icons.directions_bike_outlined,
                  title: L10nX.getStr.vehicle,
                  subtitle: 'Change your vehicle',
                  onTap: () {
                    _openChangeVehicle();
                  },
                ),
              ],
            ),
            _buildSettingsGroup(
              'Preferences',
              [
                _buildSettingItem(
                  context,
                  icon: Icons.language_outlined,
                  title: 'Language',
                  subtitle: '${language} (${locale.countryCode})',
                  onTap: () {
                    _openBottomSheet(const ChangeLanguage());
                  },
                ),
                _buildSettingItem(
                  context,
                  icon: Icons.speed,
                  title: 'Speed',
                  subtitle: 'Change your speed unit (mph, km/h, m/s)',
                  onTap: () {
                    _openBottomSheet(const ChangeUnitSpeed());
                  },
                ),
                _buildSettingItem(
                  context,
                  icon: Icons.dark_mode_outlined,
                  title: 'Theme',
                  subtitle: 'Dark mode, colors',
                  onTap: () {
                    _openBottomSheet(const ChangeTheme());
                  },
                ),
              ],
            ),
            _buildSettingsGroup(
              'Support',
              [
                _buildSettingItem(
                  context,
                  icon: Icons.help_outline,
                  title: 'Privacy policy',
                  subtitle: 'Our policy',
                  onTap: () {},
                ),
                _buildSettingItem(
                  context,
                  icon: Icons.info_outline,
                  title: 'About',
                  subtitle: 'Version ${AppSetting.version}',
                  onTap: () {},
                ),
              ],
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await SharedPreferenceData.setLogOut();
                    context.go('/login');
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Log Out'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildSettingItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    return ListTile(
      leading: Icon(icon, color: ConstColors.primaryColor),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialog.changePasswordDialog();
        });
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
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.2,
        maxHeight: MediaQuery.of(context).size.height * 0.4,
      ),
      context: context,
      builder: (context) => widget,
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