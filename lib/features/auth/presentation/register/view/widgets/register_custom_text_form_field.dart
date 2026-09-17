import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class RegisterCustomTextFormField extends StatefulWidget {
  const RegisterCustomTextFormField({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.validator,
    this.keyboardType,
    this.isPassword = false,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.forceShowErrors = false,
  });

  final String label;
  final String hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool isPassword;
  final bool readOnly;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final bool forceShowErrors;

  @override
  State<RegisterCustomTextFormField> createState() => _RegisterCustomTextFormFieldState();
}

class _RegisterCustomTextFormFieldState extends State<RegisterCustomTextFormField> {
  late final FocusNode _focusNode;
  bool _hasInteracted = false;
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    _obscureText = widget.isPassword;
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus && !_hasInteracted) {
      setState(() {
        _hasInteracted = true;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shouldValidate = _hasInteracted || widget.forceShowErrors;

    return TextFormField(
      focusNode: _focusNode,
      readOnly: widget.readOnly,
      autovalidateMode: shouldValidate
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      obscureText: _obscureText,
      onChanged: (val) {
        if (!_hasInteracted) {
          setState(() => _hasInteracted = true);
        }
        widget.onChanged?.call(val);
      },
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 18.h,
        ),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        )
            : widget.suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            width: 1.5.w,
            color: Colors.green,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            width: 1.5.w,
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            width: 1.5.w,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
