class CompanyLeave1 {
  final int id;
  final int companyId;
  final String title;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;

  CompanyLeave1({
    required this.id,
    required this.companyId,
    required this.title,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CompanyLeave1.fromJson(Map<String, dynamic> json) {
    return CompanyLeave1(
      id: json['id'],
      companyId: json['company_id'],
      title: json['title'],
      date: DateTime.parse(json['date']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
