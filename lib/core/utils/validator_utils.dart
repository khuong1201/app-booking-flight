class ValidatorUtils {
  // Kiểm tra email hợp lệ
  static bool isValidEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return regex.hasMatch(email);
  }

  // Kiểm tra mật khẩu
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  // Kiểm tra số điện thoại
  static bool isValidPhone(String phone) {
    final regex = RegExp(r'^(0[3|5|7|8|9])+([0-9]{8})$');
    return regex.hasMatch(phone);
  }

  // Kiểm tra ID Card (CMND hoặc hộ chiếu)
  static bool isValidIdCard(String id, String documentType) {
    if (documentType == 'ID Card') {
      // CMND Việt Nam: 9 hoặc 12 số
      final regex = RegExp(r'^\d{9}$|^\d{12}$');
      return regex.hasMatch(id);
    } else if (documentType == 'Passport') {
      // Hộ chiếu: Bắt đầu bằng chữ cái, theo sau là 7 số
      final regex = RegExp(r'^[A-Z][0-9]{7}$');
      return regex.hasMatch(id);
    }
    return false;
  }
}