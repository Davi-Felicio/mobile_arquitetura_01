import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_notifier.dart';
import '../viewmodels/product_viewmodel.dart';
import 'product_list_screen.dart';

class HomeScreen extends StatelessWidget {
  final ProductViewModel viewModel;

  const HomeScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthNotifier>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Olá, ${auth.user?.firstName ?? ''}!"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Sair",
            onPressed: () => context.read<AuthNotifier>().logout(),
          ),
        ],
      ),
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
