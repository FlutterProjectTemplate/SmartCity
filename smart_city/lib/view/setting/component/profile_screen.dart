import 'dart:typed_data';

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
import 'package:smart_city/view/setting/component/update_profile_bloc/update_profile_bloc.dart';

import '../../../base/common/responsive_info.dart';
import '../../../base/sqlite_manager/sqlite_manager.dart';
import '../../../base/widgets/button.dart';
import '../../../constant_value/const_decoration.dart';
import '../../../l10n/l10n_extention.dart';
import '../../../services/api/login/get_profile_api.dart';
import '../../../services/api/update_profile/upload_avatar.dart';

class ProfileScreen extends StatefulWidget {
  final Function(bool)? onChange;
  const ProfileScreen({super.key, this.onChange,});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  bool onHover = false;
  bool enableEdit = false;
  UserDetail? userDetail = SqliteManager().getCurrentLoginUserDetail();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  Uint8List? _imageBytes;
  MultipartFile? file;
  double size = 80;

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  void getInfo() {
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
        backgroundColor: ConstColors.tertiaryContainerColor,
        title: Text(
          L10nX.getStr.your_profile,
          style: ConstFonts()
              .copyWithTitle(fontSize: 25, color: Colors.white),
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
        actions: [
          IconButton(
              onPressed: () {
                if (enableEdit == true) getInfo();
                setState(() {
                  enableEdit = !enableEdit;
                  // Navigator.push(context, MaterialPageRoute(builder: (builder) => AnimatedListExample()));
                });
              },
              icon: (!enableEdit)
                  ? Icon(
                      Icons.edit_document,
                      color: Colors.white,
                    )
                  : Icon(
                      Icons.cancel_outlined,
                      color: Colors.white,
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
                          await _pickImage(context);
                        },
                        child: (_imageBytes == null)
                            ? UserAvatar(
                          enableEdit: true,
                            fit: BoxFit.fitHeight,
                            avatar: (userDetail != null)
                                ? userDetail.avatar ?? ""
                                : "",
                            size: ResponsiveInfo.isPhone() ? size : size * 1.5)
                            : SizedBox(
                                width: ResponsiveInfo.isPhone() ? size : size * 1.5,
                                height: ResponsiveInfo.isPhone() ? size : size * 1.5,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(size / 2),
                                  child: Image.memory(
                                    _imageBytes!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                editInfo(),
                (enableEdit)
                    ? Padding(
                        padding: EdgeInsets.only(bottom: 20),
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
                                    getInfo();
                                    setState(() {
                                      enableEdit = !enableEdit;
                                    });
                                    widget.onChange!(true);
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
                    : SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        withData: true,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg'],
      );

      if (result != null && result.files.isNotEmpty) {
        final fileBytes = result.files.first.bytes;
        final fileName = result.files.first.name;

        if (fileBytes != null) {
          MultipartFile file = MultipartFile.fromBytes(
            fileBytes,
            filename: fileName,
          );
          UploadAvatarApi uploadAvatarApi = UploadAvatarApi(multipartFile: file);
          bool check = await uploadAvatarApi.call();
          if (check) {
            InstanceManager().showSnackBar(
                context: context, text: 'Update avatar successfully');
            setState(() {
              _imageBytes = fileBytes;
              widget.onChange!(true);
            });
          } else {
            InstanceManager().showSnackBar(context: context, text: 'Update avatar failed');
          }
        } else {
          print("Selected file has no data.");
        }
      } else {
        print("No file selected.");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Widget buildTextFormField({
    required TextEditingController controller,
    required bool enableEdit,
    required String hintText,
    required Widget prefixIcon,
    int? maxLine,
    int? minLine,
  }) {
    return !enableEdit ? AbsorbPointer(
      child: Opacity(
        opacity: 0.5,
        child: TextFormField(
          style: TextStyle(color: ConstColors.textFormFieldColor),
          validator: validate,
          // minLines: minLine,
          // maxLines: maxLine,
          controller: controller,
          textAlignVertical: TextAlignVertical.center,
          decoration: ConstDecoration.inputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon,
          ),
          cursorColor: ConstColors.onSecondaryContainerColor,
        ),
      ),
    ) : TextFormField(
      style: TextStyle(color: ConstColors.textFormFieldColor),
      validator: validate,
      // minLines: minLine,
      // maxLines: maxLine,
      controller: controller,
      textAlignVertical: TextAlignVertical.center,
      decoration: ConstDecoration.inputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
      ),
      cursorColor: ConstColors.onSecondaryContainerColor,
    );
  }

  Widget editInfo() {
    double padding = 15;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name',
              style: ConstFonts().copyWithInformation(color: Colors.black),
            ),
            SizedBox(
              height: 5,
            ),
            buildTextFormField(
                prefixIcon: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Icon(Icons.person_2_outlined),
                ),
                hintText: L10nX.getStr.name,
                controller: nameController,
                enableEdit: enableEdit),
            SizedBox(
              height: 20,
            ),
            Text(
              'Phone',
              style: ConstFonts().copyWithInformation(color: Colors.black),
            ),
            SizedBox(
              height: 5,
            ),
            buildTextFormField(
                prefixIcon: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Icon(Icons.phone_outlined),
                ),
                hintText: L10nX.getStr.phone_number,
                controller: phoneController,
                enableEdit: enableEdit),
            SizedBox(
              height: 20,
            ),
            Text(
              'Email',
              style: ConstFonts().copyWithInformation(color: Colors.black),
            ),
            SizedBox(
              height: 5,
            ),
            buildTextFormField(
                prefixIcon: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Icon(Icons.email_outlined),
                ),
                hintText: L10nX.getStr.email,
                controller: emailController,
                enableEdit: enableEdit),
            SizedBox(
              height: 20,
            ),
            Text(
              'Address',
              style: ConstFonts().copyWithInformation(color: Colors.black),
            ),
            SizedBox(
              height: 5,
            ),
            buildTextFormField(
                prefixIcon: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Icon(Icons.location_on_outlined),
                ),
                hintText: L10nX.getStr.address,
                controller: addressController,
                enableEdit: enableEdit),
            SizedBox(
              height: 20,
            ),
            Text(
              'Description',
              style: ConstFonts().copyWithInformation(color: Colors.black),
            ),
            SizedBox(
              height: 5,
            ),
            buildTextFormField(
              prefixIcon: Padding(
                padding: EdgeInsets.all(padding),
                child: Icon(Icons.description_outlined),
              ),
              hintText: L10nX.getStr.description,
              controller: descriptionController,
              enableEdit: enableEdit,
              minLine: 5,
              maxLine: 5,
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
