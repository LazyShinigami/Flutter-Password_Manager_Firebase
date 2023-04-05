import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  String content;
  Color? color;
  double? size;
  double? spacing, wordSpacing;
  List<Shadow>? shadowList;
  FontWeight? weight;

  MyText(
    this.content, {
    super.key,
    this.color,
    this.size,
    this.spacing,
    this.wordSpacing,
    this.shadowList,
    this.weight,
  }) {
    color ??= Colors.white;
    size ??= 16;
    spacing ??= 0;
    wordSpacing ??= 0;
    shadowList ??= [];
    weight ??= FontWeight.normal;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: TextStyle(
        color: color,
        fontSize: size,
        letterSpacing: spacing,
        wordSpacing: wordSpacing,
        shadows: shadowList,
        fontWeight: weight,
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  MyTextField({
    required this.controller,
    required this.label,
    super.key,
    obscureText,
    this.hint,
  }) {
    obscureText ??= false;
    this.obscureText = obscureText;
  }
  TextEditingController controller;
  String label;
  String? hint;
  bool obscureText = false;

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      elevation: 25,
      color: Colors.transparent,
      child: TextFormField(
        controller: controller,
        style: const TextStyle(
            color: Colors.white, fontSize: 18, letterSpacing: 3),
        obscureText: obscureText,

        // decoration
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 18, color: Colors.grey),
          label: MyText(
            ' $label ',
            size: 18,
            spacing: 5,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
