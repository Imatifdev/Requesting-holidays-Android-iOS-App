class LeaveItem {
  final String id;
  final String leaveType;
  final DateTime fromDate;
  final DateTime toDate;
  final String cause;
  final int numberOfDays;

  LeaveItem({
    required this.id,
    required this.leaveType,
    required this.fromDate,
    required this.toDate,
    required this.cause,
    required this.numberOfDays, 
  });
}