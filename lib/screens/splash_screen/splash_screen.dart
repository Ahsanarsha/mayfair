import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mayfair/export.dart';

class SplashScreen extends GetView<SplashController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      initState: (_) async{
        Future.delayed(Duration(seconds: 2), ()async {
          //print("ASD");
          //print(await controller.checkLoggedIn());
          if(await controller.checkLoggedIn()) {
              await controller.setAlreadyLoggedIn();
            }
          else{
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginScreen()));
          }

        });
      },
      builder: (_) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color.fromRGBO(163, 12, 18, 1),
          body: getBody(context),
        );
      },
    );
  }


  Widget getBody(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(237, 28, 36, 1),
              Color.fromRGBO(163, 12, 18, 1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getWhiteLogo(),
            SizedBox(
              height: 25.3.h,
            ),
            getSubtitleText(),
          ],
        ),
      ),
    );
  }

  Widget getWhiteLogo() {
    return Image.asset(
      appAssets.mayfairSimple,
      width: 181.w,
      height: 109.66.h,
    );
  }

  Widget getSubtitleText() {
    return Text(
      appConstants.salesTeamApp,
      style: GoogleFonts.inter(
          fontWeight: FontWeight.w700,
          fontSize: 20.sp,
          color: appColors.white
      ),
    );
  }
}
