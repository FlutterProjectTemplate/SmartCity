import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_city/l10n/l10n_extention.dart';

import '../../../base/app_settings/app_setting.dart';
import '../../../base/sqlite_manager/sqlite_manager.dart';
import '../../../constant_value/const_colors.dart';
import '../../../constant_value/const_fonts.dart';
import '../../../helpers/localizations/bloc/main_bloc.dart';

class ChangeUnitSpeed extends StatefulWidget {
  final Function(bool) onChange;
  const ChangeUnitSpeed({super.key, required this.onChange});

  @override
  State<ChangeUnitSpeed> createState() => _ChangeUnitSpeedState();
}

class _ChangeUnitSpeedState extends State<ChangeUnitSpeed> {
  final Color color = Color.fromRGBO(243, 243, 243, 1.0).withOpacity(0.5);
  List<String> speedUnits = ['mph', 'km/h', 'm/s'];

  @override
  Widget build(BuildContext context) {
    String currentUnit = AppSetting.getSpeedUnit;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            L10nX.getStr.change_speed_unit,
            style: ConstFonts().copyWithTitle(
              fontSize: 25,
              color: ConstColors.surfaceColor,
            ),
          ),
          const SizedBox(height: 20),

          ListView.separated(
            shrinkWrap: true,
            itemCount: speedUnits.length,
            separatorBuilder: (ctx, index) => const SizedBox(height: 15),
            itemBuilder: (context, int index) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: (currentUnit == speedUnits[index])
                        ? ConstColors.primaryColor
                        : ConstColors.surfaceColor,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Container(
                    height: 20,
                    width: 20,
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.circle,
                        color: (currentUnit == speedUnits[index])
                            ? Colors.black
                            : Colors.transparent,
                        size: 16,
                      ),
                    ),
                  ),
                  horizontalTitleGap: 15,
                  title: Text(
                    speedUnits[index],
                    style: ConstFonts().copyWithTitle(
                      fontSize: 16,
                      color: ConstColors.surfaceColor,
                    ),
                  ),
                  trailing: Visibility(
                    visible: (currentUnit == speedUnits[index]),
                    child: const Icon(Icons.done, color: Colors.blueAccent),
                  ),
                  onTap: () async {
                    widget.onChange(true);
                    setState(() {
                      SqliteManager().setStringForKey('speedUnit', speedUnits[index]);
                      context.read<MainBloc>().add(MainChangeDarkModeEvent());
                      Navigator.of(context).pop();
                    });
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

