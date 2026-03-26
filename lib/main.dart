import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/product_service.dart';
import 'screens/home_screen.dart';
import 'viewmodels/favorites_notifier.dart';
import 'viewmodels/product_viewmodel.dart';

void main() {
  final service = ProductService();
  final viewModel = ProductViewModel(service);

  runApp(MyApp(viewModel: viewModel));
}

class MyApp extends StatelessWidget {
  final ProductViewModel viewModel;

  const MyApp({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FavoritesNotifier(),
      child: MaterialApp(
        title: 'Products',
        home: HomeScreen(viewModel: viewModel),
      ),
    );
  }
}
