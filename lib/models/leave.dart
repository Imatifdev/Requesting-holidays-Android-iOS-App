class LeaveRequest {
  int id;
  int employeeId;

  String leaveType;
  DateTime startDate;
  DateTime endDate;
  int totalRequestLeave;
  String comment;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  String leaveCurrentStatus;

  LeaveRequest({
    required this.id,
    required this.employeeId,
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

  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      id: json['id'],
      employeeId: json['employee_id'],
      leaveType: json['leave_type'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      totalRequestLeave: json['total_request_leave'],
      comment: json['comment'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      leaveCurrentStatus: json['leave_current_status'],
    );
  }
}
