import 'package:flutter/material.dart';
import '../viewmodels/product_viewmodel.dart';
import 'product_list_screen.dart';

class HomeScreen extends StatelessWidget {
  final ProductViewModel viewModel;

  const HomeScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Início")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductListScreen(viewModel: viewModel),
              ),
            );
          },
          child: const Text("Ver Produtos"),
        ),
      ),
    );
  }
}
