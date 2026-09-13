import 'package:flower_app/core/locale/locale_cubit.dart';
import 'package:flower_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeCubit = context.watch<LocaleCubit>();
    final isArabic = localeCubit.state.languageCode == 'ar';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.changeLanguageTitle,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        _languageItem(
          context: context,
          label: l10n.languageArabic,
          selected: isArabic,
          onTap: () {
            localeCubit.changeLocale(const Locale('ar'));
            Navigator.pop(context);
          },
        ),
        const SizedBox(height: 10),
        _languageItem(
          context: context,
          label: l10n.languageEnglish,
          selected: !isArabic,
          onTap: () {
            localeCubit.changeLocale(const Locale('en'));
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _languageItem({
    required BuildContext context,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(label, style: const TextStyle(fontSize: 12)),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}