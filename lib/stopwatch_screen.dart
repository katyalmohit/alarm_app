import 'package:flutter/material.dart';
import 'dart:async';

class StopwatchScreen extends StatefulWidget {
  @override
  _StopwatchScreenState createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  List<String> _laps = [];
  
  String _formattedTime = '00:00.00';
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  
  void _startStopwatch() {
    _stopwatch.start();
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        _formattedTime = _getFormattedTime(_stopwatch.elapsedMilliseconds);
      });
    });
  }
  
  void _stopStopwatch() {
    _stopwatch.stop();
    _timer?.cancel();
  }
  
  void _resetStopwatch() {
    setState(() {
      _stopwatch.reset();
      _laps.clear();
      _formattedTime = _getFormattedTime(0);
    });
  }
  
  void _recordLap() {
    setState(() {
      _laps.insert(0, _formattedTime);
    });
  }
  
  String _getFormattedTime(int milliseconds) {
    int minutes = (milliseconds / 60000).floor();
    int seconds = ((milliseconds % 60000) / 1000).floor();
    int hundredths = ((milliseconds % 1000) / 10).floor();
    
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${hundredths.toString().padLeft(2, '0')}';
  }
  
  @override
  Widget build(BuildContext context) {
    // Get available screen size
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Stopwatch',
          style: TextStyle(
            color: Colors.green,
            fontSize: 12, // Reduced from 14
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green, size: 16), // Reduced from 20
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero, // Remove padding
          constraints: BoxConstraints(), // Remove constraints
        ),
        toolbarHeight: 40, // Reduced from default
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5), // Reduced padding
          child: Column(
            mainAxisSize: MainAxisSize.min, // Use minimum space
            children: [
              // Main display
              Container(
                padding: EdgeInsets.symmetric(vertical: 10), // Reduced padding
                alignment: Alignment.center,
                child: FittedBox( // Ensures text fits available width
                  child: Text(
                    _formattedTime,
                    style: TextStyle(
                      fontSize: screenSize.width * 0.12, // Responsive font size
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ),
              
              // Control buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Reset button (left)
                  SizedBox(
                    width: 36, // Fixed small width
                    height: 36, // Fixed small height
                    child: ElevatedButton(
                      onPressed: _stopwatch.isRunning ? _recordLap : _resetStopwatch,
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.zero, // No padding
                        backgroundColor: Colors.grey[800],
                        minimumSize: Size.zero, // No minimum size constraint
                      ),
                      child: Icon(
                        _stopwatch.isRunning ? Icons.flag : Icons.refresh,
                        color: Colors.white,
                        size: 14, // Reduced size
                      ),
                    ),
                  ),
                  
                  SizedBox(width: 16), // Reduced spacing
                  
                  // Start/Stop button (right)
                  SizedBox(
                    width: 44, // Fixed small width, slightly larger than reset button
                    height: 44, // Fixed small height
                    child: ElevatedButton(
                      onPressed: _stopwatch.isRunning ? _stopStopwatch : _startStopwatch,
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.zero, // No padding
                        backgroundColor: _stopwatch.isRunning ? Colors.red : Colors.green,
                        minimumSize: Size.zero, // No minimum size constraint
                      ),
                      child: Icon(
                        _stopwatch.isRunning ? Icons.stop : Icons.play_arrow,
                        color: Colors.white,
                        size: 18, // Reduced size
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 8), // Reduced spacing
              
              // Laps list
              Expanded(
                child: _laps.isEmpty
                    ? Center(
                        child: Text(
                          'Record laps',
                          style: TextStyle(color: Colors.white54, fontSize: 10), // Reduced font size
                        ),
                      )
                    : ListView.builder(
                        itemCount: _laps.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6), // Reduced padding
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(6), // Smaller radius
                            ),
                            margin: EdgeInsets.symmetric(vertical: 1), // Reduced margin
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Lap ${_laps.length - index}',
                                  style: TextStyle(color: Colors.white70, fontSize: 10), // Reduced font size
                                ),
                                Text(
                                  _laps[index],
                                  style: TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'monospace'), // Reduced font size
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
      ),
    );
  }
}