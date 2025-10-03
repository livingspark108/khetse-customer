import 'package:intl/intl.dart';

class Strings {
  static const String faqs = "FAQs";
  static const String contactUs = "Contact Us";
  static const String callUs = "Call Us";
  static const String emailUs = "Email Us";
  static const String appName = "Khet Se";
  static String get appMessage {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));

    // Format: Day MonthName, Year → e.g., 3 October, 2025
    final formattedDate = DateFormat('d MMMM').format(tomorrow);

    return "Order by 11:59 PM and get it by $formattedDate after 6:00 AM";
  }
  static const String privacyPolicy = "Privacy & Policy";

  //URLs
  static const String mailToUrl = "mailto:gaurav.t@khetse.co";
  static const String callUsUrl = "tel:+91875573330";
   static  String getAppMessage() {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));
    final formattedDate =
        "${tomorrow.day.toString().padLeft(2, '0')}-${tomorrow.month.toString().padLeft(2, '0')}-${tomorrow.year}";

    return "Order by 11:59 PM and get it by $formattedDate for next day delivery after 6:00 AM";
  }
}
