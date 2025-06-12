import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String? hintText;
  final String? subTitle;
  final IconData? prefixIcon;
  final bool? obscureText;
  final Widget? suffixIcon;
  final Color? subtitleColor;
  final Color? titleColor;
  final TextEditingController? textEditingController;
  final bool isRequired;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final int? maxLines;
  final FocusNode? focusNode;
  final Function(String)? onChanged;

  const TextFieldWidget({
    Key? key,
    this.hintText,
    this.subTitle,
    this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.subtitleColor,
    this.titleColor,
    this.textEditingController,
    this.isRequired = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
    this.focusNode,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (subTitle != null)
          RichText(
            text: TextSpan(
              text: subTitle,
              style: TextStyle(
                color: subtitleColor ?? Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              children: isRequired
                  ? [
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ]
                  : [],
            ),
          ),
        const SizedBox(height: 6),
        TextFormField(
          controller: textEditingController,
          obscureText: obscureText ?? false,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.grey.shade100,
            hintStyle: TextStyle(
              color: titleColor?.withOpacity(0.5) ?? Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey) : null,
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
          validator: validator,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          maxLines: maxLines,
          focusNode: focusNode,
          onChanged: onChanged,
        ),
      ],
    );
  }
}