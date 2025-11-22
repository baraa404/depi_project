import 'package:depi_project/views/screens/welcome_screen2.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class WelcomeScreen1 extends StatelessWidget {
  const WelcomeScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 66),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: SizedBox(
                        height: 300,
                        width: 400,

                        child: Image.asset(fit: BoxFit.cover, 'assets/2.png'),
                      ),
                    ),

                    SizedBox(height: 100),
                    //
                    SizedBox(
                      width: double.infinity,
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(text: 'Welcome to\n'),
                            TextSpan(
                              text: 'Healthy',
                              style: TextStyle(color: Color(0xFF34C759)),
                            ),
                            TextSpan(text: ' Scan'),
                          ],
                        ),
                      ),
                    ),
                    //
                    SizedBox(height: 12),
                    //
                    SizedBox(
                      width: double.infinity,
                      child: Opacity(
                        opacity: 0.8,
                        child: Text(
                          "Scan a product's barcode to see its health score, ingredients highlights, and quick advice.",
                          style: TextStyle(fontSize: 13),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              Column(
                children: [
                  const SizedBox(height: 25),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: Size(165, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: WelcomeScreen2(),
                          duration: Duration(milliseconds: 500),
                        ),
                        (route) => false,
                      );
                    },
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
