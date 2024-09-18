import 'dart:convert';
import 'dart:typed_data';

import 'package:vibration/vibration.dart';
import 'package:flutter/material.dart';
import 'package:quick_blue/quick_blue.dart';
import 'package:gif/gif.dart';
import 'configPage.dart';
import 'globals.dart';
import 'default.dart';

class runningPage extends StatefulWidget {
  final Globals globals;

  runningPage({required this.globals}); // Required Global variables

  @override
  _RunningPageState createState() => _RunningPageState();
}

class _RunningPageState extends State<runningPage>
    with TickerProviderStateMixin {
  Defaults defaults = Defaults();
  late GifController _controller;
  bool isRunning = true;
  List<int> receivedValues = [];
  double runQualityPercentage = 100;

  @override
  void initState() {
    _controller = GifController(vsync: this);
    super.initState();
    loadConfigVariables();

    QuickBlue.setValueHandler(_handleValueChange);
    QuickBlue.setNotifiable(
      widget.globals.deviceId,
      widget.globals.bleServiceId,
      '8e7c2dae-0001-4b0d-b516-f525649c49ca',
      BleInputProperty.notification,
    );
  }

  @override
  void dispose() {
    super.dispose();
    QuickBlue.setValueHandler(null);
  }

  Future<void> loadConfigVariables() async {
    widget.globals.url = widget.globals.prefs.getString('url') ?? defaults.url;
    widget.globals.tenantId =
        widget.globals.prefs.getString('tenantId') ?? defaults.tenantId;
    widget.globals.deviceToken =
        widget.globals.prefs.getString('deviceToken') ?? defaults.deviceToken;
    widget.globals.bleServiceId =
        widget.globals.prefs.getString('bleServiceId') ?? defaults.bleServiceId;
    widget.globals.thingName =
        widget.globals.prefs.getString('thingName') ?? defaults.thingName;
    widget.globals.deviceName =
        widget.globals.prefs.getString('deviceName') ?? defaults.deviceName;
    widget.globals.imuCharacteristicId =
        widget.globals.prefs.getString('imuCharacteristicId') ??
            defaults.imuCharacteristicId;
    widget.globals.envCharacteristicId =
        widget.globals.prefs.getString('envCharacteristicId') ??
            defaults.envCharacteristicId;
    widget.globals.orientationCharacteristicId =
        widget.globals.prefs.getString('orientationCharacteristicId') ??
            defaults.orientationCharacteristicId;

    widget.globals.receivedIMUJsonValues = [];
  }

  void _handleValueChange(
      String deviceId, String characteristicId, Uint8List value) {
    if (characteristicId == "8e7c2dae-0001-4b0d-b516-f525649c49ca") {
      int intValue = parsePrediction(value, 1);

      setState(() {
        if (receivedValues.length > 20) {
          receivedValues.removeAt(0);
        }
        receivedValues.add(intValue);

        // Check if there are at least 15 occurrences of the value 1
        int countOnes = receivedValues.where((val) => val == 1).length;
        if (countOnes > 15) {
          if (isRunning) {
            isRunning = false;
            Vibration.vibrate(duration: 500);
          }
        }
        // Calculate the run quality percentage
        if (isRunning) {
          runQualityPercentage = ((20 - countOnes) / 20) * 100;
        }
      });

      print("intValue:" + intValue.toString());
    }
  }

  int parsePrediction(Uint8List value, int arrayLength) {
    final byteData = ByteData.view(value.buffer);
    final predictionData = List<int>.filled(arrayLength, 0);

    for (var i = 0; i < predictionData.length; i++) {
      if (i < value.lengthInBytes ~/ 2) {
        int intValue = byteData.getInt16(i * 2, Endian.little);
        predictionData[i] = intValue;
        print("intValue:" + intValue.toString());
      }
    }
    return predictionData[0];
  }

  Color getRunQualityColor() {
    if (runQualityPercentage >= 60) {
      return Colors.green;
    } else if (runQualityPercentage >= 30) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Running Page'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ConfigPage(globals: widget.globals)),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          if (isRunning) ...[
            Gif(
              image: AssetImage("assets/running.gif"),
              controller: _controller,
              fps: 20,
              autostart: Autostart.loop,
              placeholder: (context) => const Text('Loading...'),
            ),
            Text(
              'Stai facendo un lavoro fantastico! Continua così!',
              style: TextStyle(fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
            Text(
              'Qualità della corsa:',
              style: TextStyle(fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
            Text(
              '${runQualityPercentage.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 18.0,
                color: getRunQualityColor(),
              ),
              textAlign: TextAlign.center,
            )
          ] else ...[
            Gif(
              image: AssetImage("assets/tired.gif"),
              controller: _controller,
              fps: 20,
              autostart: Autostart.loop,
              placeholder: (context) => const Text('Loading...'),
            ),
            Text(
              'Complimenti per la corsa! Adesso prendi un attimo per rilassarti e ricaricare le energie!',
              style: TextStyle(fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () {
                QuickBlue.setNotifiable(
                  widget.globals.deviceId,
                  widget.globals.bleServiceId,
                  '8e7c2dae-0001-4b0d-b516-f525649c49ca',
                  BleInputProperty.notification,
                );
                setState(() {
                  isRunning = true;
                  receivedValues = [];
                  runQualityPercentage = 100;
                });
              },
              child: Text('Riprendi la corsa'),
            ),
            Text(
              'Percentuale raggiunta:',
              style: TextStyle(fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
            Text(
              '${runQualityPercentage.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 18.0,
                color: getRunQualityColor(),
              ),
              textAlign: TextAlign.center,
            )
          ],
        ]),
      ),
    );
  }
}
