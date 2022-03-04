import 'package:intl/intl.dart';

class Utils {
  static String url = "https://newsapi.org"; // API url
  static String errorMessage = "Something went wrong, please try again"; // error message
  static var timeStamp =  DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");  // date format
  static var myFormatDate =  DateFormat('yyyy-MM-dd'); // date format to display
  static String apiKey =  '0d2cf95abd2245188300c1818b5f7df1'; // key for get headline
}
