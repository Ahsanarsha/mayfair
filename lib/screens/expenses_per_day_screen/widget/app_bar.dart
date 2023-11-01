import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mayfair/res/export.dart';

class ExpensesAppBar extends StatelessWidget implements PreferredSizeWidget{

  final GlobalKey<ScaffoldState> scaffoldKey;
  final DateTime date;

  const ExpensesAppBar({Key? key, required this.scaffoldKey, required this.date}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        "${date.day} ${DateFormat.MMM().format(date)}, ${date.year}",
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
      backgroundColor: appColors.appBarColor,
      leading: IconButton(
        onPressed: () {
          scaffoldKey.currentState!.openDrawer();
        },
        icon: Icon(Icons.menu,color: appColors.black),
      ),
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.notifications_none_rounded,color: appColors.black,size: 18,))
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(double.infinity, kToolbarHeight);


}