import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CircularCalculator(),
    );
  }
}

class CircularCalculator extends StatefulWidget {
  const CircularCalculator({super.key});

  @override
  State<CircularCalculator> createState() => _CircularCalculatorState();
}

class _CircularCalculatorState extends State<CircularCalculator> {
  double angle = 0;

  String input = "0";
  double num1 = 0;
  String operator = "";

  final List<String> numbers = ["1","2","3","4","5","6","7","8","9","0"];

  /// NUMBER CLICK
  void onNumberTap(String num) {
    setState(() {
      if (input == "0") {
        input = num;
      } else {
        input += num;
      }
    });
  }

  /// SET OPERATOR
  void setOperator(String op) {
    num1 = double.parse(input);
    operator = op;
    input = "0";
  }

  /// CALCULATE
  void calculate() {
    double num2 = double.parse(input);
    double result = 0;

    switch (operator) {
      case "+":
        result = num1 + num2;
        break;
      case "-":
        result = num1 - num2;
        break;
      case "*":
        result = num1 * num2;
        break;
      case "/":
        result = num1 / num2;
        break;
    }

    setState(() {
      input = result.toString();
      operator = "";
    });
  }

  /// CLEAR
  void clear() {
    setState(() {
      input = "0";
      operator = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            /// DISPLAY
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                input,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),

            /// CIRCULAR DIAL
            Expanded(
              child: Center(
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      angle += details.delta.dx * 0.01;
                    });
                  },
                  child: Transform.rotate(
                    angle: angle,
                    child: SizedBox(
                      width: 300,
                      height: 300,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [

                          /// NUMBER BUTTONS
                          ...List.generate(numbers.length, (index) {
                            double angleStep =
                                (2 * pi / numbers.length) * index - pi / 2;

                            return Transform.translate(
                              offset: Offset(
                                120 * cos(angleStep),
                                120 * sin(angleStep),
                              ),
                              child: GestureDetector(
                                onTap: () => onNumberTap(numbers[index]),
                                child: circleButton(numbers[index]),
                              ),
                            );
                          }),

                          /// CENTER (=)
                          GestureDetector(
                            onTap: calculate,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orange.withOpacity(0.6),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  )
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  "=",
                                  style: TextStyle(
                                    fontSize: 36,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            /// OPERATORS
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Wrap(
                spacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  opButton("+"),
                  opButton("-"),
                  opButton("*"),
                  opButton("/"),
                  opButton("C"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// NUMBER BUTTON UI
  Widget circleButton(String text) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  /// OPERATOR BUTTON UI
  Widget opButton(String text) {
    return GestureDetector(
      onTap: () {
        if (text == "C") {
          clear();
        } else {
          setOperator(text);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: text == "C" ? Colors.red : Colors.orange,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}