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
      date: DateTime.tryParse(json['date']) ?? DateTime.now(),
      createdAt: DateTime.tryParse(json['created_at']) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']) ?? DateTime.now(),
    );
  }
}
