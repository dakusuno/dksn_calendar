import 'package:dksn_calendar/dksn_calendar.dart';
import 'package:flutter/material.dart';

class  DksnCalendarMonthlyLabel extends StatelessWidget {
  const DksnCalendarMonthlyLabel({required this.type, super.key});
  final DksnCalendarDateType type;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[300],
      child: Center(
        child: Text(
          type.labelDate,
        ),
      ),
    );
  }
}
