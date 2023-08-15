class EmpUser {
  final int id;
  final int companyId;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String? designation;
  final int leaveQuota;
  final int remainingLeaveQuota;
  final String? emailVerifiedAt;
  final String password;
  final String logo;
  final String? passwordRandomToken;
  final String isVerified;
  final String otp;
  final String otpCreatedAt;
  final String? otpVerifiedAt;
  final String? rememberToken;
  final String createdAt;
  final String updatedAt;

  EmpUser({
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

  factory EmpUser.fromJson(Map<String, dynamic> json) {
    return EmpUser(
      id: json['id'],
      companyId: json['company_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      email: json['email'],
      designation: json['designation'],
      leaveQuota: json['leave_quota'],
      remainingLeaveQuota: json['remaining_leave_quota'],
      emailVerifiedAt: json['email_verified_at'],
      password: json['password'],
      logo: json['logo'],
      passwordRandomToken: json['password_random_token'],
      isVerified: json['isVerified'],
      otp: json['otp'],
      otpCreatedAt: json['otp_created_at'],
      otpVerifiedAt: json['otp_verified_at'],
      rememberToken: json['remember_token'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
