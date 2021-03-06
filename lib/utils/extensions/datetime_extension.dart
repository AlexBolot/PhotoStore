/*..............................................................................
 . Copyright (c)
 .
 . The datetime_extension.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 06/03/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

extension DateTimeExtensions on DateTime {
  String toEuropeanFormat() {
    var day = '${this.day < 10 ? '0' : ''}${this.day}';
    var month = '${this.month < 10 ? '0' : ''}${this.month}';

    var hour = '${this.hour < 10 ? '0' : ''}${this.hour}';
    var min = '${this.minute < 10 ? '0' : ''}${this.minute}';
    var sec = '${this.second < 10 ? '0' : ''}${this.second}';

    return '{$day/$month/$year $hour:$min:$sec}';
  }

  bool isSameDay(DateTime other) => year == other.year && month == other.month && day == other.day;

  bool isNotSameDay(DateTime other) => !isSameDay(other);
}
