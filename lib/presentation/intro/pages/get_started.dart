import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music/common/widgets/button/basic_app_button.dart';
import 'package:music/core/configs/assets/app_images.dart';
import 'package:music/core/configs/assets/app_vectors.dart';
import 'package:music/core/configs/theme/app_colors.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.introBg),
                fit: BoxFit.fitWidth,
              ),
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  SvgPicture.asset(
                    AppVectors.logo,
                    fit: BoxFit.scaleDown,
                  ),
                  Spacer(),
                  Text(
                    'Enjoy Listening To Music',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 21,
                  ),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sagittis enim purus sed phasellus. Cursus ornare id scelerisque aliquam.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  BasicAppButton(onPressed: () {}, title: 'Get Started')
                ],
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.15),
          )
        ],
      ),
    );
  }
}
