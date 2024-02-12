import 'dart:async';

import 'package:flutter/material.dart';
import 'sandbox.dart';

void main() => runApp(SandboxApp());

class SandboxApp extends StatefulWidget {
  @override
  _SandboxAppState createState() => _SandboxAppState();
}

class SandboxPage extends StatefulWidget {
  const SandboxPage({Key? key}) : super(key: key);

  @override
  _SandboxPageState createState() => _SandboxPageState();
}

class _SandboxAppState extends State<SandboxApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SandboxPage(),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
    );
  }
}

class _SandboxPageState extends State<SandboxPage> {
  Timer? _timer;
  final SandboxModel model =
      SandboxModel(rows: 50, cols: 50); // Adjust size as needed
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        model.update();
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void addSand(Offset globalPosition) {
    RenderBox box = context.findRenderObject() as RenderBox;
    final offset = box.globalToLocal(globalPosition);
    final dx = offset.dx / (box.size.width / model.cols);
    final dy = offset.dy / (box.size.height / model.rows);
    model.addSand(dy.floor(), dx.floor());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sandbox Simulation'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: GestureDetector(
        onPanStart: (details) => addSand(details.globalPosition),
        onPanUpdate: (details) => addSand(details.globalPosition),
        child: CustomPaint(
          size: Size.infinite,
          painter: SandboxPainter(model: model),
        ),
      ),
    );
  }
}

class SandboxPainter extends CustomPainter {
  final SandboxModel model;

  SandboxPainter({required this.model});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final cellWidth = size.width / model.cols;
    final cellHeight = size.height / model.rows;

    for (int row = 0; row < model.rows; row++) {
      for (int col = 0; col < model.cols; col++) {
        if (model.grid[row][col]) {
          paint.color = Colors.brown; // Sand color
          canvas.drawRect(
              Rect.fromLTWH(
                  col * cellWidth, row * cellHeight, cellWidth, cellHeight),
              paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
