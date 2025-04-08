import 'package:flutter/material.dart';
import 'dart:async';

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _selectedMinutes = 0;
  int _selectedSeconds = 0;
  int _remainingSeconds = 0;
  Timer? _timer;
  bool _isRunning = false;
  bool _isPaused = false;

  FixedExtentScrollController _minuteController = FixedExtentScrollController(initialItem: 0);
  FixedExtentScrollController _secondController = FixedExtentScrollController(initialItem: 0);

  @override
  void dispose() {
    _timer?.cancel();
    _minuteController.dispose();
    _secondController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      if (!_isPaused) {
        _remainingSeconds = _selectedMinutes * 60 + _selectedSeconds;
      }
      _isRunning = true;
      _isPaused = false;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
          _isRunning = false;
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isPaused = true;
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isPaused = false;
      _remainingSeconds = 0;
    });
  }

  void _setQuickTimer(int minutes, int seconds) {
    setState(() {
      _selectedMinutes = minutes;
      _selectedSeconds = seconds;
      _minuteController.jumpToItem(minutes);
      _secondController.jumpToItem(seconds);
    });
  }

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Timer',
          style: TextStyle(
            color: Colors.green,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green, size: 16),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
        ),
        toolbarHeight: 36,
      ),
      body: SafeArea(
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    child: SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height -
              AppBar().preferredSize.height -
              MediaQuery.of(context).padding.vertical,
        ),
        child: IntrinsicHeight(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green, width: 1),
                ),
                child: Text(
                  _isRunning || _isPaused
                      ? _formatTime(_remainingSeconds)
                      : _formatTime(_selectedMinutes * 60 + _selectedSeconds),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'monospace',
                  ),
                ),
              ),

              if (!_isRunning && !_isPaused)
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    _presetButton("1m", () => _setQuickTimer(1, 0)),
                    _presetButton("3m", () => _setQuickTimer(3, 0)),
                    _presetButton("5m", () => _setQuickTimer(5, 0)),
                    _presetButton("10m", () => _setQuickTimer(10, 0)),
                  ],
                ),

              if (!_isRunning && !_isPaused)
                Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.grey[900]!.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: _buildClippedTimePicker(
                          controller: _minuteController,
                          selectedValue: _selectedMinutes,
                          onChanged: (index) => setState(() => _selectedMinutes = index),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Text(':', style: TextStyle(color: Colors.green, fontSize: 14)),
                      ),
                      Flexible(
                        child: _buildClippedTimePicker(
                          controller: _secondController,
                          selectedValue: _selectedSeconds,
                          onChanged: (index) => setState(() => _selectedSeconds = index),
                        ),
                      ),
                    ],
                  ),
                ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isRunning || _isPaused)
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: ElevatedButton(
                        onPressed: _resetTimer,
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.grey[800],
                          minimumSize: Size.zero,
                        ),
                        child: Icon(Icons.refresh, color: Colors.white, size: 12),
                      ),
                    ),
                  if (_isRunning || _isPaused) SizedBox(width: 8),
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: ElevatedButton(
                      onPressed: (_selectedMinutes > 0 || _selectedSeconds > 0 || _isPaused)
                          ? (_isRunning ? _pauseTimer : _startTimer)
                          : null,
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.zero,
                        backgroundColor: _isRunning ? Colors.orange : Colors.green,
                        disabledBackgroundColor: Colors.grey[700],
                        minimumSize: Size.zero,
                      ),
                      child: Icon(
                        _isRunning ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
    ),
  ),
      ),
    );
  }

  Widget _presetButton(String label, VoidCallback onPressed) {
    return SizedBox(
      height: 20,
      width: 30,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[850],
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
          textStyle: TextStyle(fontSize: 9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildClippedTimePicker({
    required FixedExtentScrollController controller,
    required int selectedValue,
    required Function(int) onChanged,
  }) {
    return ClipRect(
      child: Container(
        height: 55,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 18,
              left: 5,
              right: 5,
              child: Container(
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            ListWheelScrollView.useDelegate(
              controller: controller,
              itemExtent: 18,
              physics: FixedExtentScrollPhysics(),
              onSelectedItemChanged: onChanged,
              overAndUnderCenterOpacity: 0.0,
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: 60,
                builder: (context, index) {
                  return Center(
                    child: Text(
                      index.toString().padLeft(2, '0'),
                      style: TextStyle(
                        color: selectedValue == index ? Colors.green : Colors.white,
                        fontSize: 12,
                        fontWeight:
                            selectedValue == index ? FontWeight.bold : FontWeight.normal,
                      ),
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
