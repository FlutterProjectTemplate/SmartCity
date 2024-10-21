import 'package:flutter/material.dart';
import 'package:smart_city/base/widgets/user_avatar.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_fonts.dart';
import 'package:smart_city/constant_value/const_size.dart';
import 'package:smart_city/model/user/user_detail.dart';
import 'package:smart_city/model/user/user_info.dart';

import '../../../base/sqlite_manager/sqlite_manager.dart';
import '../../../l10n/l10n_extention.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    UserDetail? userDetail = SqliteManager().getCurrentLoginUserDetail();

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: ConstColors.surfaceColor,
        title: Text(
          L10nX.getStr.your_profile,
          style: ConstFonts().copyWithTitle(fontSize: 25, color: ConstColors.surfaceColor),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: ConstColors.surfaceColor,
            size: 25,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      // backgroundColor: ConstColors.surfaceColor,
      body: SizedBox(
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: height * 0.03),
            Center(
                child: UserAvatar(
                    avatar: (userDetail != null) ? userDetail.avatar! : "", size: 80), ),
            const SizedBox(height: 15),
            Text(
              (userDetail != null) ? userDetail.roleName ?? "-" : "-",
              style: ConstFonts().copyWithTitle(fontSize: 24, color: ConstColors.surfaceColor),
            ),
            const SizedBox(height: 5),
            Text(
              '${userDetail != null ? userDetail.name : "-"}',
              style: ConstFonts().copyWithSubHeading(
                  fontSize: 20, color: ConstColors.surfaceColor),
            ),
            const SizedBox(height: 20),
            _informationContainer(
                information:
                    (userDetail != null) ? userDetail.address ?? "-" : "-",
                label: L10nX.getStr.address,
                icon: Icons.location_on),
            _informationContainer(
                information:
                    (userDetail != null) ? userDetail.phone ?? "-" : "-",
                label: L10nX.getStr.phone_number,
                icon: Icons.phone),
            _informationContainer(
                information:
                    (userDetail != null) ? userDetail.email ?? "-" : "-",
                label: L10nX.getStr.email,
                icon: Icons.email),
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
        color: ConstColors.surfaceColor,
        size: 30,
      ),
      title: Text(
        label,
        style: ConstFonts().copyWithTitle(fontSize: 18, color: ConstColors.surfaceColor),
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
