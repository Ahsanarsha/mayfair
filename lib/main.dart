import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mayfair/screens/notification/export.dart';
import 'package:mayfair/utills/utills.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'data/service/MyHttpOverrides.dart';
import 'export.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  //log'Handling a background message ${message.messageId}');
  //logmessage.data.toString());

  Get.to(NotificationScreen(),binding: Appbindings());

}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: "This channel is used for important notifications.",
  // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
String appVersion = '1.0.0';
Constants constants = Constants();
void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  constants.connectionStatus.initialize();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  appVersion = packageInfo.version;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  HttpOverrides.global = MyHttpOverrides();

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  SystemChrome
      .setPreferredOrientations(
      [DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 927),
      builder: (context, _) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialBinding: Appbindings(),
          title: 'Mayfair',
          home: SplashScreen(),
        );
      },
    );
  }
}
