import 'package:flutter/material.dart';
import 'package:theta_client_flutter/theta_client_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'THETA Client Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'THETA Client Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _thetaClientFlutter = ThetaClientFlutter();
  String screenInfo = '';

  @override
  void initState() {
    super.initState();
    try {
      _thetaClientFlutter.initialize();
      screenInfo = 'camera is initialized';
      print(screenInfo);
    } catch (e) {
      screenInfo = 'Not initialized. confirm camera is connect with WiFi: $e';
      print(screenInfo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text('Flutter demonstration of RICOH THETA official SDK'),
              ElevatedButton(
                onPressed: () async {
                  final info = await _thetaClientFlutter.getThetaInfo();
                  setState(() {
                    screenInfo =
                        'firmwareVersion: ${info.firmwareVersion}\n'
                        'serialNumber: ${info.serialNumber}\n'
                        'GPS equipped: ${info.hasGps}\n'
                        'Gyro equipped: ${info.hasGyro}\n'
                        'uptime: ${info.uptime}';
                    print(screenInfo);
                  });
                },
                child: const Text('Get Info'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final thetaState = await _thetaClientFlutter.getThetaState();
                  setState(() {
                    screenInfo =
                        'charging: ${thetaState.chargingState}\n'
                        'batteryLevel: ${thetaState.batteryLevel}\n'
                        'latestFileUrl: ${thetaState.latestFileUrl}';
                    print(screenInfo);
                  });
                },
                child: const Text('Get State'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final builder = _thetaClientFlutter.getPhotoCaptureBuilder();
                  var photoCapture = await builder.build();
                  photoCapture.takePicture(
                    (onSuccess) {
                      setState(() {
                        screenInfo = 'took picture: $onSuccess';
                        print(screenInfo);
                      });
                    },
                    (onError) {
                      setState(() {
                        screenInfo = 'error: $onError';
                        print(screenInfo);
                      });
                    },
                  );
                },
                child: const Text('Take Picture'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await _thetaClientFlutter.initialize();
                    screenInfo = 'camera is initialized';
                    print(screenInfo);
                  } catch (e) {
                    screenInfo =
                        'Not initialized. confirm camera is connect with WiFi: $e';
                    print(screenInfo);
                  }
                },
                child: const Text('Initialize'),
              ),
              SelectableText(screenInfo),
            ],
          ),
        ),
      ),
    );
  }
}
