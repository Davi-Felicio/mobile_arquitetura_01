import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/network/http_client.dart';
import 'data/datasources/product_cache_datasource.dart';
import 'data/datasources/product_remote_datasource.dart';
import 'data/repositories/product_repository_impl.dart';
import 'presentation/pages/product_page.dart';
import 'presentation/viewmodels/favorites_notifier.dart';
import 'presentation/viewmodels/product_viewmodel.dart';

void main() {
  final client = AppHttpClient();
  final datasource = ProductRemoteDatasource(client);
  final cache = ProductCacheDatasource();
  final repository = ProductRepositoryImpl(datasource, cache);
  final viewModel = ProductViewModel(repository);

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
        home: ProductPage(viewModel: viewModel),
      ),
    );
  }
}
