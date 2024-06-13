import 'package:flutter/material.dart';

Widget buildError(
    {required String message, required void Function()? onPressed}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 70),
          const Icon(
            Icons.error,
            size: 70,
          ),
          const SizedBox(height: 40),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 30),
          IconButton(
              onPressed: onPressed,
              icon: const Icon(
                Icons.refresh,
                size: 40,
              ))
        ],
      ),
    ),
  );
}
