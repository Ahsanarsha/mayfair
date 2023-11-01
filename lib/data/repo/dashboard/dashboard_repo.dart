import 'package:mayfair/data/base/base_repo.dart';

abstract  class DashBoardRepo extends BaseRepo {
  dashboardHQ({required start_date,required end_date});
}