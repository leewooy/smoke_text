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
  late double _windDirection;

  @override
  void initState() {
    super.initState();
    _generateWindDirection();
    _setupAnimations();
  }

  void _generateWindDirection() {
    _windDirection = Random().nextDouble() * 2 * pi;
  }

  void _setupAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
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
                windDirection: _windDirection,
                progress: _controller.value,
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
  final double windDirection;
  final double progress;

  SmokePainter({
    required this.text,
    required this.opacity,
    required this.windDirection,
    required this.progress,
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

    final textSize = textPainter.size;
    final textPosition = Offset(
      size.width / 2 - textSize.width / 2,
      size.height / 2 - textSize.height / 2
    );

    final int copies = 8;
    final double maxSpread = 30.0;
    
    for (int copy = 0; copy < copies; copy++) {
      final double spread = (progress * maxSpread * copy) / copies;
      final double layerOpacity = opacity * (1 - (copy / copies));

      // 바람 방향을 중심으로 한 원뿔 형태로 퍼지게 함
      double angleVariation = pi / 4; // 퍼지는 각도 범위
      for (double angle = windDirection - angleVariation; 
           angle <= windDirection + angleVariation; 
           angle += angleVariation / 4) {
        
        final xSpread = cos(angle) * spread * (1.0 + progress);
        final ySpread = sin(angle) * spread * (1.0 + progress);

        final builder = ui.ParagraphBuilder(ui.ParagraphStyle(
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
        ));
        
        builder.pushStyle(ui.TextStyle(
          color: Colors.white.withAlpha((layerOpacity * 255 / copies).toInt()),
          fontSize: 20,
        ));
        
        builder.addText(text);
        final paragraph = builder.build();
        paragraph.layout(ui.ParagraphConstraints(width: size.width));

        canvas.drawParagraph(
          paragraph,
          Offset(
            textPosition.dx + xSpread,
            textPosition.dy + ySpread
          )
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant SmokePainter oldDelegate) {
    return oldDelegate.opacity != opacity ||
        oldDelegate.windDirection != windDirection ||
        oldDelegate.progress != progress;
  }
}
