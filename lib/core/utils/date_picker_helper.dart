import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<DateTime?> showLocalizedDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  DatePickerMode initialDatePickerMode = DatePickerMode.day,
  String? helpText,
  String? cancelText,
  String? confirmText,
  SelectableDayPredicate? selectableDayPredicate,
}) async {
  final currentLocale = Localizations.localeOf(context);

  try {
    await initializeDateFormatting(currentLocale.languageCode, null);
  } catch (_) {
    // Ignore date formatting initialization failure
  }

  final String localizedCancel =
      cancelText ?? (currentLocale.languageCode == 'ar' ? 'إلغاء' : 'Cancel');
  final String localizedConfirm =
      confirmText ?? (currentLocale.languageCode == 'ar' ? 'حسناً' : 'OK');

  if (!context.mounted) return null;

  return await showDatePicker(
    context: context,
    locale: currentLocale,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    initialDatePickerMode: initialDatePickerMode,
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    helpText: helpText,
    cancelText: localizedCancel,
    confirmText: localizedConfirm,
    selectableDayPredicate: selectableDayPredicate,
  );
}

Future<TimeOfDay?> showLocalizedTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
  TimePickerEntryMode initialEntryMode = TimePickerEntryMode.dial,
  String? helpText,
  String? cancelText,
  String? confirmText,
  String? hourLabelText,
  String? minuteLabelText,
  TransitionBuilder? builder,
}) async {
  final currentLocale = Localizations.localeOf(context);

  try {
    await initializeDateFormatting(currentLocale.languageCode, null);
  } catch (_) {
    // Ignore date formatting initialization failure
  }

  final String localizedCancel =
      cancelText ?? (currentLocale.languageCode == 'ar' ? 'إلغاء' : 'Cancel');
  final String localizedConfirm =
      confirmText ?? (currentLocale.languageCode == 'ar' ? 'حسناً' : 'OK');

  if (!context.mounted) return null;

  return await showTimePicker(
    context: context,
    initialTime: initialTime,
    initialEntryMode: initialEntryMode,
    helpText: helpText,
    cancelText: localizedCancel,
    confirmText: localizedConfirm,
    hourLabelText: hourLabelText,
    minuteLabelText: minuteLabelText,
    builder: builder,
  );
}
