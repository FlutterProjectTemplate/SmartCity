import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:smart_city/base/widgets/user_avatar.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_fonts.dart';
import 'package:smart_city/model/user/user_detail.dart';
import 'package:smart_city/view/setting/component/animated.dart';

import '../../../base/sqlite_manager/sqlite_manager.dart';
import '../../../base/widgets/button.dart';
import '../../../constant_value/const_decoration.dart';
import '../../../l10n/l10n_extention.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin{
  bool onHover = false;
  bool enableEdit = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    UserDetail? userDetail = SqliteManager().getCurrentLoginUserDetail();

    return Scaffold(
      backgroundColor: ConstColors.onPrimaryColor,
      appBar: AppBar(
        backgroundColor: ConstColors.onPrimaryColor,
        title: Text(
          L10nX.getStr.your_profile,
          style: ConstFonts()
              .copyWithTitle(fontSize: 25, color: ConstColors.surfaceColor),
        ),
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
        actions: [
          IconButton(onPressed: () {
            setState(() {
              enableEdit = !enableEdit;
              // Navigator.push(context, MaterialPageRoute(builder: (builder) => AnimatedListExample()));
            });
          }, icon: (!enableEdit) ? Icon(Icons.edit_document, color: ConstColors.controlContentBtn,) : Icon(Icons.cancel_outlined, color: ConstColors.controlContentBtn,))
        ],
      ),
      // backgroundColor: ConstColors.surfaceColor,
      body: AnimatedContainer(
        curve: Curves.easeInOutCubic,
        width: width,
        height: height,
        duration: Duration(milliseconds: 300),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(height: height * 0.03),
                  InkWell(
                    onTap: () async {
                      await _pickImage();
                    },
                    child: UserAvatar(
                        avatar: (userDetail != null) ? userDetail?.avatar ?? "" : "",
                        size: 80),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    (userDetail != null) ? userDetail?.name ?? "-" : "-",
                    style: ConstFonts()
                        .copyWithTitle(fontSize: 24, color: ConstColors.surfaceColor),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${userDetail != null ? userDetail?.roleName : "-"}',
                    style: ConstFonts().copyWithSubHeading(
                        fontSize: 20, color: ConstColors.surfaceColor),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            if (!enableEdit) _informationContainer(
                information:
                    (userDetail != null) ? userDetail?.address ?? "-" : "-",
                label: L10nX.getStr.address,
                icon: Icons.location_on),
            if (!enableEdit) _informationContainer(
                information:
                    (userDetail != null) ? userDetail?.phone ?? "-" : "-",
                label: L10nX.getStr.phone_number,
                icon: Icons.phone),
            if (!enableEdit) _informationContainer(
                information:
                    (userDetail != null) ? userDetail?.email ?? "-" : "-",
                label: L10nX.getStr.email,
                icon: Icons.email),
            if (enableEdit) editInfo(),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: (enableEdit) ? Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      enableEdit = !enableEdit;
                    });
                  },
                  child: Button(
                      width: width / 2,
                      height: 50,
                      color: ConstColors.primaryColor,
                      isCircle: false,
                      child: Text(L10nX.getStr.save,
                          style: ConstFonts().copyWithTitle(fontSize: 18)))
                      .getButton(),
                ),
              ) :
                const SizedBox(),
            )
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

  Widget editInfo() {
    UserDetail? userDetail = SqliteManager().getCurrentLoginUserDetail();
    final addressController = TextEditingController();
    addressController.text = userDetail?.address??"";
    final phoneController = TextEditingController();
    phoneController.text = userDetail?.phone??"";
    final emailController = TextEditingController();
    emailController.text = userDetail?.email??"";
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20),
            child: TextFormField(
              style: TextStyle(color:ConstColors.textFormFieldColor ),
              validator: validate,
              controller: addressController,
              decoration:
              ConstDecoration.inputDecoration(
                  hintText: L10nX.getStr.address),
              cursorColor: ConstColors
                  .onSecondaryContainerColor,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20),
            child: TextFormField(
              style: TextStyle(color:ConstColors.textFormFieldColor ),
              validator: validate,
              controller: phoneController,
              decoration:
              ConstDecoration.inputDecoration(
                  hintText:
                  L10nX.getStr.phone_number),
              cursorColor: ConstColors
                  .textFormFieldColor,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20),
            child: TextFormField(
              style: TextStyle(color:ConstColors.onSecondaryContainerColor ),
              validator: validate,
              controller: emailController,
              decoration:
              ConstDecoration.inputDecoration(
                  hintText: L10nX.getStr.email),
              cursorColor: ConstColors
                  .textFormFieldColor,
            ),
          ),
        ],
      ),
    );
  }

  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return L10nX.getStr.please_enter_your_information;
    }
    return null;
  }
}
