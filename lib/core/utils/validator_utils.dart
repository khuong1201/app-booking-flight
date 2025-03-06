class ValidatorUtils{
  // kiem tra email hop le
  static bool isValidEmail(String email){
    final regex = RegExp (r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return regex.hasMatch(email);
  }
  // kiem tra mat khau
  static bool isValidPassword(String password){
    return password.length >= 6;
  }
  // kiem tra so dien thoai
  static bool isValidPhone(String phone) {
    final regex = RegExp(r'^(0[3|5|7|8|9])+([0-9]{8})$');
    return regex.hasMatch(phone);
  }
}