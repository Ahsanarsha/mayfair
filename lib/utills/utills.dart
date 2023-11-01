import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mayfair/helpers/check_connection_sigleton.dart';



Map<String,dynamic> monthlyValues={};
double getScreenWidth(context) => MediaQuery.of(context).size.width;

double getScreenHeight(context) => MediaQuery.of(context).size.height;

getConnectionResult(context) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    return Container();
  } else {
    return Container(
      width: getScreenWidth(context),
      height: 50,
      color: Colors.red,
      child: const Text(
        "No Internet connection, Connect and restart!",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

showMessage({required String title, required String? message}) {
  Get.snackbar(
    title,
    message.toString(),
    titleText: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
    messageText: Text(
      message.toString(),
      style: const TextStyle(
        color: Colors.white54,
      ),
    ),
    backgroundColor: Colors.black54,
  );
}

Widget noInternetWidget(context) {
  return Container(
    width: getScreenWidth(context),
    height: 35,
    decoration: const BoxDecoration(
      color: Colors.blueAccent,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(22),
        bottomRight: Radius.circular(22),
      ),
    ),
    child: const Center(
      child: Text(
        "No Internet connection",
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}
class Constants{
  ConnectionStatusSingleton connectionStatus =
  ConnectionStatusSingleton.getInstance();
}