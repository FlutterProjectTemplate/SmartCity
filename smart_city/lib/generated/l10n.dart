// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `S.Touch`
  String get app_name {
    return Intl.message(
      'S.Touch',
      name: 'app_name',
      desc: '',
      args: [],
    );
  }

  /// `An error has occurred!`
  String get notify_error {
    return Intl.message(
      'An error has occurred!',
      name: 'notify_error',
      desc: '',
      args: [],
    );
  }

  /// `Username or password is incorrect`
  String get authentication_invalid {
    return Intl.message(
      'Username or password is incorrect',
      name: 'authentication_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get accept {
    return Intl.message(
      'Accept',
      name: 'accept',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get setting {
    return Intl.message(
      'Setting',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `General`
  String get general {
    return Intl.message(
      'General',
      name: 'general',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with fingerprint`
  String get sign_in_fingerprint {
    return Intl.message(
      'Sign in with fingerprint',
      name: 'sign_in_fingerprint',
      desc: '',
      args: [],
    );
  }

  /// `Add widget`
  String get add_widget {
    return Intl.message(
      'Add widget',
      name: 'add_widget',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message(
      'Account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `Your profile`
  String get your_profile {
    return Intl.message(
      'Your profile',
      name: 'your_profile',
      desc: '',
      args: [],
    );
  }

  /// `Change your password`
  String get change_password {
    return Intl.message(
      'Change your password',
      name: 'change_password',
      desc: '',
      args: [],
    );
  }

  /// `Switch to cyclist`
  String get switch_to_cyclist {
    return Intl.message(
      'Switch to cyclist',
      name: 'switch_to_cyclist',
      desc: '',
      args: [],
    );
  }

  /// `Switch to pedestrian`
  String get switch_to_pedestrian {
    return Intl.message(
      'Switch to pedestrian',
      name: 'switch_to_pedestrian',
      desc: '',
      args: [],
    );
  }

  /// `Feedback`
  String get feedback {
    return Intl.message(
      'Feedback',
      name: 'feedback',
      desc: '',
      args: [],
    );
  }

  /// `Rate this app`
  String get rate_this_app {
    return Intl.message(
      'Rate this app',
      name: 'rate_this_app',
      desc: '',
      args: [],
    );
  }

  /// `Privacy policy`
  String get privacy_policy {
    return Intl.message(
      'Privacy policy',
      name: 'privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get log_out {
    return Intl.message(
      'Log out',
      name: 'log_out',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Layers`
  String get layers {
    return Intl.message(
      'Layers',
      name: 'layers',
      desc: '',
      args: [],
    );
  }

  /// `CODE 3 ACTIVATE`
  String get code_3_activate {
    return Intl.message(
      'CODE 3 ACTIVATE',
      name: 'code_3_activate',
      desc: '',
      args: [],
    );
  }

  /// `CODE 3 DEACTIVATE`
  String get code_3_deactivate {
    return Intl.message(
      'CODE 3 DEACTIVATE',
      name: 'code_3_deactivate',
      desc: '',
      args: [],
    );
  }

  /// `Location service is disabled`
  String get location_service_disabled_title {
    return Intl.message(
      'Location service is disabled',
      name: 'location_service_disabled_title',
      desc: '',
      args: [],
    );
  }

  /// `Please enable location service to use this feature`
  String get location_service_disabled_message {
    return Intl.message(
      'Please enable location service to use this feature',
      name: 'location_service_disabled_message',
      desc: '',
      args: [],
    );
  }

  /// `Normal Map`
  String get normal_map {
    return Intl.message(
      'Normal Map',
      name: 'normal_map',
      desc: '',
      args: [],
    );
  }

  /// `Satellite Map`
  String get satellite_map {
    return Intl.message(
      'Satellite Map',
      name: 'satellite_map',
      desc: '',
      args: [],
    );
  }

  /// `Stop tracking`
  String get stop_tracking_title {
    return Intl.message(
      'Stop tracking',
      name: 'stop_tracking_title',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to stop?`
  String get stop_tracking_message {
    return Intl.message(
      'Are you sure you want to stop?',
      name: 'stop_tracking_message',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `Report a Problem`
  String get report_problem {
    return Intl.message(
      'Report a Problem',
      name: 'report_problem',
      desc: '',
      args: [],
    );
  }

  /// ` km/h`
  String get kmh {
    return Intl.message(
      ' km/h',
      name: 'kmh',
      desc: '',
      args: [],
    );
  }

  /// ` mph`
  String get mph {
    return Intl.message(
      ' mph',
      name: 'mph',
      desc: '',
      args: [],
    );
  }

  /// ` m/s`
  String get ms {
    return Intl.message(
      ' m/s',
      name: 'ms',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back to Smart city Signals`
  String get welcome_back_to_citiez {
    return Intl.message(
      'Welcome back to Smart city Signals',
      name: 'welcome_back_to_citiez',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to`
  String get welcome_to {
    return Intl.message(
      'Welcome to',
      name: 'welcome_to',
      desc: '',
      args: [],
    );
  }

  /// `Your journey awaits, sign in to start`
  String get your_journey_awaits_sign_in_to_start {
    return Intl.message(
      'Your journey awaits, sign in to start',
      name: 'your_journey_awaits_sign_in_to_start',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your information`
  String get please_enter_your_information {
    return Intl.message(
      'Please enter your information',
      name: 'please_enter_your_information',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm your password`
  String get confirm_password {
    return Intl.message(
      'Confirm your password',
      name: 'confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password?`
  String get forgot_password {
    return Intl.message(
      'Forgot password?',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get sign_in {
    return Intl.message(
      'Sign in',
      name: 'sign_in',
      desc: '',
      args: [],
    );
  }

  /// `Or sign in with`
  String get or_sign_in_with {
    return Intl.message(
      'Or sign in with',
      name: 'or_sign_in_with',
      desc: '',
      args: [],
    );
  }

  /// `Authentication Biometric Failure`
  String get authentication_biometric_failure {
    return Intl.message(
      'Authentication Biometric Failure',
      name: 'authentication_biometric_failure',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, you don't enable biometric sign in yet`
  String get biometric_sign_in_not_enabled {
    return Intl.message(
      'Sorry, you don\'t enable biometric sign in yet',
      name: 'biometric_sign_in_not_enabled',
      desc: '',
      args: [],
    );
  }

  /// `Oops...`
  String get oops {
    return Intl.message(
      'Oops...',
      name: 'oops',
      desc: '',
      args: [],
    );
  }

  /// `Validation failed`
  String get validation_failed {
    return Intl.message(
      'Validation failed',
      name: 'validation_failed',
      desc: '',
      args: [],
    );
  }

  /// `Please enter mobile number`
  String get please_enter_mobile_number {
    return Intl.message(
      'Please enter mobile number',
      name: 'please_enter_mobile_number',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid mobile number`
  String get please_enter_valid_mobile_number {
    return Intl.message(
      'Please enter valid mobile number',
      name: 'please_enter_valid_mobile_number',
      desc: '',
      args: [],
    );
  }

  /// `User name/Email/Phone number`
  String get user_name_email_phone_number {
    return Intl.message(
      'User name/Email/Phone number',
      name: 'user_name_email_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Confirm your number code`
  String get confirm_your_number_code {
    return Intl.message(
      'Confirm your number code',
      name: 'confirm_your_number_code',
      desc: '',
      args: [],
    );
  }

  /// `Enter the code we sent to the number ending`
  String get enter_code_we_sent {
    return Intl.message(
      'Enter the code we sent to the number ending',
      name: 'enter_code_we_sent',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the code`
  String get please_enter_the_code {
    return Intl.message(
      'Please enter the code',
      name: 'please_enter_the_code',
      desc: '',
      args: [],
    );
  }

  /// `Wrong code, please try again`
  String get wrong_code_try_again {
    return Intl.message(
      'Wrong code, please try again',
      name: 'wrong_code_try_again',
      desc: '',
      args: [],
    );
  }

  /// `Send code again`
  String get send_code_again {
    return Intl.message(
      'Send code again',
      name: 'send_code_again',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Discover the quickest routes to your destination and let Smart city Signals guide you through the city efficiently`
  String get first_line_1 {
    return Intl.message(
      'Discover the quickest routes to your destination and let Smart city Signals guide you through the city efficiently',
      name: 'first_line_1',
      desc: '',
      args: [],
    );
  }

  /// ` red `
  String get highlight_1 {
    return Intl.message(
      ' red ',
      name: 'highlight_1',
      desc: '',
      args: [],
    );
  }

  /// `Navigate smarter with Smart City Signals`
  String get second_line_1 {
    return Intl.message(
      'Navigate smarter with Smart City Signals',
      name: 'second_line_1',
      desc: '',
      args: [],
    );
  }

  /// `Let’s turn your commute\ninto a`
  String get first_line_2 {
    return Intl.message(
      'Let’s turn your commute\ninto a',
      name: 'first_line_2',
      desc: '',
      args: [],
    );
  }

  /// ` green `
  String get highlight_2 {
    return Intl.message(
      ' green ',
      name: 'highlight_2',
      desc: '',
      args: [],
    );
  }

  /// `light party`
  String get second_line_2 {
    return Intl.message(
      'light party',
      name: 'second_line_2',
      desc: '',
      args: [],
    );
  }

  /// `Support us`
  String get support_us {
    return Intl.message(
      'Support us',
      name: 'support_us',
      desc: '',
      args: [],
    );
  }

  /// `Turn off sign in with biometric`
  String get turn_off_sign_in_with_biometric {
    return Intl.message(
      'Turn off sign in with biometric',
      name: 'turn_off_sign_in_with_biometric',
      desc: '',
      args: [],
    );
  }

  /// `Can't turn off sign in with biometric`
  String get cant_turn_off_sign_in_with_biometric {
    return Intl.message(
      'Can\'t turn off sign in with biometric',
      name: 'cant_turn_off_sign_in_with_biometric',
      desc: '',
      args: [],
    );
  }

  /// `Confirm your number code`
  String get confirm_number_code {
    return Intl.message(
      'Confirm your number code',
      name: 'confirm_number_code',
      desc: '',
      args: [],
    );
  }

  /// `Enter the code we sent to the number ending `
  String get enter_code_message {
    return Intl.message(
      'Enter the code we sent to the number ending ',
      name: 'enter_code_message',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the code`
  String get please_enter_code {
    return Intl.message(
      'Please enter the code',
      name: 'please_enter_code',
      desc: '',
      args: [],
    );
  }

  /// `Wrong code, please try again`
  String get wrong_code {
    return Intl.message(
      'Wrong code, please try again',
      name: 'wrong_code',
      desc: '',
      args: [],
    );
  }

  /// `Switch account`
  String get switch_account {
    return Intl.message(
      'Switch account',
      name: 'switch_account',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle`
  String get vehicle {
    return Intl.message(
      'Vehicle',
      name: 'vehicle',
      desc: '',
      args: [],
    );
  }

  /// `Truck`
  String get truck {
    return Intl.message(
      'Truck',
      name: 'truck',
      desc: '',
      args: [],
    );
  }

  /// `Cyclist`
  String get cyclists {
    return Intl.message(
      'Cyclist',
      name: 'cyclists',
      desc: '',
      args: [],
    );
  }

  /// `Pedestrian`
  String get pedestrians {
    return Intl.message(
      'Pedestrian',
      name: 'pedestrians',
      desc: '',
      args: [],
    );
  }

  /// `Car`
  String get car {
    return Intl.message(
      'Car',
      name: 'car',
      desc: '',
      args: [],
    );
  }

  /// `Type vehicles`
  String get type_vehicle {
    return Intl.message(
      'Type vehicles',
      name: 'type_vehicle',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle type`
  String get vehicle_type_str {
    return Intl.message(
      'Vehicle type',
      name: 'vehicle_type_str',
      desc: '',
      args: [],
    );
  }

  /// `Phone number`
  String get phone_number {
    return Intl.message(
      'Phone number',
      name: 'phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get get_started {
    return Intl.message(
      'Get Started',
      name: 'get_started',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'Username/Email/Phone number' key

  /// `Don't have account ? `
  String get register_button {
    return Intl.message(
      'Don\'t have account ? ',
      name: 'register_button',
      desc: '',
      args: [],
    );
  }

  /// `You already have account ? `
  String get login_button {
    return Intl.message(
      'You already have account ? ',
      name: 'login_button',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `First name`
  String get first_name {
    return Intl.message(
      'First name',
      name: 'first_name',
      desc: '',
      args: [],
    );
  }

  /// `Last name`
  String get last_name {
    return Intl.message(
      'Last name',
      name: 'last_name',
      desc: '',
      args: [],
    );
  }

  /// `Hold to start`
  String get hold_to_start {
    return Intl.message(
      'Hold to start',
      name: 'hold_to_start',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Official`
  String get official {
    return Intl.message(
      'Official',
      name: 'official',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `About app`
  String get about_app {
    return Intl.message(
      'About app',
      name: 'about_app',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back`
  String get welcome_back {
    return Intl.message(
      'Welcome back',
      name: 'welcome_back',
      desc: '',
      args: [],
    );
  }

  /// `Dark mode`
  String get dark_mode {
    return Intl.message(
      'Dark mode',
      name: 'dark_mode',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Stop`
  String get stop {
    return Intl.message(
      'Stop',
      name: 'stop',
      desc: '',
      args: [],
    );
  }

  /// `Servicing`
  String get servicing {
    return Intl.message(
      'Servicing',
      name: 'servicing',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get start {
    return Intl.message(
      'Start',
      name: 'start',
      desc: '',
      args: [],
    );
  }

  /// `Speed unit`
  String get change_speed_unit {
    return Intl.message(
      'Speed unit',
      name: 'change_speed_unit',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `About us`
  String get about_us {
    return Intl.message(
      'About us',
      name: 'about_us',
      desc: '',
      args: [],
    );
  }

  /// `Change your information`
  String get profile_subtitle {
    return Intl.message(
      'Change your information',
      name: 'profile_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Secure your account`
  String get change_password_subtitle {
    return Intl.message(
      'Secure your account',
      name: 'change_password_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `View our privacy terms`
  String get privacy_policy_subtitle {
    return Intl.message(
      'View our privacy terms',
      name: 'privacy_policy_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Contact email, Phone number`
  String get about_app_subtitle {
    return Intl.message(
      'Contact email, Phone number',
      name: 'about_app_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Bicycle`
  String get BIK {
    return Intl.message(
      'Bicycle',
      name: 'BIK',
      desc: '',
      args: [],
    );
  }

  /// `Pedestrian`
  String get PED {
    return Intl.message(
      'Pedestrian',
      name: 'PED',
      desc: '',
      args: [],
    );
  }

  /// `Transit`
  String get BUS {
    return Intl.message(
      'Transit',
      name: 'BUS',
      desc: '',
      args: [],
    );
  }

  /// `Truck`
  String get TRK {
    return Intl.message(
      'Truck',
      name: 'TRK',
      desc: '',
      args: [],
    );
  }

  /// `Ambulance`
  String get AMB {
    return Intl.message(
      'Ambulance',
      name: 'AMB',
      desc: '',
      args: [],
    );
  }

  /// `Fire Truck`
  String get FTR {
    return Intl.message(
      'Fire Truck',
      name: 'FTR',
      desc: '',
      args: [],
    );
  }

  /// `Military Vehicle`
  String get MLV {
    return Intl.message(
      'Military Vehicle',
      name: 'MLV',
      desc: '',
      args: [],
    );
  }

  /// `Armored Car`
  String get AMC {
    return Intl.message(
      'Armored Car',
      name: 'AMC',
      desc: '',
      args: [],
    );
  }

  /// `Tractor`
  String get TRC {
    return Intl.message(
      'Tractor',
      name: 'TRC',
      desc: '',
      args: [],
    );
  }

  /// `Agricultural Vehicle`
  String get AGV {
    return Intl.message(
      'Agricultural Vehicle',
      name: 'AGV',
      desc: '',
      args: [],
    );
  }

  /// `Official Vehicle`
  String get OFV {
    return Intl.message(
      'Official Vehicle',
      name: 'OFV',
      desc: '',
      args: [],
    );
  }

  /// `EVP`
  String get EVP {
    return Intl.message(
      'EVP',
      name: 'EVP',
      desc: '',
      args: [],
    );
  }

  /// `Agree`
  String get str_accept {
    return Intl.message(
      'Agree',
      name: 'str_accept',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get str_cancel {
    return Intl.message(
      'Cancel',
      name: 'str_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Location is not allowed. Please allow location access from settings`
  String get open_location_setting {
    return Intl.message(
      'Location is not allowed. Please allow location access from settings',
      name: 'open_location_setting',
      desc: '',
      args: [],
    );
  }

  /// `Smart City app needs location access to detect your location on the map and perform traffic control operations`
  String get request_location {
    return Intl.message(
      'Smart City app needs location access to detect your location on the map and perform traffic control operations',
      name: 'request_location',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'request microphone' key

  /// `Location tracking request`
  String get location_permission_request_title {
    return Intl.message(
      'Location tracking request',
      name: 'location_permission_request_title',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contact_us {
    return Intl.message(
      'Contact Us',
      name: 'contact_us',
      desc: '',
      args: [],
    );
  }

  /// `Company`
  String get company {
    return Intl.message(
      'Company',
      name: 'company',
      desc: '',
      args: [],
    );
  }

  /// `Contact`
  String get contact {
    return Intl.message(
      'Contact',
      name: 'contact',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get phone {
    return Intl.message(
      'Phone',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Website`
  String get website {
    return Intl.message(
      'Website',
      name: 'website',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get version {
    return Intl.message(
      'Version',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `Developed by`
  String get developed_by {
    return Intl.message(
      'Developed by',
      name: 'developed_by',
      desc: '',
      args: [],
    );
  }

  /// `Release Date`
  String get release_date {
    return Intl.message(
      'Release Date',
      name: 'release_date',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update vehicle`
  String get failed_update_vehicle {
    return Intl.message(
      'Failed to update vehicle',
      name: 'failed_update_vehicle',
      desc: '',
      args: [],
    );
  }

  /// `Change your information`
  String get change_information {
    return Intl.message(
      'Change your information',
      name: 'change_information',
      desc: '',
      args: [],
    );
  }

  /// `Secure your account`
  String get secure_account {
    return Intl.message(
      'Secure your account',
      name: 'secure_account',
      desc: '',
      args: [],
    );
  }

  /// `View our privacy terms`
  String get view_privacy_terms {
    return Intl.message(
      'View our privacy terms',
      name: 'view_privacy_terms',
      desc: '',
      args: [],
    );
  }

  /// `Contact email, Phone number`
  String get contact_info {
    return Intl.message(
      'Contact email, Phone number',
      name: 'contact_info',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your information`
  String get please_enter_infomation {
    return Intl.message(
      'Please enter your information',
      name: 'please_enter_infomation',
      desc: '',
      args: [],
    );
  }

  /// `New password must be at least 6 characters`
  String get enter_password_invalid_1 {
    return Intl.message(
      'New password must be at least 6 characters',
      name: 'enter_password_invalid_1',
      desc: '',
      args: [],
    );
  }

  /// `Password does not match`
  String get enter_password_invalid_2 {
    return Intl.message(
      'Password does not match',
      name: 'enter_password_invalid_2',
      desc: '',
      args: [],
    );
  }

  /// `Old password`
  String get old_password {
    return Intl.message(
      'Old password',
      name: 'old_password',
      desc: '',
      args: [],
    );
  }

  /// `New password`
  String get new_password {
    return Intl.message(
      'New password',
      name: 'new_password',
      desc: '',
      args: [],
    );
  }

  /// `Update profile successfully`
  String get update_profile_success {
    return Intl.message(
      'Update profile successfully',
      name: 'update_profile_success',
      desc: '',
      args: [],
    );
  }

  /// `Update profile failed`
  String get update_profile_fail {
    return Intl.message(
      'Update profile failed',
      name: 'update_profile_fail',
      desc: '',
      args: [],
    );
  }

  /// `Delete account`
  String get delete_account {
    return Intl.message(
      'Delete account',
      name: 'delete_account',
      desc: '',
      args: [],
    );
  }

  /// `All data about your account will be deleted. Are you sure you want to delete your account?`
  String get delete_account_confirm {
    return Intl.message(
      'All data about your account will be deleted. Are you sure you want to delete your account?',
      name: 'delete_account_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Customer`
  String get customer_str {
    return Intl.message(
      'Customer',
      name: 'customer_str',
      desc: '',
      args: [],
    );
  }

  /// `Account registration successful, you can now log in`
  String get register_success {
    return Intl.message(
      'Account registration successful, you can now log in',
      name: 'register_success',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'vi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
