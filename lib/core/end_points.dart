// ignore_for_file: constant_identifier_names

class EndPoints {
  // Login or Registration
  // static const String GET_HUB_DATA = "get_userdata"; // done
  // static const String GET_HUB_DATA = "get_userdatas"; // done
  // static const String GET_HUB_DATA = "login_and_fetch_data"; // done
  static const String GET_HUB_DATA = "get_all_data"; // done
  static const String GET_USER_DATA = "get_profile"; // done
  static const String GET_MANAGER_DATA = "get_user_employee_info"; // done
  static const String UPDATE_USER_DATA = "get_profile";

  // Home Screen
  static const String GET_COUNTS = "get_counts_and_unplanned_opportunities"; // done
  static const String GET_STATUS_PERCENTAGES = "get_status_percentages_by_month";
  // static const String GET_STATUS_PERCENTAGES = "get_status_percentages";

  // Vacation
  static const String GET_VACATIONS = "get_vacations"; // done
  static const String GET_VACATIONS_TYPES = "vacation_types"; // done
  static const String GET_VACATIONS_BALANCE = "leave_allocation"; // done
  static const String ADD_NEW_VACATION = "add_new_vacations"; // done
  // static const String ADD_NEW_VACATION = "add_new_vacation"; // done

  // clients
  static const String GET_ALL_CLIENTS = "get_all_clients"; // done
  static const String GET_CLIENT_DETAILS = "get_client_details"; // done
  static const String GET_MEDICAL_SPECIALTY = "medical_specialty"; // done

  // /POC
  static const String GET_POC = "get_pocs"; // done
  // static const String GET_POC = "get_poc"; // done

  static const String GET_REPRESENTATIVE = "get_representative";

  // Todo Or Tasks
  // static const String GET_ALL_TODO = "get_all_todo";
  static const String GET_ALL_TODO = "get_all_todos";
  static const String GET_TODO_PRIORITY = "todo_priority";
  static const String GET_TODO_TYPES = "todo_type";
  static const String ADD_NEW_TODO = "add_new_todo";
  static const String UPDATE_TODO = "update_task_status";

  // Expenses
  // static const String GET_EXPENSES = "get_activities";
  static const String GET_EXPENSES = "get_advances";
  static const String GET_EXPENSES_TYPE = "employee_advance_types";
  static const String ADD_NEW_EXPENSES = "nnew_activity";
  // static const String ADD_NEW_EXPENSES = "new_activity";

  // Activities
  // static const String GET_ACTIVITIES = "get_activities";
  // static const String ADD_NEW_ACTIVITIES = "new_activity";
  // static const String MODE_OF_PAYMENT = "mode_of_payment";
  static const String GET_ACTIVITIES = "get_advances";
  static const String GET_AVAILABLE_BUDGET = "get_budget";
  static const String GET_ACTIVITIES_TYPE = "employee_advance_types";
  static const String ADD_NEW_ACTIVITIES = "nnew_activity";

  // Settlement
  static const String GET_SETTLEMENT = "get_settlements";
  static const String GET_SETTLEMENT_FOR = "get_advances";
  static const String ADD_NEW_SETTLEMENT = "add_expense_claims";
  // static const String GET_SETTLEMENT_DETAIL = "get_settlement_detail";

  // Plans
  static const String GET_VISITS = 'get_visits';
  static const String GET_LAST_VISIT = 'get_visits_last_date';
  static const String ADD_PLANNED = 'add_unplanned_visit';
  static const String DELETE_VISIT = 'delete_opportunity';

  // Planning
  static const String GET_PLANNING_CLMS = "product_bundle_test";
  // static const String GET_PLANNING = "get_all_clients";

  // Visits
  static const String POSTPONED_VISIT = "update_visit";
  static const String END_VISIT = "update_counts";
  static const String UPDATE_INCLUDE_CLM = "update_include_clm";
  static const String UPDATE_VISIT_STATUS = "update_opportunity_visits";
  static const String GET_FEEDBACK = "get_to_discuss_value";
  static const String UPDATE_FEEDBACK = "update_to_discuss";
  static const String GET_PRODUCT_BUNDLES_WITH_CLM = "get_product_bundles_with_clm";
  static const String PRODUCT_BUNDLE_NAME = "get_product_bundle_items";
  static const String GET_QUESTIONS = "get_question_log_data";
  static const String UPDATE_ANSWER = "update_question_log";
  static const String UPDATE_LOCATION = "update_location_client";
  // static const String END_VISIT = "update_count";
  // static const String GET_QUESTIONS = "get_opportunity_questionss";
  // static const String UPDATE_ANSWER = "update_answer";

  // Today plan Or Today Visit
  static const String GET_TODAY_VISITS = "get_visits";
  static const String ADD_UNPLANNED_VISIT = "add_unplanned_visit";

  // Attendance
  static const String GET_ATTENDANCE = "get_attendance_by_dates";
  // Check In
  static const String GET_CHECK_IN = "get_checkin";
  static const String ADD_CHECK_IN = "add_checkin";

  // Salaries
  static const String GET_SALARIES = "get_salaries";

  // Permissions
  static const String GET_PERMISSIONS = "get_permissions";
  static const String GET_PERMISSIONS_TYPES = "get_permission_types";
  static const String ADD_PERMISSION = "add_permission";

  // Sales
  static const String GET_SALES = "get_sales_infos";
  static const String GET_SALES_DISTRIBUTION = "get_distribution_places_options";

  // Requests
  // static const String GET_REQUESTS = "get_requests";
  // static const String GET_REQUESTS_DETAILS = "get_request_details";
  static const String GET_REQUESTS_DETAILS = "get_request_detailsss";
  static const String UPDATE_REQUESTS = "update_leave_application_docs";
  static const String UPDATE_STTELEMNT_REQUEST = "update_leave_application_docsss";
  static const String UPDATE_VISITS = "update_opportunity_visits";
  static const String UPDATE_PAYMENT = "create_payment_entry";
  static const String UPDATE_PAYMENT_STATUS = "update_payment_statuss";
}