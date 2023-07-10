class ShowEmployees {
  ShowEmployees({
    required this.status,
    required this.message,
    required this.data,
    required this.statusCode,
  });
  late final String status;
  late final String message;
  late final Data data;
  late final int statusCode;

  ShowEmployees.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = Data.fromJson(json['data']);
    statusCode = json['status_code'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.toJson();
    _data['status_code'] = statusCode;
    return _data;
  }
}

class Data {
  Data({
    required this.employee,
  });
  late final List<Employee> employee;

  Data.fromJson(Map<String, dynamic> json) {
    employee =
        List.from(json['employee']).map((e) => Employee.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['employee'] = employee.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Employee {
  Employee({
    required this.id,
    required this.companyId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    this.designation,
    required this.leaveQuota,
    required this.remainingLeaveQuota,
    this.emailVerifiedAt,
    required this.password,
    this.logo,
    this.passwordRandomToken,
    required this.isVerified,
    this.otp,
    this.otpCreatedAt,
    this.otpVerifiedAt,
    this.rememberToken,
    required this.createdAt,
    required this.updatedAt,
    required this.days,
  });
  late final int id;
  late final int companyId;
  late final String firstName;
  late final String lastName;
  late final String phone;
  late final String email;
  late final Null designation;
  late final int leaveQuota;
  late final int remainingLeaveQuota;
  late final Null emailVerifiedAt;
  late final String password;
  late final String? logo;
  late final Null passwordRandomToken;
  late final String isVerified;
  late final String? otp;
  late final String? otpCreatedAt;
  late final String? otpVerifiedAt;
  late final Null rememberToken;
  late final String createdAt;
  late final String updatedAt;
  late final Days days;

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    email = json['email'];
    designation = null;
    leaveQuota = json['leave_quota'];
    remainingLeaveQuota = json['remaining_leave_quota'];
    emailVerifiedAt = null;
    password = json['password'];
    logo = null;
    passwordRandomToken = null;
    isVerified = json['isVerified'];
    otp = null;
    otpCreatedAt = null;
    otpVerifiedAt = null;
    rememberToken = null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    days = Days.fromJson(json['days']);
  }

  String getWorkingDaysAsString() {
    final List<String> daysOfWeek = ['Mon', 'Tues', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun'];
    final List<String> workingDays = [];

    if (days.monday == 1) workingDays.add(daysOfWeek[0]);
    if (days.tuesday == 1) workingDays.add(daysOfWeek[1]);
    if (days.wednesday == 1) workingDays.add(daysOfWeek[2]);
    if (days.thursday == 1) workingDays.add(daysOfWeek[3]);
    if (days.friday == 1) workingDays.add(daysOfWeek[4]);
    if (days.saturday == 1) workingDays.add(daysOfWeek[5]);
    if (days.sunday == 1) workingDays.add(daysOfWeek[6]);

    return workingDays.join(', ');
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['company_id'] = companyId;
    _data['first_name'] = firstName;
    _data['last_name'] = lastName;
    _data['phone'] = phone;
    _data['email'] = email;
    _data['designation'] = designation;
    _data['leave_quota'] = leaveQuota;
    _data['remaining_leave_quota'] = remainingLeaveQuota;
    _data['email_verified_at'] = emailVerifiedAt;
    _data['password'] = password;
    _data['logo'] = logo;
    _data['password_random_token'] = passwordRandomToken;
    _data['isVerified'] = isVerified;
    _data['otp'] = otp;
    _data['otp_created_at'] = otpCreatedAt;
    _data['otp_verified_at'] = otpVerifiedAt;
    _data['remember_token'] = rememberToken;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['days'] = days.toJson();
    return _data;
  }
}

class Days {
  Days({
    required this.id,
    required this.employeeId,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final int employeeId;
  late final int monday;
  late final int tuesday;
  late final int wednesday;
  late final int thursday;
  late final int friday;
  late final int saturday;
  late final int sunday;
  late final String createdAt;
  late final String updatedAt;

  Days.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    monday = json['monday'];
    tuesday = json['tuesday'];
    wednesday = json['wednesday'];
    thursday = json['thursday'];
    friday = json['friday'];
    saturday = json['saturday'];
    sunday = json['sunday'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['employee_id'] = employeeId;
    _data['monday'] = monday;
    _data['tuesday'] = tuesday;
    _data['wednesday'] = wednesday;
    _data['thursday'] = thursday;
    _data['friday'] = friday;
    _data['saturday'] = saturday;
    _data['sunday'] = sunday;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}
