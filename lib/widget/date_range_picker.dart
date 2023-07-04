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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              ElevatedButton(
                onPressed: () => _selectDate(context, true),
                child: const Text('Select Start Date'),
              ),
              const SizedBox(height: 10),
              Text(
                startDate != null
                    ? 'Start Date: ${DateFormat('dd-MM-yyyy').format(startDate!)}'
                    : 'Start Date not selected',
              ),
            ],
          ),
          Column(children: [
            ElevatedButton(
                onPressed: () => _selectDate(context, false),
                child: const Text('Select End Date'),
              ),
              const SizedBox(height: 10),
              Text(
                endDate != null
                    ? 'End Date: ${DateFormat('dd-MM-yyyy').format(endDate!)}'
                    : 'End Date not selected',
              ),
          ]),
        ],
      ),
    );
  }
}
