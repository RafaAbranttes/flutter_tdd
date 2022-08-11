import 'package:flutter/material.dart';

void showErrorMessage(BuildContext context, String isError) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red[900],
      content: Text(
        isError,
        textAlign: TextAlign.center,
      ),
    ),
  );
}
