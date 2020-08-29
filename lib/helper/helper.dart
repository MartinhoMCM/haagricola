import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class Helper {


  static String DateNow() {
    final DateFormat format = DateFormat.yMMMMd('en_US');
    final String invoiceNumber = format.format(DateTime.now());


    return invoiceNumber;
  }

  static String HourNow()
  {

    final DateFormat format = DateFormat.Hms('en_US');
    final hour=format.format(DateTime.now());

    return hour;
  }

  static Widget showCircularProgress(bool _isLoading) {
    if (_isLoading) {
      return Center(
          child: CircularProgressIndicator(color: PdfColor.fromHex("B03D42"), value: 2.0));
    }

    return Container(width: 0.0, height: 0.0);

  }

  static String numberFormat(double)
  {
    var f = new NumberFormat("###.00", "en_US");

    return f.format(double);

  }
}