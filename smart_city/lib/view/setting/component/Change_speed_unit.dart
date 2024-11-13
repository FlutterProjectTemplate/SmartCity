import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../base/app_settings/app_setting.dart';
import '../../../base/sqlite_manager/sqlite_manager.dart';
import '../../../constant_value/const_colors.dart';
import '../../../constant_value/const_fonts.dart';
import '../../../helpers/localizations/bloc/main_bloc.dart';

class ChangeUnitSpeed extends StatefulWidget {
  const ChangeUnitSpeed({super.key});

  @override
  State<ChangeUnitSpeed> createState() => _ChangeUnitSpeedState();
}

class _ChangeUnitSpeedState extends State<ChangeUnitSpeed> {
  final Color color = Color.fromRGBO(243, 243, 243, 1.0).withOpacity(0.5);
  List<String> speedUnits = ['mph', 'Km/h', 'm/s'];
  @override
  Widget build(BuildContext context) {
    String currentUnit = AppSetting.getSpeedUnit;
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
        itemCount: speedUnits.length,
        separatorBuilder: (ctx, index) => const SizedBox(
          height: 15,
        ),
        itemBuilder: (context, int index) {
          return Container(
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: (currentUnit == speedUnits[index]) ? ConstColors.primaryColor : ConstColors.surfaceColor),
                borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Container(
                height: 20,
                width: 20,
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                    width: 1
                  )
                ),
                child: Center(
                  child: (currentUnit == speedUnits[index]) ? Icon(Icons.circle, color: Colors.black, size: 16,) : Icon(Icons.circle, color: Colors.transparent,size: 16,),
                ),
              ),
              horizontalTitleGap: 15,
              title: Text(
                speedUnits[index],
                style: ConstFonts().copyWithTitle(
                    fontSize: 16, color: ConstColors.surfaceColor),
              ),
              trailing: Visibility(
                visible: (currentUnit == speedUnits[index]),
                child: const Icon(Icons.done, color: Colors.blueAccent),
              ),
              onTap: () async {
                setState(() {
                  SqliteManager()
                      .setStringForKey('speedUnit', speedUnits[index] ?? '');
                  context
                      .read<MainBloc>()
                      .add(MainChangeDarkModeEvent());
                });
              },
            ),
          );
        },
      ),
    );
  }
}
