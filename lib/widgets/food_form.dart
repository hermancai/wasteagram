import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/food_post.dart';

class FoodForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final FoodPost dto;

  const FoodForm({
    Key? key, 
    required this.formKey, 
    required this.dto
  }) : super(key: key);

  InputDecoration _inputDecoration() {
    return const InputDecoration(
      contentPadding: EdgeInsets.all(10),
      label: Center(child: Text("Number of Wasted Items")),
      labelStyle: TextStyle(fontSize: 30),
      errorStyle: TextStyle(fontSize: 20)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Semantics(
        child: TextFormField(
          autofocus: true,
          style: const TextStyle(fontSize: 30),
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: _inputDecoration(),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onSaved: (value) { dto.quantity = int.parse(value!); },
          validator: (value) => (value == null || value.isEmpty) ? "A number is required" : null,
        ),
        label: "Number of wasted items",
        textField: true,
        focusable: true,
      ) 
    );
  }
}
