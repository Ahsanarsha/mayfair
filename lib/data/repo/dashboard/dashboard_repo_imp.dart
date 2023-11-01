
import 'dashboard_repo.dart';

class DashBoardRepoImpl extends DashBoardRepo {
  @override
  dashboardHQ({required start_date,required end_date}) {
    return apiClient.dashboardHQ(startDate: start_date,endDate: end_date);
  }

}