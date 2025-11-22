import 'package:depi_project/views/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class WelcomeScreen2 extends StatelessWidget {
  const WelcomeScreen2({super.key});

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

                        child: Image.asset(fit: BoxFit.cover, 'assets/1.png'),
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
                            TextSpan(text: 'Clear Healthy\n'),
                            TextSpan(
                              text: 'Food',
                              style: TextStyle(color: Color(0xFF34C759)),
                            ),
                            TextSpan(text: ' insights'),
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
                          "Point your camera at a barcode to get a health score, ingredient highlights, and easy tips.",
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
                          child: RegisterScreen(),
                          duration: Duration(milliseconds: 500),
                        ),
                        (route) => false,
                      );
                    },
                    child: Text(
                      'Start scanning',
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
