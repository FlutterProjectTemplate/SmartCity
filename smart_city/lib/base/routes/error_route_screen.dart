import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorRouteScreen extends StatelessWidget {
  const ErrorRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("Error Screen"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go("/login"),
          child: const Text("Go to welcome page"),
        ),
      ),
    );
  }
}
