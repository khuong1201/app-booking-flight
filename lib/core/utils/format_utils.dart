import 'package:intl/intl.dart';
class FormatUtils{
  //dinh dang so thanh tien te viet nam
  static String formatCurrency(double amount){
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN',symbol: 'VND');
    return formatCurrency.format(amount);
  }
  // dinh dang ngay thang
  static String formatDate(DateTime date){
    return DateFormat('dd/MM/yyyy').format(date);
  }
  // viet hoa chu cai dau
  static String capitalize(String text){
    if(text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}