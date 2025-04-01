import 'package:flutter/material.dart';
import 'package:booking_flight/core/constants/constants.dart';

class AppBarSearchWidget extends StatelessWidget {
  final Color backgroundColor;
  final double height;
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;
  final VoidCallback onCancel;

  const AppBarSearchWidget({
    super.key,
    this.backgroundColor = AppColors.primaryColor,
    this.height = 100,
    required this.searchController,
    required this.onSearch,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      color: backgroundColor,
      padding: const EdgeInsetsDirectional.fromSTEB(16, 56, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 276,
            height: 44,
            child: TextField(
              controller: searchController,
              onChanged: onSearch,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(4),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Image.asset(
                    'assets/icons/Search.png',
                    width: 20,
                    height: 20,
                    color: const Color(0xFF595959),
                  ),
                ),
                suffixIcon: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: searchController,
                  builder: (context, value, child) {
                    return value.text.isNotEmpty
                        ? GestureDetector(
                      onTap: () {
                        searchController.clear();
                        onSearch('');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          'assets/icons/Close.png',
                          width: 12,
                          height: 12,
                          color: const Color(0xFF595959),
                        ),
                      ),
                    )
                        : const SizedBox.shrink();
                  },
                ),
                hintText: "Search airport",
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFB8B8B8)
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          /// Nút "Cancel"
          TextButton(
            onPressed: onCancel,
            child: const Text(
              "Cancel",
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Color(0xFFC8D1F0),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
