import 'package:flutter/material.dart';
import '../../presentation/pages/product_page.dart';
import '../viewmodels/product_viewmodel.dart';

class HomePage extends StatelessWidget {
  final ProductViewModel viewModel;

  const HomePage({super.key, required this.viewModel});

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
                builder: (_) => ProductPage(viewModel: viewModel),
              ),
            );
          },
          child: const Text("Ver Produtos"),
        ),
      ),
    );
  }
}
