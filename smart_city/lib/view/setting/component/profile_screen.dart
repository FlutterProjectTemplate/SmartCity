import 'package:flutter/material.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_fonts.dart';
import 'package:smart_city/constant_value/const_size.dart';
import 'package:smart_city/model/user/user_info.dart';

import '../../../base/sqlite_manager/sqlite_manager.dart';
import '../../../l10n/l10n_extention.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    UserInfo? userInfo = SqliteManager().getCurrentLoginUserInfo();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstColors.surfaceColor,
        title: Text(
          L10nX.getStr.your_profile,
          style: ConstFonts().copyWithTitle(fontSize: 25),
        ),
        centerTitle: true,
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
      backgroundColor: ConstColors.surfaceColor,
      body: SizedBox(
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: height * 0.03),
            CircleAvatar(
              radius: Dimens.size50Vertical,
              backgroundImage: const AssetImage('assets/images/profile.png'),
              backgroundColor: ConstColors.primaryColor,
            ),
            const SizedBox(height: 15),
            Text(
              (userInfo != null) ? userInfo.username ?? "-" : "-",
              style: ConstFonts().copyWithTitle(fontSize: 24),
            ),
            const SizedBox(height: 5),
            Text(
              '${userInfo != null ? userInfo.username : "-"}',
              style: ConstFonts().copyWithSubHeading(
                  fontSize: 20, color: ConstColors.secondaryColor),
            ),
            const SizedBox(height: 20),
            _informationContainer(
                information: (userInfo != null) ? userInfo.typeVehicle??"-" : "-",
                label: "Type vehicles",
                icon: Icons.directions_walk),
            _informationContainer(
                information: (userInfo != null) ? userInfo.phoneNumber??"-" : "-",
                label: 'Phone number',
                icon: Icons.phone),
          ],
        ),
      ),
    );
  }

  Widget _informationContainer(
      {required String information,
      required String label,
      required IconData icon,
      Function()? onTap}) {
    return ListTile(
      leading: Icon(
        icon,
        color: ConstColors.secondaryColor,
        size: 30,
      ),
      title: Text(
        label,
        style: ConstFonts().copyWithTitle(fontSize: 18),
      ),
      trailing: Text(
        information,
        style: ConstFonts()
            .copyWithTitle(fontSize: 16, color: ConstColors.primaryColor),
      ),
      onTap: onTap,
    );
  }
}
