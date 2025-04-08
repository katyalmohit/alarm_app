import 'package:flutter/material.dart';
import 'custom_time_picker.dart';
import 'stopwatch_screen.dart';
import 'timer_screen.dart';

class AlarmHomeScreen extends StatefulWidget {
  @override
  _AlarmHomeScreenState createState() => _AlarmHomeScreenState();
}

class _AlarmHomeScreenState extends State<AlarmHomeScreen> {
  List<Map<String, dynamic>> alarms = [];

  void _addAlarm() async {
    TimeOfDay? pickedTime = await CustomTimePicker.show(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final hour = pickedTime.hourOfPeriod.toString().padLeft(2, '0');
      final minute = pickedTime.minute.toString().padLeft(2, '0');
      final period = pickedTime.period == DayPeriod.am ? 'AM' : 'PM';
      final formattedTime = '$hour:$minute $period';

      setState(() {
        alarms.add({'time': formattedTime, 'enabled': true});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Alarms',
          style: TextStyle(
            color: Colors.green,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.green, size: 20),
            onSelected: (value) {
              switch (value) {
                case 'alarm':
                  // Already on alarm screen
                  break;
                case 'stopwatch':
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => StopwatchScreen())
                  );
                  break;
                case 'timer':
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => TimerScreen())
                  );
                  break;
              }
            },
            padding: EdgeInsets.zero,
            iconSize: 18,
            // Make the popup menu smaller
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'alarm',
                  height: 24,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text('Alarm', style: TextStyle(fontSize: 10, color: Colors.green)),
                ),
                PopupMenuItem<String>(
                  value: 'stopwatch',
                  height: 24,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text('Stopwatch', style: TextStyle(fontSize: 10, color: Colors.green)),
                ),
                PopupMenuItem<String>(
                  value: 'timer',
                  height: 24, 
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text('Timer', style: TextStyle(fontSize: 10, color: Colors.green)),
                ),
              ];
            },
            // Make the popup menu appear near the action button
            offset: Offset(0, 20),
            // Style the popup menu
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: Colors.grey[850],
            elevation: 4,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.add,
          color: Colors.black,
          size: 16,
        ),
        onPressed: _addAlarm,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        child: Column(
          children: [
            Expanded(
              child: alarms.isEmpty
                  ? Center(
                      child: Text(
                        'No alarms yet',
                        style: TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                    )
                  : ListView.builder(
                      itemCount: alarms.length,
                      itemBuilder: (context, index) {
                        final alarm = alarms[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    alarm['time'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          alarm['enabled']
                                              ? Colors.white
                                              : Colors.grey[600],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Alarm',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          alarm['enabled']
                                              ? Colors.white70
                                              : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              Switch(
                                value: alarm['enabled'],
                                onChanged: (value) {
                                  setState(() {
                                    alarms[index]['enabled'] = value;
                                  });
                                },
                                activeColor: Colors.greenAccent,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
