import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ri_bhavuk/components/button.dart';
import 'package:ri_bhavuk/theme/theme.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime?> onDateSelected;
  final bool isToDate;

  const CustomDatePicker({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.isToDate,
  }) : super(key: key);

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? _selectedDate;
  bool _isToDate = false;

  @override
  void initState() {
    _selectedDate = widget.selectedDate;
    _isToDate = widget.isToDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(25),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Button(
                      onPressed: () {
                        DateTime today = DateTime.now();
                        setState(() {
                          _selectedDate = today;
                        });
                        widget.onDateSelected(_selectedDate);
                      },
                      label: 'Today',
                      color: 'secondary',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Button(
                      onPressed: _isToDate == false
                          ? () {
                        DateTime today = DateTime.now();
                        DateTime nextMonday = today.add(Duration(days: (DateTime.monday - today.weekday + 7) % 7));
                        setState(() {
                          _selectedDate = nextMonday;
                        });
                        widget.onDateSelected(_selectedDate);
                      }
                          : () {
                        setState(() {
                          _selectedDate = null;
                        });
                        widget.onDateSelected(_selectedDate);
                      },
                      label: _isToDate == false ? 'Next Monday' : 'No date',
                      color: 'primary',
                    ),
                  ),
                ],
              ),
            ),
            if (_isToDate == false)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Button(
                        onPressed: () {
                          DateTime nextTuesday = DateTime.now();
                          while (nextTuesday.weekday != DateTime.tuesday) {
                            nextTuesday = nextTuesday.add(const Duration(days: 1));
                          }
                          setState(() {
                            _selectedDate = nextTuesday;
                          });
                          widget.onDateSelected(_selectedDate);
                        },
                        label: 'Next Tuesday',
                        color: 'secondary',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Button(
                        onPressed: () {
                          DateTime nextWeek = DateTime.now().add(const Duration(days: 7));
                          setState(() {
                            _selectedDate = nextWeek;
                          });
                          widget.onDateSelected(_selectedDate);
                        },
                        label: 'After 1 Week',
                        color: 'secondary',
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            CalendarDatePicker2(
              onValueChanged: (List<DateTime?>? selectedDates) {
                if (selectedDates != null && selectedDates.isNotEmpty) {
                  setState(() {
                    _selectedDate = selectedDates[0];
                  });
                }
              },
              config: CalendarDatePicker2WithActionButtonsConfig(
                disableModePicker: true,
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                openedFromDialog: true,
                dayTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.width * 0.03,
                ),
                centerAlignModePicker: true,
                gapBetweenCalendarAndButtons: 5,
                selectedDayHighlightColor: primaryColor,
                nextMonthIcon: const Icon(Icons.arrow_right),
                lastMonthIcon: const Icon(Icons.arrow_left),
                weekdayLabels: const ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
              ),
              value: _selectedDate != null ? [_selectedDate] : [null],
            ),
            const SizedBox(height: 16),
            const Divider(
              color: Colors.grey,
              thickness: .1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: primaryColor,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _selectedDate == null ? 'No Date' : DateFormat('dd MMM yyyy').format(_selectedDate!),
                        style: TextStyle(color: primaryColor, fontSize: MediaQuery.of(context).size.width * 0.03),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Button(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    label: 'Cancel',
                    color: 'secondary',
                  ),
                  const SizedBox(width: 16),
                  Button(
                    onPressed: () {
                      widget.onDateSelected(_selectedDate != null ? _selectedDate! : null);
                      Navigator.pop(context);
                    },
                    label: 'Save',
                    color: 'primary',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}