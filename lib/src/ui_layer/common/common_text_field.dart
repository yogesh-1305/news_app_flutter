import 'package:flutter/material.dart';
import 'package:news_app_flutter/src/data_layer/res/app_styles.dart';

class CommonTextField extends StatelessWidget {
  const CommonTextField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.onSuffixIconPressed,
    this.fillColor = Colors.black12,
    this.showSuffixIcon = false,
    this.showPrefixIcon = false,
  });

  /// The controller for the text field
  final TextEditingController controller;

  /// The function to be called when the text field is changed
  final Function(String value)? onChanged;

  /// on suffix icon pressed
  final Function? onSuffixIconPressed;

  /// The color to fill the text field with
  final Color fillColor;

  /// show suffix icon
  final bool showSuffixIcon;

  /// show prefix icon
  final bool showPrefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: AppStyles.subtitle1,
      onChanged: (value) {
        onChanged!(value);
      },
      cursorColor: Theme.of(context).colorScheme.onPrimary,
      decoration: InputDecoration(
        hintText: "Search",
        prefixIcon: showPrefixIcon ? const Icon(Icons.search) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: fillColor,
        suffixIcon: showSuffixIcon
            ? InkWell(
                onTap: () {
                  if (onSuffixIconPressed != null) {
                    onSuffixIconPressed!();
                  }
                },
                child: Icon(
                  Icons.filter_alt_outlined,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              )
            : null,
      ),
    );
  }
}
