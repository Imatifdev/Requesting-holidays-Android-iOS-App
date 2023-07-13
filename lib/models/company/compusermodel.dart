class CompanyUser {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String logo;

  CompanyUser({
    required this.logo,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
  });

  factory CompanyUser.fromJson(Map<String, dynamic> json) {
    return CompanyUser(
      id: json['id'],
      logo: json['logo'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      email: json['email'],
    );
  }
}
