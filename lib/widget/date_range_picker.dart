import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangePickerWidget extends StatefulWidget {
  final Function(String? startDate, String? endDate) onDateRangeSelected;

  const DateRangePickerWidget({required this.onDateRangeSelected});

  @override
  _DateRangePickerWidgetState createState() => _DateRangePickerWidgetState();
}

class _DateRangePickerWidgetState extends State<DateRangePickerWidget> {
    DateTime? startDate;
  DateTime? endDate;

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });

      String? formattedStartDate =
          startDate != null ? DateFormat('dd-MM-yyyy').format(startDate!) : null;
      String? formattedEndDate =
          endDate != null ? DateFormat('dd-MM-yyyy').format(endDate!) : null;
      
      widget.onDateRangeSelected(formattedStartDate, formattedEndDate);
    }
  }

  @override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children:[
                 Text(
                  'Start Date:'
                )
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: InkWell(
                    onTap: () => _selectDate(context, true),
                    child: Center(
                      child: Text(
                          startDate != null
                              ? DateFormat('dd-MM-yyyy').format(startDate!)
                              : 'Select Start Date',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Text(
                  'End Date:'
                ),
              ],
            ),
            const SizedBox(width: 10,),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: InkWell(
                    onTap: () => _selectDate(context, false),
                    child: Center(
                      child: Text(
                          endDate != null
                              ? DateFormat('dd-MM-yyyy').format(endDate!)
                              : 'Select End Date',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
}