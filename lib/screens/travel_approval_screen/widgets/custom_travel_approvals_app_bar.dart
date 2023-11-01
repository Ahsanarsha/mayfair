
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mayfair/export.dart';
import 'package:mayfair/res/export.dart';

import '../travel_approval_screen_controller.dart';

class TravelTravelApprovalsController extends StatelessWidget implements PreferredSizeWidget{

  final GlobalKey<ScaffoldState> scaffoldKey;
  const TravelTravelApprovalsController({Key? key, required this.scaffoldKey}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TravelApprovalsController>(
      builder: (controller) => AppBar(
        leading: Container(),
        backgroundColor: appColors.black,
        bottom: TabBar(
          controller: controller.tabController,
          indicatorColor: appColors.gradientColor1,
          indicatorWeight: 6.0,
          labelStyle: GoogleFonts.inter(fontSize: 18.sp,fontWeight: FontWeight.w600),
          tabs: [
            Tab(text: "Approved"),
            Tab(text: "Rejected"),
            Tab(text: "Summary"),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(double.infinity, 127.h);


}