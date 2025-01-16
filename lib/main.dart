import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui' as ui;

class SmokeText extends StatefulWidget {
  final String text;

  const SmokeText({
    super.key,
    required this.text,
  });

  @override
  State<SmokeText> createState() => _SmokeTextState();
}

class _SmokeTextState extends State<SmokeText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _yOffsetAnimation;
  late Animation<double> _xOffsetAnimation;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _yOffsetAnimation = Tween<double>(begin: 0.0, end: -100.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _xOffsetAnimation = Tween<double>(begin: 0.0, end: 50.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override 
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              size: constraints.biggest,
              painter: SmokePainter(
                text: widget.text,
                opacity: _opacityAnimation.value,
                yOffset: _yOffsetAnimation.value,
                xOffset: _xOffsetAnimation.value,
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class SmokePainter extends CustomPainter {
  final String text;
  final double opacity;
  final double yOffset;
  final double xOffset;
  final Random random = Random();

  SmokePainter({
    required this.text,
    required this.opacity,
    required this.yOffset,
    required this.xOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final textSize = textPainter.size; // 텍스트 크기 계산

    final textPosition = Offset(size.width / 2 - textSize.width / 2,
        size.height / 2 - textSize.height / 2);

    for (int i = 0; i < text.length; i++) {
      final charPosition = Offset(
        textPosition.dx + textPainter.width * (i / text.length),
        textPosition.dy,
      );

      final randomXOffset = (random.nextDouble() - 0.5) * xOffset;

      final builder = ui.ParagraphBuilder(ui.ParagraphStyle(
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      ));
      builder.pushStyle(ui.TextStyle(
        color: Colors.white.withAlpha((opacity * 255).toInt()),
        fontSize: 20,
      ));
      builder.addText(text[i]);
      final paragraph = builder.build();
      paragraph
          .layout(ui.ParagraphConstraints(width: textSize.width)); // 텍스트 너비에 맞춤

      canvas.drawParagraph(paragraph,
          Offset(charPosition.dx + randomXOffset, charPosition.dy + yOffset));
    }
  }

  @override
  bool shouldRepaint(covariant SmokePainter oldDelegate) {
    return oldDelegate.opacity != opacity ||
        oldDelegate.yOffset != yOffset ||
        oldDelegate.xOffset != xOffset;
  }
}

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
  Key _smokeKey = UniqueKey(); // 키 추가

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // 배경색 추가
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Click button',
              style: TextStyle(color: Colors.white), // 텍스트 색상 추가
            ),
            Text(
              '$num',
              style: TextStyle(color: Colors.white), // 텍스트 색상 추가
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  num++;
                  _smokeKey = UniqueKey(); // 버튼 클릭시 새로운 키 생성
                });
              },
              child: const Text('Click me'),
            ),
            const SizedBox(height: 20),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 100),
              child: SmokeText(
                key: _smokeKey, // 키 설정
                text: '$num',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
