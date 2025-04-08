import 'package:flutter/material.dart';
import 'alarm_home.dart';
import 'set_alarm.dart';

void main() => runApp(const AlarmApp());

class AlarmApp extends StatelessWidget {
  const AlarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (_) =>  AlarmHomeScreen(),
        '/set-alarm': (_) => const SetAlarmScreen(),
      },
    );
  }
}
