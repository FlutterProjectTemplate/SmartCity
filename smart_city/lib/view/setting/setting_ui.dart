import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_city/base/sqlite_manager/sqlite_manager.dart';
import 'package:smart_city/base/store/shared_preference_data.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_fonts.dart';

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15,top: 5,bottom: 15),
            child: Text("General",style: ConstFonts().copyWithTitle(fontSize: 20,color: ConstColors.tertiaryColor),),
          ),
          Row(
            children: [
              const SizedBox(width: 30),
              const Icon(Icons.language,color: ConstColors.secondaryColor,size: 30,),
              const SizedBox(width: 15),
              Text('Language',style: ConstFonts().copyWithTitle(fontSize: 16),),
              SizedBox(width: width/2.8),
              DropdownButtonHideUnderline(
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
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 30),
              const Icon(Icons.fingerprint_outlined,color: ConstColors.secondaryColor,size: 30,),
              const SizedBox(width: 15),
              Text('Sign in with fingerprint',style: ConstFonts().copyWithTitle(fontSize: 16),),
              SizedBox(width: width/5.4),
              Switch(
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
                    setState(() {
                      _isFingerprintEnabled = false;
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          _lineButton(title: "Log out", icon: Icons.logout_rounded,
              onPressed: ()async{
                context.go('/login');
                await SharedPreferenceData.setLogOut();
          }),
          Padding(
            padding: const EdgeInsets.only(left: 15,top: 5,bottom: 15),
            child: Text("Account",style: ConstFonts().copyWithTitle(fontSize: 20,color: ConstColors.tertiaryColor),),
          ),
          _lineButton(title: "Your profile",icon:  Icons.person, onPressed: (){}),
          _lineButton(title: "Change your password",icon:  Icons.password_rounded,onPressed:  (){}),
          Padding(
            padding: const EdgeInsets.only(left: 15,top: 5,bottom: 15),
            child: Text("Term of service",style: ConstFonts().copyWithTitle(fontSize: 20,color: ConstColors.tertiaryColor),),
          ),
          _lineButton(title: "Support",icon:  Icons.support_agent_rounded,onPressed: (){}),
          _lineButton(title: "Copyright", icon: Icons.copyright_rounded,onPressed: (){}),
          _lineButton(title: "Version",icon:  Icons.new_releases_rounded,onPressed:  (){}),
          _lineButton(title: "Rate this app", icon: Icons.star_rate_rounded, onPressed: (){})
        ],
      ),
    );
  }

  _initData() async {
    _isFingerprintEnabled = await SharedPreferenceData.checkSignInBiometric();
    setState(() {});
  }


  Widget _lineButton({required String title,required IconData icon,required Function() onPressed}){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListTile(
        leading: Icon(icon,color: ConstColors.secondaryColor,size: 30,),
        title: Text(title,style: ConstFonts().copyWithTitle(fontSize: 16),),
        onTap: onPressed,
      ),
    );
  }
}
