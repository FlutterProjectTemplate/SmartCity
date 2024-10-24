import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:smart_city/base/widgets/user_avatar.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_fonts.dart';
import 'package:smart_city/model/user/user_detail.dart';

import '../../../base/sqlite_manager/sqlite_manager.dart';
import '../../../l10n/l10n_extention.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool onHover = false;

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
          style: ConstFonts()
              .copyWithTitle(fontSize: 25, color: ConstColors.surfaceColor),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
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

  Future _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        withData: true,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg']);
    MultipartFile file = MultipartFile.fromBytes(result!.files.first.bytes!,
        filename: result.names[0]);
    // UploadAvatarApi uploadAvatarApi = UploadAvatarApi(
    //     fileInfo: UploadFileInfo(
    //         data: SubjectType.avatar,
    //         fileName: result.files.first.name,
    //         file: file));
    // UploadFileResponseInfo? resultUpload = await uploadAvatarApi.call();
    // if (resultUpload != UploadFileResponseInfo()) {
    setState(() {
      // _imageUrl = resultUpload?.link!;
      // editProfileController.basicValidator.getController('file_id')!.text = resultUpload!.id.toString();
    });
    // } else {
    //   ToastUtils.showSnackBar(context, "Upload avatar failed");
    // }
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
        style: ConstFonts()
            .copyWithTitle(fontSize: 18, color: ConstColors.surfaceColor),
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
