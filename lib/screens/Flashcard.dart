import 'package:flutter/material.dart';
import 'dart:math';



class FlashcardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flashcard App',
      home: FlashcardPage(),
    );
  }
}

class FlashcardPage extends StatefulWidget {
  @override
  _FlashcardPageState createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  bool isFront = true;

  void flipCard() {
    setState(() {
      isFront = !isFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcard'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: GestureDetector(
          onTap: flipCard,
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
              return AnimatedBuilder(
                animation: rotateAnim,
                builder: (context, child) {
                  final isUnder = (ValueKey(isFront) != child?.key);
                  var tilt = (animation.value - 0.5).abs() - 0.5;
                  tilt *= isUnder ? -1.0 : 1.0;
                  return Transform(
                    transform: Matrix4.rotationY(rotateAnim.value)..setEntry(3, 0, tilt),
                    child: child,
                    alignment: Alignment.center,
                  );
                },
                child: child,
              );
            },
            child: isFront
                ? FlashcardFront(key: ValueKey(true))
                : FlashcardBack(key: ValueKey(false)),
          ),
        ),
      ),
    );
  }
}

class FlashcardFront extends StatelessWidget {
  const FlashcardFront({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(1),
      width: 300,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5)),
        ],
      ),
      child: Center(
        child: Text(
          'Front of the Card',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}

class FlashcardBack extends StatelessWidget {
  const FlashcardBack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(2),
      width: 300,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5)),
        ],
      ),
      child: Center(
        child: Text(
          'Back of the Card',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}
