import 'package:dksn_calendar/dksn_calendar.dart';
import 'package:flutter/material.dart';

class  DksnCalendarMonthlyLabel extends StatelessWidget {
  const DksnCalendarMonthlyLabel({super.key, required this.type});
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
