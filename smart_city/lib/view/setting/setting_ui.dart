import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_city/base/common/responsive_info.dart';
import 'package:smart_city/base/instance_manager/instance_manager.dart';
import 'package:smart_city/base/sqlite_manager/sqlite_manager.dart';
import 'package:smart_city/base/store/shared_preference_data.dart';
import 'package:smart_city/base/widgets/button.dart';
import 'package:smart_city/base/widgets/custom_alert_dialog.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_fonts.dart';
import 'package:smart_city/model/user/user_info.dart';

class SettingUi extends StatefulWidget {
  const SettingUi({super.key});

  @override
  State<SettingUi> createState() => _SettingUiState();
}

class _SettingUiState extends State<SettingUi> {
  String _selectedLanguage = 'English';
  final List<String> _languages = ['English', 'Spanish', 'French', 'German'];
  bool _isFingerprintEnabled=false;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstColors.surfaceColor,
        title: Text('Setting',style: ConstFonts().copyWithTitle(fontSize: 25),),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white,size: 25,),
          onPressed: () {
            context.go('/map');
          },
        ),
      ),
      backgroundColor: ConstColors.surfaceColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15,top: 5,bottom: 15),
              child: Text("General",style: ConstFonts().copyWithTitle(fontSize: 20,color: ConstColors.tertiaryColor),),
            ),
            _lineButton(title: "Language", icon:Icons.language, onPressed:(){},
              trailing: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: ConstColors.surfaceColor,
                  value: _selectedLanguage,
                  items: _languages.map((String language) {
                    return DropdownMenuItem<String>(
                      value: language,
                      child: Text(language,style: ConstFonts().copyWithTitle(fontSize: 17)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLanguage = newValue!;
                    });
                  },
                ),
              ),
            ),
            _lineButton(title: "Sign in with fingerprint", icon: Icons.fingerprint_rounded, onPressed: (){},
            trailing: Switch(
              value: _isFingerprintEnabled,
              activeTrackColor: ConstColors.primaryColor,
              activeColor: Colors.white,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: ConstColors.tertiaryColor,
              onChanged: (bool newValue)async{
                if (newValue) {
                  bool authenticated = await SqliteManager.getInstance.authenticate();
                  if (authenticated) {
                    await SharedPreferenceData.turnOnSignInBiometric();
                    setState(() {
                      _isFingerprintEnabled = true;
                    });
                  }
                } else {
                  InstanceManager().showSnackBar(context: context, text: "Can't turn of sign in with biometric");
                  setState(() {
                    _isFingerprintEnabled = false;
                  });
                }
              },
            )),
            _lineButton(title: "Add widget",icon:  Icons.widgets_rounded,onPressed: (){}),
            Padding(
              padding: const EdgeInsets.only(left: 15,top: 5,bottom: 15),
              child: Text("Account",style: ConstFonts().copyWithTitle(fontSize: 20,color: ConstColors.tertiaryColor),),
            ),
            _lineButton(title: "Your profile",icon:  Icons.person, onPressed: ()async{
              UserInfo? userInfo = await SqliteManager.getInstance.getCurrentLoginUserInfo();
              context.go('/map/setting/profile',extra: userInfo);
            }),
            _lineButton(title: "Change your password",icon:  Icons.password_rounded,onPressed:  (){_showChangePasswordDialog();}),
            Padding(
              padding: const EdgeInsets.only(left: 15,top: 5,bottom: 15),
              child: Text("Support us",style: ConstFonts().copyWithTitle(fontSize: 20,color: ConstColors.tertiaryColor),),
            ),
            _lineButton(title: "Feedback",icon:  Icons.mail_rounded,onPressed: (){}),
            _lineButton(title: "Rate this app", icon: Icons.star_rate_rounded, onPressed: (){}),
            _lineButton(title: "Privacy policy", icon: Icons.privacy_tip_rounded,onPressed: (){}),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: ()async{
                await SharedPreferenceData.setLogOut();
                ResponsiveInfo.isTablet()?context.go('/'):context.go('/login');
              },
              child: Center(
                  child: Button(width: width-50, height: 50, color: ConstColors.primaryColor, isCircle: false, child: Text("Log out",style:ConstFonts().copyWithTitle(fontSize: 18))).getButton()),
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

  void _showChangePasswordDialog(){
    showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog.changePasswordDialog();
      }
    );
  }

  Widget _lineButton({required String title,required IconData icon,required Function() onPressed,Widget? trailing}){
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: ListTile(
        leading: Icon(icon,color: ConstColors.secondaryColor,size: 30,),
        title: Text(title,style: ConstFonts().copyWithTitle(fontSize: 16),),
        trailing: trailing,
        onTap: onPressed,
      ),
    );
  }
}
