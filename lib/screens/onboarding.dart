import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_record/constants/images.dart';
import 'package:shop_record/screens/records/landing_screen.dart';
import 'package:shop_record/widgets/my_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent.shade100,
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                appLogo,
                height: 120,
                width: 120,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Shop Record",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Keep track of your shop income and expenses updated",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyButton(
        onPressed: () {
          Get.offAll(() => const LandingScreen());
        },
        text: "Proceed",
      ),
    );
  }
}
