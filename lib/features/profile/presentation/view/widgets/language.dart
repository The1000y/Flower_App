import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LanguageBottomSheet extends StatefulWidget {
  const LanguageBottomSheet();

  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet> {
  String selectedLanguage = AppStrings.languageEnglish;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.changeLanguageTitle,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        _languageItem(AppStrings.languageArabic),
        const SizedBox(height: 10),
        _languageItem(AppStrings.languageEnglish),
      ],
    );
  }

  Widget _languageItem(String language) {
    final isSelected = selectedLanguage == language;

    return InkWell(
      onTap: () {
        setState(() {
          selectedLanguage = language;
        });

        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(language, style: const TextStyle(fontSize: 12)),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
