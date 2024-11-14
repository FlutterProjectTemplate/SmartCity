import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_city/base/instance_manager/instance_manager.dart';
import 'package:smart_city/base/widgets/user_avatar.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_fonts.dart';
import 'package:smart_city/model/user/user_detail.dart';
import 'package:smart_city/services/api/update_profile/update_profile_api.dart';
import 'package:smart_city/services/api/update_profile/update_profile_model/update_profile_model.dart';
import 'package:smart_city/view/setting/component/animated.dart';
import 'package:smart_city/view/setting/component/update_profile_bloc/update_profile_bloc.dart';

import '../../../base/sqlite_manager/sqlite_manager.dart';
import '../../../base/widgets/button.dart';
import '../../../constant_value/const_decoration.dart';
import '../../../l10n/l10n_extention.dart';
import '../../../services/api/login/get_profile_api.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  bool onHover = false;
  bool enableEdit = true;
  UserDetail? userDetail = SqliteManager().getCurrentLoginUserDetail();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    update();
  }

  void update() {
    addressController.text = userDetail?.address ?? "";
    phoneController.text = userDetail?.phone ?? "";
    emailController.text = userDetail?.email ?? "";
    nameController.text = userDetail?.name ?? "";
    descriptionController.text = userDetail?.description ?? "";
  }

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
          IconButton(
              onPressed: () {
                setState(() {
                  enableEdit = !enableEdit;
                  // Navigator.push(context, MaterialPageRoute(builder: (builder) => AnimatedListExample()));
                });
              },
              icon: (!enableEdit)
                  ? Icon(
                      Icons.edit_document,
                      color: ConstColors.surfaceColor,
                    )
                  : Icon(
                      Icons.cancel_outlined,
                      color: ConstColors.surfaceColor,
                    ))
        ],
      ),
      // backgroundColor: ConstColors.surfaceColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
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
                          enableEdit: true,
                            avatar: (userDetail != null)
                                ? userDetail.avatar ?? ""
                                : "",
                            size: 80),
                      ),
                      // const SizedBox(height: 15),
                      // Text(
                      //   (userDetail != null) ? userDetail.name ?? "-" : "-",
                      //   style: ConstFonts().copyWithTitle(
                      //       fontSize: 24, color: ConstColors.surfaceColor),
                      // ),
                      // const SizedBox(height: 5),
                      // Text(
                      //   '${userDetail != null ? userDetail.email : "-"}',
                      //   style: ConstFonts().copyWithSubHeading(
                      //       fontSize: 20, color: ConstColors.surfaceColor),
                      // ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                if (!enableEdit)
                  _informationContainer(
                      information: (userDetail != null)
                          ? userDetail.address ?? "-"
                          : "-",
                      label: L10nX.getStr.address,
                      icon: Icons.location_on),
                if (!enableEdit)
                  _informationContainer(
                      information: (userDetail != null)
                          ? userDetail.phone ?? "-"
                          : "-",
                      label: L10nX.getStr.phone_number,
                      icon: Icons.phone),
                if (!enableEdit)
                  _informationContainer(
                      information: (userDetail != null)
                          ? userDetail.email ?? "-"
                          : "-",
                      label: L10nX.getStr.email,
                      icon: Icons.email),
                if (enableEdit) editInfo(),
              ],
            ),
            // Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: (enableEdit)
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: BlocProvider(
                        create: (BuildContext context) => UpdateProfileBloc(),
                        child: BlocBuilder<UpdateProfileBloc,
                            UpdateProfileState>(
                          builder: (context, state) {
                            return GestureDetector(
                              onTap: () async {
                                UpdateProfileApi updateProfileApi =
                                    UpdateProfileApi(
                                        updateProfileModel:
                                            UpdateProfileModel(
                                  email: emailController.text,
                                  phone: phoneController.text,
                                  address: addressController.text,
                                  name: nameController.text,
                                  description: descriptionController.text,
                                  language: userDetail?.language,
                                  timezone: userDetail?.timezone,
                                  vehicleType: 1,
                                ));
                                bool check = await updateProfileApi.call();
                                if (check) {
                                  GetProfileApi getProfileApi =
                                      GetProfileApi();
                                  await getProfileApi.call();
                                  update();
                                  setState(() {
                                    enableEdit = !enableEdit;
                                  });
                                  InstanceManager().showSnackBar(
                                      context: context,
                                      text: 'Update profile successfully');
                                } else {
                                  InstanceManager().showSnackBar(
                                      context: context,
                                      text: 'Update profile failed');
                                }
                              },
                              child: Button(
                                      width: width / 2,
                                      height: 50,
                                      color: ConstColors.primaryColor,
                                      isCircle: false,
                                      child: Text(L10nX.getStr.save,
                                          style: ConstFonts()
                                              .copyWithTitle(fontSize: 18)))
                                  .getButton(),
                            );
                          },
                        ),
                      ),
                    )
                  : const SizedBox(),
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

  Widget _informationContainer({
    required String information,
    required String label,
    required IconData icon,
    Function()? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: ConstColors.surfaceColor,
          size: 30,
        ),
        title: Text(
          label,
          style: ConstFonts().copyWithTitle(
            fontSize: 18,
            color: ConstColors.surfaceColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Text(
          information,
          textAlign: TextAlign.right,
          style: ConstFonts().copyWithTitle(
            fontSize: 16,
            color: ConstColors.primaryColor,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        onTap: onTap,
      ),
    );
  }


  Widget editInfo() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name', style: ConstFonts().copyWithInformation(
              color: Colors.black
            ),),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              style: TextStyle(color: ConstColors.textFormFieldColor),
              validator: validate,
              controller: nameController,
              decoration:
                  ConstDecoration.inputDecoration(hintText: L10nX.getStr.name,
                  prefixIcon: Padding(
                    padding:
                    const EdgeInsets.all(
                        8.0),
                    child: Icon(Icons
                        .person_2_outlined),
                  ),),
              cursorColor: ConstColors.onSecondaryContainerColor,
            ),
            SizedBox(
              height: 20,
            ),
            Text('Phone', style: ConstFonts().copyWithInformation(
                color: Colors.black
            ),),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              style: TextStyle(color: ConstColors.textFormFieldColor),
              validator: validate,
              controller: phoneController,
              decoration: ConstDecoration.inputDecoration(
                  hintText: L10nX.getStr.phone_number,
                prefixIcon: Padding(
                  padding:
                  const EdgeInsets.all(
                      8.0),
                  child: Icon(Icons
                      .phone_outlined),),),
              cursorColor: ConstColors.textFormFieldColor,
            ),
            SizedBox(
              height: 20,
            ),
            Text('Email', style: ConstFonts().copyWithInformation(
                color: Colors.black
            ),),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              style: TextStyle(color: ConstColors.textFormFieldColor),
              validator: validate,
              controller: emailController,
              decoration:
                  ConstDecoration.inputDecoration(hintText: L10nX.getStr.email,
                    prefixIcon: Padding(
                      padding:
                      const EdgeInsets.all(
                          8.0),
                      child: Icon(Icons
                          .email_outlined),),
                  ),
              cursorColor: ConstColors.textFormFieldColor,
            ),
            SizedBox(
              height: 20,
            ),
            Text('Address', style: ConstFonts().copyWithInformation(
                color: Colors.black
            ),),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              style: TextStyle(color: ConstColors.textFormFieldColor),
              validator: validate,
              controller: addressController,
              decoration: ConstDecoration.inputDecoration(
                  hintText: L10nX.getStr.address,
                prefixIcon: Padding(
                  padding:
                  const EdgeInsets.all(
                      8.0),
                  child: Icon(Icons
                      .location_on_outlined),),),
              cursorColor: ConstColors.onSecondaryContainerColor,
            ),
            SizedBox(
              height: 20,
            ),
            Text('Description', style: ConstFonts().copyWithInformation(
                color: Colors.black
            ),),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              minLines: 1,
              maxLines: 5,
              style: TextStyle(color: ConstColors.textFormFieldColor),
              validator: validate,
              controller: descriptionController,
              decoration:
              ConstDecoration.inputDecoration(hintText: "Description",
                prefixIcon: Padding(
                  padding:
                  const EdgeInsets.all(
                      8.0),
                  child: Icon(Icons
                      .description_outlined),),),
              cursorColor: ConstColors.textFormFieldColor,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
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
