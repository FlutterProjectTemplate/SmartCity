import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../base/app_settings/app_setting.dart';
import '../../../constant_value/const_colors.dart';
import '../../../constant_value/const_fonts.dart';
import '../../../helpers/localizations/app_notifier.dart';
import '../../../helpers/localizations/bloc/main_bloc.dart';

class ChangeTheme extends StatefulWidget {
  const ChangeTheme({super.key});

  @override
  State<ChangeTheme> createState() => _ChangeThemeState();
}

class _ChangeThemeState extends State<ChangeTheme> {
  final Color color = Color.fromRGBO(243, 243, 243, 1.0).withOpacity(0.5);
  bool _enabledDarkTheme = AppSetting.enableDarkMode;
  List<IconData> icons = [
    Icons.dark_mode,
    Icons.light_mode,
  ];
  List<String> mode = [
    "Dark",
    "Light",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.onPrimaryColor,
      appBar: AppBar(
        backgroundColor: ConstColors.onPrimaryColor,
        centerTitle: true,
        title: Text(
          "Theme",
          style: ConstFonts()
              .copyWithTitle(fontSize: 25, color: ConstColors.surfaceColor),
        ),
        automaticallyImplyLeading: false,
        titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: ConstColors.surfaceColor,
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: 2,
        separatorBuilder: (ctx, index) => const SizedBox(
          height: 15,
        ),
        itemBuilder: (context, int index) {
          return Container(
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: (_enabledDarkTheme && mode[index] == "Dark" || !_enabledDarkTheme && mode[index] == "Light") ? ConstColors.primaryColor : ConstColors.surfaceColor),
                borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Icon(icons[index], color: ConstColors.textFormFieldColor,),
              horizontalTitleGap: 15,
              title: Text(
                mode[index],
                style: ConstFonts().copyWithTitle(
                    fontSize: 16, color: ConstColors.surfaceColor),
              ),
              trailing: Visibility(
                visible: (_enabledDarkTheme && mode[index] == "Dark" || !_enabledDarkTheme && mode[index] == "Light"),
                child: const Icon(Icons.done, color: Colors.blueAccent),
              ),
              onTap: () async {
                setState(() {
                  (index == 1) ? _enabledDarkTheme = false : _enabledDarkTheme = true;
                  context.read<MainBloc>().add(MainChangeDarkModeEvent());
                  ConstColors.updateDarkMode(_enabledDarkTheme);
                  AppNotifier()
                      .changeAppTheme(_enabledDarkTheme, notify: true);
                });
              },
            ),
          );
        },
      ),
    );
  }
}
