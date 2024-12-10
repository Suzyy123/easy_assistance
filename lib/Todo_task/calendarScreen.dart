import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, String> _festivals = {
    DateTime(2024, 1, 1): 'New Year\'s Day',
    DateTime(2024, 1, 14): 'Makar Sankranti',
    DateTime(2024, 2, 14): 'Valentine\'s Day',
    DateTime(2024, 3, 25): 'Holi',
    DateTime(2024, 12, 25): 'Christmas',
  };

  @override
  Widget build(BuildContext context) {
    // Filter festivals based on the focused month
    List<MapEntry<DateTime, String>> upcomingFestivals = _festivals.entries
        .where((entry) =>
    entry.key.isAfter(DateTime(_focusedDay.year, _focusedDay.month - 1, _focusedDay.day)) && // After previous month
        entry.key.isBefore(DateTime(_focusedDay.year, _focusedDay.month + 2, 1))) // Before two months later
        .toList()
      ..sort((a, b) => a.key.compareTo(b.key)); // Sort by date

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text('Calendar'),
        backgroundColor: Colors.blue[900],
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 40),
          TableCalendar(
            firstDay: DateTime(2020, 1, 1),
            lastDay: DateTime(2050, 12, 31),
            focusedDay: _focusedDay,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              defaultTextStyle: TextStyle(color: Colors.black),
              weekendTextStyle: TextStyle(color: Colors.red),
              todayTextStyle: TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(
                color: Colors.blue[700],
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),

              // Adjust the space between days of the week and the calendar days
              outsideTextStyle: TextStyle(color: Colors.grey),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(color: Colors.blue[900], fontSize: 18, fontWeight: FontWeight.bold),
              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.blue[900]),
              rightChevronIcon: Icon(Icons.chevron_right, color: Colors.blue[900]),
              // Add vertical padding to increase space between the header and the calendar days
              headerPadding: EdgeInsets.only(bottom: 8), // Adjust this padding
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              weekendStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),


            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: upcomingFestivals.isEmpty
                ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'No Events',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            )
                : ListView.builder(
              itemCount: upcomingFestivals.length,
              itemBuilder: (context, index) {
                final festival = upcomingFestivals[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.event, color: Colors.black),
                    title: Text(festival.value),
                    subtitle: Text(
                      '${festival.key.day}-${festival.key.month}-${festival.key.year}',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
