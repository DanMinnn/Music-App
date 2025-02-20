import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music/core/configs/assets/app_vectors.dart';
import 'package:music/presentation/intro/pages/get_started.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(AppVectors.logo),
      ),
    );
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => GetStartedPage()));
  }
}
