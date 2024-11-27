import 'package:flutter/material.dart';
import 'package:smart_city/l10n/l10n_extention.dart';

import '../../../constant_value/const_colors.dart';
import '../../../constant_value/const_fonts.dart';
import '../../../helpers/localizations/language_helper.dart';
import 'country_flag.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({super.key});

  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  @override
  Widget build(BuildContext context) {
    List<LanguageInfo> languageInfo = LanguageHelper().supportedLanguages;
    Locale selectedLanguage = LanguageHelper().getCurrentLocale();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title Section
          Text(
            L10nX.getStr.language,
            style: ConstFonts().copyWithTitle(
              fontSize: 25,
              color: ConstColors.surfaceColor,
            ),
          ),
          const SizedBox(height: 20),

          ListView.separated(
            shrinkWrap: true,
            itemCount: languageInfo.length,
            separatorBuilder: (ctx, index) => const SizedBox(height: 15),
            itemBuilder: (context, int index) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: selectedLanguage.languageCode ==
                        languageInfo[index].languageCode
                        ? ConstColors.primaryColor
                        : ConstColors.surfaceColor,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CountryFlag(countryCode: languageInfo[index].country!),
                  horizontalTitleGap: 15,
                  title: Text(
                    languageInfo[index].language!,
                    style: ConstFonts().copyWithTitle(
                      fontSize: 16,
                      color: ConstColors.surfaceColor,
                    ),
                  ),
                  trailing: Visibility(
                    visible: selectedLanguage.languageCode ==
                        languageInfo[index].languageCode,
                    child: const Icon(Icons.done, color: Colors.blueAccent),
                  ),
                  onTap: () {
                    setState(() {
                      LanguageHelper().changeLanguage(
                        LanguageInfo(
                          languageIndex: languageInfo[index].languageIndex,
                        ),
                        context,
                      );
                      Navigator.pop(context);
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
