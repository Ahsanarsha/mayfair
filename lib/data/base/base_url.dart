class BaseUrls {

 static String fromUser='';

 //for Head Quarter Date
 static String dateFromHQ='';
 static String dateToHQ='';

 //for Head Quarter Date
 static String dateFromTR='';
 static String dateToTR='';

 static String baseUrl = "http://mayfair.catsofttech.co/api/";
 static String baseProfileUrl = "http://mayfair.catsofttech.co/assets/images/users/";

 static String login = baseUrl+"login";
 static String userProfile = baseUrl+"user-profile/";
 static String profileUpdate = baseUrl+"update-profile";
 static String logout = baseUrl+"logout";
 static String changePassword = baseUrl+"change-password";
 static String dashboard = baseUrl+"dashboard/";
 static String headquarterAllExpenses = baseUrl+"all-expenses";
 static String headquarterCheckAllExpenses = baseUrl+"check-expense-amount";
 static String dashboardCalenderDates = baseUrl+"calander";
 static String lastThreeHqDates = baseUrl+"latest-calender-date";
 static String addExpenseHeadquarter = baseUrl+"add-expense/headquater";
 static String updateExpenseHeadquarter = baseUrl+"update-headquater-expenses";
 static String extraExpenses = baseUrl+"extra-expenses";

 static String expensesTravelExpenseData = baseUrl+"travel-expense-data";
 static String expensesSubmitTravelExpense = baseUrl+"submit-travel-expense";
 static String expensesUpdateTravelExpense = baseUrl+"update-travel-expense-by-id";
 static String autoFillMonthHeadQuarter = baseUrl+"autofill-headquater-expense/store";
 static String getFillMonthHeadQuarter = baseUrl+"dashboard/expense";
 static String singleExpenseByIdHeadQuarter = baseUrl+"single-expense-by-id";
 static String getTravelExpenseByID = baseUrl+"get-travel-expense";
 static String getNotification = baseUrl+"all-notification";
 static String postFcmToken = baseUrl+"update-fcm-token";

 static String expensesAccepted = baseUrl+"expenses/accepted";
 static String expensesAcceptedFromTo = baseUrl+"expenses/accepted/date";
 static String expensesRejected = baseUrl+"expenses/rejected";
 static String expensesRejectedFromTo = baseUrl+"expenses/rejected/date";
 static String expensesPending = baseUrl+"expenses/added";
 static String expensesPendingFromTo = baseUrl+"expenses/added/date";
 static String submitHQExpenses = baseUrl+"expenses/submit";

 static String expensesAcceptedTravel = baseUrl+"travel-expenses/accepted";
 static String expensesAcceptedFromToTravel = baseUrl+"travel-expenses/accepted/date";
 static String expensesRejectedTravel = baseUrl+"travel-expenses/rejected";
 static String expensesRejectedFromToTravel = baseUrl+"travel-expenses/rejected/date";
 static String expensesPendingTravel = baseUrl+"travel-expenses/added";
 static String expensesPendingFromToTravel = baseUrl+"travel-expenses/added/date";
 static String submitTravelExpenses = baseUrl+"travel-expenses/submit";
}