class CompanyUser {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String logo;
  final String startfinancialyear;
  final String endfinancialyear;

  CompanyUser(
      {required this.logo,
      required this.id,
      required this.firstName,
      required this.lastName,
      required this.phone,
      required this.email,
      required this.startfinancialyear,
      required this.endfinancialyear});

  factory CompanyUser.fromJson(Map<String, dynamic> json) {
    return CompanyUser(
        id: json['id'],
        logo: json['logo'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        phone: json['phone'],
        email: json['email'],
        startfinancialyear: json['financial_year_start_date'],
        endfinancialyear: json['financial_year_end_date']);
  }
}
