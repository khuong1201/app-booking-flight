import 'package:flutter/material.dart';
class DialogUtils {
  /// Hiển thị Alert Dialog
  static void showAlertDialog(BuildContext context, String title, String message, {VoidCallback? onOk}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (onOk != null) onOk();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  /// Hiển thị dialog xác nhận (Yes/No)
  static void showConfirmDialog(BuildContext context, String title, String message,
      {required VoidCallback onConfirm, VoidCallback? onCancel}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (onCancel != null) onCancel();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  /// Hiển thị Loading Dialog
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Không cho đóng khi nhấn ra ngoài
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Loading...", style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Ẩn Loading Dialog (nếu đang hiển thị)
  static void hideLoadingDialog(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
