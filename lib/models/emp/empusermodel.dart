class EmpUser {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;

  EmpUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
  });

  factory EmpUser.fromJson(Map<String, dynamic> json) {
    return EmpUser(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      email: json['email'],
    );
  }
}
