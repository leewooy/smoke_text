import 'package:flutter/material.dart';
import 'widgets/smoke_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int num = 0;
  Key _smokeKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Click button',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              '$num',
              style: const TextStyle(color: Colors.white),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  num++;
                  _smokeKey = UniqueKey(); // 새로운 위젯을 생성하여 새로운 바람 방향 생성
                });
              },
              child: const Text('Click me'),
            ),
            const SizedBox(height: 20),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 100),
              child: SmokeText(
                key: _smokeKey,
                text: '$num',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
