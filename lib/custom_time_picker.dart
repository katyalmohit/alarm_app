import 'package:flutter/material.dart';

class CustomTimePicker {
  /// Shows a compact time picker dialog optimized for watch screens
  static Future<TimeOfDay?> show({
    required BuildContext context,
    required TimeOfDay initialTime,
  }) async {
    return showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            // Reduce the size of the dialog
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              contentTextStyle: TextStyle(fontSize: 10),
            ),
            // Make the time picker components smaller
            timePickerTheme: TimePickerThemeData(
              dialHandColor: Colors.greenAccent,
              hourMinuteTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              dayPeriodTextStyle: TextStyle(
                fontSize: 10,
              ),
              helpTextStyle: TextStyle(
                fontSize: 8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              hourMinuteShape: CircleBorder(),
              dayPeriodShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              dayPeriodBorderSide: BorderSide(width: 1),
              hourMinuteColor: Colors.grey[850],
              backgroundColor: Colors.grey[900],
              dialTextColor: Colors.white,
              entryModeIconColor: Colors.white70,
            ),
          ),
          child: MediaQuery(
            // Scale down the entire time picker
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: 0.65,
              alwaysUse24HourFormat: false,
              size: Size(180, 180),
            ),
            child: Container(
              height: 10,
              width: 10,
              child: child!,
            ),
          ),
        );
      },
    );
  }
}