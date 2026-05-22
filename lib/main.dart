import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/product_service.dart';
import 'repositories/product_repository.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'viewmodels/favorites_notifier.dart';
import 'viewmodels/product_viewmodel.dart';
import 'viewmodels/auth_notifier.dart';

void main() {
  final service = ProductService();
  final repository = ProductRepository(service);
  final viewModel = ProductViewModel(repository);

  runApp(MyApp(viewModel: viewModel));
}

class MyApp extends StatelessWidget {
  final ProductViewModel viewModel;

  const MyApp({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesNotifier()),
        ChangeNotifierProvider(create: (_) => AuthNotifier()),
      ],
      child: MaterialApp(
        title: 'Products',
        home: Consumer<AuthNotifier>(
          builder: (context, auth, _) {
            if (auth.isAuthenticated) {
              return HomeScreen(viewModel: viewModel);
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
