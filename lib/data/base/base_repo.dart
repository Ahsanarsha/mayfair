import 'package:get/get.dart';
import 'package:mayfair/data/service/api_client.dart';

abstract class BaseRepo {
  ApiClient apiClient = Get.find();
}
