import 'package:flutter/material.dart';
import 'package:news_app_flutter/src/data_layer/res/app_styles.dart';

class CommonTextField extends StatelessWidget {
  const CommonTextField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  /// The controller for the text field
  final TextEditingController controller;

  /// The function to be called when the text field is changed
  final Function? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: AppStyles.subtitle1,
      onChanged: (value) {
        onChanged!(value);
      },
      decoration: InputDecoration(
        hintText: "Search",
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
        suffixIcon: const Icon(Icons.filter_alt_outlined),
      ),
    );
  }
}
