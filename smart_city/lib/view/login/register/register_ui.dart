import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phone_number_text_input_formatter/phone_number_text_input_formatter.dart';
import 'package:radio_group_v2/utils/radio_group_decoration.dart';
import 'package:radio_group_v2/widgets/view_models/radio_group_controller.dart';
import 'package:radio_group_v2/widgets/views/radio_group.dart';
import 'package:smart_city/base/instance_manager/instance_manager.dart';
import 'package:smart_city/base/utlis/loading_common.dart';
import 'package:smart_city/base/widgets/button.dart';
import 'package:smart_city/base/widgets/custom_alert_dialog.dart';
import 'package:smart_city/base/widgets/popup_confirm/confirm_popup_page.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_decoration.dart';
import 'package:smart_city/constant_value/const_fonts.dart';
import 'package:smart_city/constant_value/const_key.dart';
import 'package:smart_city/constant_value/const_size.dart';
import 'package:smart_city/l10n/l10n_extention.dart';
import 'package:smart_city/services/api/get_customer/models/get_customer_model.dart';
import 'package:smart_city/services/api/get_vehicle/models/get_vehicle_model.dart';
import 'package:smart_city/view/login/login_ui.dart';
import 'package:smart_city/view/register_bloc/register_bloc.dart';

import '../../../base/common/responsive_info.dart';
import '../../../controller/vehicles_bloc/vehicles_bloc.dart';

class RegisterUi extends StatefulWidget {
  const RegisterUi({super.key});

  @override
  State<RegisterUi> createState() => _RegisterUiState();
}

class _RegisterUiState extends State<RegisterUi> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();

  final _lastNameController = TextEditingController();

  final _phoneController = TextEditingController();

  final _customerController = TextEditingController();

  final _passwordController = TextEditingController();

  final _confirmPassController = TextEditingController();

  final _emailController = TextEditingController();

  bool isHidePassword = true;
  CustomerModel? selectCustomerModel;
  RadioGroupController vehicleController = RadioGroupController();
  int vehicleControllerSelectedIndex = 0;
  List<String> values = [];
  List<Widget> typeWidget = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => RegisterBloc(),
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return BlocListener<RegisterBloc, RegisterState>(
            listener: (context, state) {
              if (state.status == RegisterStatus.failure) {
                InstanceManager().showSnackBar(
                    context: context,
                    text: InstanceManager().errorLoginMessage,
                  duration: Duration(seconds: 5)
                );
              } else if (state.status == RegisterStatus.success) {
                InstanceManager().showSnackBar(
                    context: context,
                    text: L10nX.getStr.register_success,
                    duration: Duration(seconds: 5)
                );
                Navigator.pop(context);
              }
            },
            child: Scaffold(
                body: Form(
              key: _formKey,
              child: SizedBox(width: width, height: height, child: (ResponsiveInfo.isTablet()) ? buildTablet(context) : buildMobile(context)),
            )),
          );
        },
      ),
    );
  }

  Widget buildTablet(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Image.asset(
          height: height,
          width: width,
          'assets/images/background16.jpg',
          fit: BoxFit.fill,
        ),
        Center(
          child: Container(
            width: (height > width) ? width * 0.6 : width * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black.withOpacity(0.6),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: (height > width) ? height * 0.02 : height * 0.04,
                  ),
                  // Image.asset(
                  //   'assets/scs-logo.png',
                  //   height: height * 0.1,
                  //   width: width * 0.3,
                  //   color: ConstColors.onSecondaryContainerColor,
                  // ),
                  Hero(
                    tag: 'lo-go',
                    child: Image.asset(
                      color: Colors.white,
                      'assets/logo1.png',
                      height: height * 0.2,
                      width: width * 0.3,
                    ),
                  ),
                  SizedBox(
                    height: (height > width) ? height * 0.02 : height * 0.04,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            style: TextStyle(color: ConstColors.textFormFieldColor),
                            validator: validate,
                            controller: _firstNameController,
                            decoration: ConstDecoration.inputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.person_2_outlined),
                                ),
                                hintText: L10nX.getStr.first_name),
                            cursorColor: ConstColors.onSecondaryContainerColor,
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: TextFormField(
                            style: TextStyle(color: ConstColors.textFormFieldColor),
                            validator: validate,
                            controller: _lastNameController,
                            decoration: ConstDecoration.inputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.person_2_outlined),
                                ),
                                hintTextFontSize: 14,
                                hintText: L10nX.getStr.last_name),
                            cursorColor: ConstColors.textFormFieldColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: (height > width) ? height * 0.02 : height * 0.04,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      style: TextStyle(color: ConstColors.onSecondaryContainerColor),
                      validator: validate,
                      controller: _emailController,
                      decoration: ConstDecoration.inputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.email_outlined),
                          ),
                          hintText: L10nX.getStr.email),
                      cursorColor: ConstColors.textFormFieldColor,
                    ),
                  ),
                  SizedBox(
                    height: (height > width) ? height * 0.02 : height * 0.04,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      style: TextStyle(color: ConstColors.onSecondaryContainerColor),
                      validator: validate,
                      controller: _phoneController,
                      maxLength: 15,
                      keyboardType: TextInputType.phone,
                      inputFormatters: ConstInfo.inputFormattersUSPhoneFormat,
                      decoration: ConstDecoration.inputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.phone),
                          ),
                          hintText: L10nX.getStr.phone),
                      cursorColor: ConstColors.textFormFieldColor,
                    ),
                  ),
                  SizedBox(
                    height: (height > width) ? height * 0.02 : height * 0.04,
                  ),

                  StatefulBuilder(
                    builder: (context, StateSetter setState) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          style: TextStyle(color: ConstColors.textFormFieldColor),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return L10nX.getStr.please_enter_your_information;
                            }
                            return null;
                          },
                          controller: _passwordController,
                          decoration: ConstDecoration.inputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.lock_outline),
                              ),
                              hintText: L10nX.getStr.password,
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isHidePassword = !isHidePassword;
                                    });
                                  },
                                  icon: Icon(
                                    isHidePassword ? Icons.visibility_off : Icons.visibility,
                                    color: ConstColors.textFormFieldColor,
                                  ))),
                          cursorColor: ConstColors.textFormFieldColor,
                          obscureText: isHidePassword,
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: (height > width) ? height * 0.02 : height * 0.04,
                  ),
                  StatefulBuilder(
                    builder: (context, StateSetter setState) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          style: TextStyle(color: ConstColors.textFormFieldColor),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return L10nX.getStr.please_enter_your_information;
                            }
                            return null;
                          },
                          controller: _confirmPassController,
                          decoration: ConstDecoration.inputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.lock_outline),
                              ),
                              hintText: L10nX.getStr.confirm_password,
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isHidePassword = !isHidePassword;
                                    });
                                  },
                                  icon: Icon(
                                    isHidePassword ? Icons.visibility_off : Icons.visibility,
                                    color: ConstColors.textFormFieldColor,
                                  ))),
                          cursorColor: ConstColors.textFormFieldColor,
                          obscureText: isHidePassword,
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: (height > width) ? height * 0.02 : height * 0.04,
                  ),
                  buildVehiclesTypes(),
                  SizedBox(
                    height: (height > width) ? height * 0.02 : height * 0.04,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          VehicleTypeResponseModel? transport = await InstanceManager().getVehicleTypeModel();
                          VehicleTypeInfo vehicleType = (transport?.list ?? []).elementAt(vehicleController.selectedIndex);
                          String phone = _phoneController.text.replaceAll("-", "").replaceAll("(", "").replaceAll(")", "").replaceAll(" ", "");

                          context.read<RegisterBloc>().add(
                              RegisterSubmitted(
                                 name: "${_firstNameController.text} ${_lastNameController.text}",
                                 email: _emailController.text,
                                 password:  _passwordController.text,
                                 vehicleType: vehicleType.id ?? 0,
                                 phone: phone,
                                 username: phone));
                        } else {
                          debugPrint("Validation failed");
                        }
                      },
                      child: Button(
                        width: width - 50,
                        height: 50,
                        color: ConstColors.primaryColor,
                        isCircle: false,
                        child: Text(L10nX.getStr.register, style: ConstFonts().title),
                      ).getButton(),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: L10nX.getStr.login_button,
                                  style: ConstFonts().copyWithSubHeading(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                TextSpan(
                                  text: L10nX.getStr.login,
                                  style: ConstFonts().copyWithSubHeading(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: height * 0.04,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildMobile(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
        width: width,
        height: height,
        child: Stack(children: [
          Image.asset(
            height: height,
            width: width,
            'assets/images/background16.jpg',
            fit: BoxFit.cover,
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ),
          SafeArea(
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withOpacity(0.6),
                ),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height -30*2
                ),
                margin: EdgeInsets.only(left: 30, right: 30),
                padding: EdgeInsets.symmetric(vertical: Dimens.size10Vertical),
                child: Padding(
                  padding:  EdgeInsets.only(bottom: Dimens.size10Vertical),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Hero(
                            tag: 'lo-go',
                            child: Image.asset(
                              'assets/logo1.png',
                              height: 130,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            style: TextStyle(color: ConstColors.textFormFieldColor),
                            validator: validate,
                            controller: _firstNameController,
                            decoration: ConstDecoration.inputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.person_2_outlined),
                                ),
                                hintText: L10nX.getStr.first_name,
                                hintTextFontSize: 14),
                            cursorColor: ConstColors.textFormFieldColor,
                          ),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            style: TextStyle(color: ConstColors.textFormFieldColor),
                            validator: validate,
                            controller: _lastNameController,
                            decoration: ConstDecoration.inputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.person_2_outlined),
                                ),
                                hintTextFontSize: 14,
                                hintText: L10nX.getStr.last_name),
                            cursorColor: ConstColors.textFormFieldColor,
                          ),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            style: TextStyle(color: ConstColors.textFormFieldColor),
                            validator: validate,
                            controller: _emailController,
                            decoration: ConstDecoration.inputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.email_outlined),
                                ),
                                hintText: L10nX.getStr.email),
                            cursorColor: ConstColors.textFormFieldColor,
                          ),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            style: TextStyle(color: ConstColors.textFormFieldColor),
                            validator: validate,
                            controller: _phoneController,
                            maxLength: 15,
                            keyboardType: TextInputType.phone,
                            inputFormatters: ConstInfo.inputFormattersUSPhoneFormat,
                            decoration: ConstDecoration.inputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.phone),
                                ),
                                hintText: L10nX.getStr.phone),
                            cursorColor: ConstColors.textFormFieldColor,
                          ),
                        ),
                        SizedBox(height: 16),
                        StatefulBuilder(
                          builder: (context, StateSetter setState) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                style: TextStyle(color: ConstColors.textFormFieldColor),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return L10nX.getStr.please_enter_your_information;
                                  }
                                  return null;
                                },
                                controller: _passwordController,
                                decoration: ConstDecoration.inputDecoration(
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(Icons.lock_outline),
                                    ),
                                    hintText: L10nX.getStr.password,
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isHidePassword = !isHidePassword;
                                          });
                                        },
                                        icon: Icon(
                                          isHidePassword ? Icons.visibility_off : Icons.visibility,
                                          color: ConstColors.textFormFieldColor,
                                        ))),
                                cursorColor: ConstColors.textFormFieldColor,
                                obscureText: isHidePassword,
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 16),
                        StatefulBuilder(
                          builder: (context, StateSetter setState) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                style: TextStyle(color: ConstColors.textFormFieldColor),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return L10nX.getStr.please_enter_your_information;
                                  }
                                  return null;
                                },
                                controller: _confirmPassController,
                                decoration: ConstDecoration.inputDecoration(
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(Icons.lock_outline),
                                    ),
                                    hintText: L10nX.getStr.confirm_password,
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isHidePassword = !isHidePassword;
                                          });
                                        },
                                        icon: Icon(
                                          isHidePassword ? Icons.visibility_off : Icons.visibility,
                                          color: ConstColors.textFormFieldColor,
                                        ))),
                                cursorColor: ConstColors.textFormFieldColor,
                                obscureText: isHidePassword,
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 16),
                        buildVehiclesTypes(),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                VehicleTypeResponseModel? transport = await InstanceManager().getVehicleTypeModel();
                                VehicleTypeInfo vehicleType = (transport?.list ?? []).elementAt(vehicleController.selectedIndex);
                                String phone = _phoneController.text.replaceAll("-", "").replaceAll("(", "").replaceAll(")", "").replaceAll(" ", "");
                                context.read<RegisterBloc>().add(
                                    RegisterSubmitted(
                                      name:  "${_firstNameController.text} ${_lastNameController.text}",
                                      email:  _emailController.text,
                                      phone:   phone,
                                      vehicleType:  vehicleType.id ?? 0,
                                      username: phone,
                                      password: _passwordController.text,));
                              } else {
                                debugPrint("Validation failed");
                              }
                            },
                            child: Button(
                              width: width - 50,
                              height: (ResponsiveInfo.isTablet() && MediaQuery.of(context).size.width < MediaQuery.of(context).size.height) ? MediaQuery.of(context).size.height * 0.04 : MediaQuery.of(context).size.height * 0.06,
                              color: ConstColors.primaryColor,
                              child: Text(L10nX.getStr.register, style: ConstFonts().title),
                            ).getButton(),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: L10nX.getStr.login_button,
                                        style: ConstFonts().copyWithSubHeading(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      TextSpan(
                                        text: L10nX.getStr.login,
                                        style: ConstFonts().copyWithSubHeading(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]));
  }

  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return L10nX.getStr.please_enter_your_information;
    }
    return null;
  }

  void _showBottomSheetListCustomer({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 5 / 6,
      ),
      builder: (BuildContext context) {
        double width = (MediaQuery.of(context).size.width) < 800 ? MediaQuery.of(context).size.width : 800;
        return FutureBuilder(
          future: InstanceManager().getGetCustomer(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (!snapshot.hasData) {
              return LoadingAnimationWidget.staggeredDotsWave(color: ConstColors.primaryColor, size: 45);
            }
            GetCustomerModel getCustomerModel = snapshot.data;
            return StatefulBuilder(
              builder: (BuildContext context, void Function(void Function()) setState) {
                double heightList = (getCustomerModel.list ?? []).length * 60;
                if (heightList < 200) {
                  heightList = 200;
                } else if (heightList > MediaQuery.of(context).size.height) {
                  heightList = MediaQuery.of(context).size.height;
                }
                return SizedBox(
                  height: heightList,
                  child: ListView.builder(
                    itemCount: (getCustomerModel.list ?? []).length,
                    padding: EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      CustomerModel customerModel = (getCustomerModel.list ?? []).elementAt(index);
                      bool isSelect = customerModel.id == selectCustomerModel?.id;
                      return InkWell(
                        onTap: () {
                          setState(
                            () {
                              selectCustomerModel = customerModel;
                              _customerController.text = customerModel.shortName ?? "";
                            },
                          );
                        },
                        child: ListTile(
                          title: Text(
                            customerModel.shortName ?? "",
                            style: ConstFonts().copyWithTitle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            customerModel.longName ?? "",
                            style: ConstFonts().copyWithTitle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          trailing: Icon(
                            isSelect ? Icons.radio_button_checked : Icons.radio_button_off,
                            color: isSelect ? Colors.green : Colors.black87,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget buildVehiclesTypes() {

    return FutureBuilder(
      future: InstanceManager().getVehicleTypeModel(),
      builder: (context, snapshot) {
        if(!snapshot.hasData || snapshot.data==null )
          {
            return SizedBox.shrink();
          }
        VehicleTypeResponseModel? transport = snapshot.data;
        if((transport?.list??[]).isEmpty) {
          return SizedBox.shrink();
        }
        typeWidget = (transport?.list ?? []).map((entry) {
          String type = InstanceManager().getVehicleString(entry);
          values.add(type);
          return Container(
            decoration: BoxDecoration(
              //border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(20)
            ),
            margin: EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: [
                Text(entry.text??"", style: TextStyle(color: Colors.white, fontSize: 14),)
              ],
            ),
          );
        }).toList();

        WidgetsFlutterBinding.ensureInitialized().addPersistentFrameCallback((timeStamp) {
          if(vehicleController.selectedIndex==-1){
            setState(() {
              vehicleController.selectAt(0);
            });
          }

        },);
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimens.size25Horizontal),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "${L10nX().vehicle_type_str}: ",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ]),
              SizedBox(
                height: 4,
              ),
              Container(
                decoration: BoxDecoration(
                  //  color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                ),
                clipBehavior: Clip.hardEdge,
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: RadioGroup(
                            key: GlobalKey<RadioGroupState<dynamic>>(),
                            controller: vehicleController,
                            values: typeWidget,
                            indexOfDefault: vehicleControllerSelectedIndex,
                            orientation: RadioGroupOrientation.horizontal,
                            onChanged: (value) {
                              print("object");
                              vehicleControllerSelectedIndex = vehicleController.selectedIndex;
                            },
                            decoration: RadioGroupDecoration(
                              spacing: 24.0,
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                              activeColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
