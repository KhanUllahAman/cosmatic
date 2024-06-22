import 'package:cosmatic/select_Type/select_type.dart';
import 'package:cosmatic/utils/app_colors.dart';
import 'package:cosmatic/utils/asset_images.dart';
import 'package:cosmatic/utils/routes.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // Full screen image
          Positioned.fill(
            child: Image.asset(
              "assets/images/welcome.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AssetImages().appLogo,
                          width: size.width * 15,
                        ),
                      ]
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 50,
                          width: size.width,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primaryColor,
                            ),
                            onPressed: () {
                              Routes.push(const SelectType(), context);
                            },
                            child: Text(
                              "Get started",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * 0.045,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
