
class CompanyLeaveRequest {
  int id;
  int employeeId;
  EmployeeCLR employee;
  String leaveType;
  String startDate;
  String endDate;
  int totalRequestLeave;
  String comment;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  String leaveCurrentStatus;

  CompanyLeaveRequest({
    required this.id,
    required this.employeeId,
    required this.employee,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.totalRequestLeave,
    required this.comment,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.leaveCurrentStatus,
  });

  factory CompanyLeaveRequest.fromJson(Map<String, dynamic> json) {
    return CompanyLeaveRequest(
      id: json['id'],
      employeeId: json['employee_id'],
      employee: EmployeeCLR.fromJson(json['employee']),
      leaveType:  json['leave_type'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      totalRequestLeave: json['total_request_leave'],
      comment: json['comment'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      leaveCurrentStatus: json['leave_current_status'],
    );
  }
}

class EmployeeCLR {
  int id;
  int companyId;
  String firstName;
  String lastName;
  String phone;
  String email;
  String designation;
  int leaveQuota;
  int remainingLeaveQuota;
  DateTime emailVerifiedAt;
  String password;
  String logo;
  String passwordRandomToken;
  String isVerified;
  String otp;
  DateTime otpCreatedAt;
  DateTime otpVerifiedAt;
  String rememberToken;
  DateTime createdAt;
  DateTime updatedAt;

  EmployeeCLR({
    required this.id,
    required this.companyId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.designation,
    required this.leaveQuota,
    required this.remainingLeaveQuota,
    required this.emailVerifiedAt,
    required this.password,
    required this.logo,
    required this.passwordRandomToken,
    required this.isVerified,
    required this.otp,
    required this.otpCreatedAt,
    required this.otpVerifiedAt,
    required this.rememberToken,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EmployeeCLR.fromJson(Map<String, dynamic> json) {
    return EmployeeCLR(
      id: json['id'],
      companyId: json['company_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      email: json['email'],
      designation: json['designation'] ?? "null",
      leaveQuota: json['leave_quota'],
      remainingLeaveQuota: json['remaining_leave_quota'],
      emailVerifiedAt: DateTime.tryParse(json['email_verified_at']) as DateTime,
      password: json['password'],
      logo: json['logo'],
      passwordRandomToken: json['password_random_token'],
      isVerified: json['isVerified'],
      otp: json['otp'],
      otpCreatedAt: DateTime.tryParse(json['otp_created_at']) as DateTime,
      otpVerifiedAt: DateTime.tryParse(json['otp_verified_at']) as DateTime,
      rememberToken: json['remember_token'],
      createdAt: DateTime.tryParse(json['created_at']) as DateTime,
      updatedAt: DateTime.tryParse(json['updated_at']) as DateTime,
    );
  }
}

