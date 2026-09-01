import 'package:intl/intl.dart';

final DateFormat kDateFormat = DateFormat('dd/MM/yyyy');
final DateFormat kDateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');

String formatDate(DateTime? data) => data == null ? '-' : kDateFormat.format(data);

String formatDateTime(DateTime? data) =>
    data == null ? '-' : kDateTimeFormat.format(data);
