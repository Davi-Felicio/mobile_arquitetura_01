import 'package:flutter/material.dart';
import '../models/product.dart';
import '../viewmodels/product_viewmodel.dart';

class ProductFormScreen extends StatefulWidget {
  final ProductViewModel viewModel;
  final Product? product;

  const ProductFormScreen({
    super.key,
    required this.viewModel,
    this.product,
  });

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _titleController.text = widget.product!.title;
      _priceController.text = widget.product!.price.toString();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0;

    if (title.isEmpty) return;

    if (_isEditing) {
      final updated = Product(
        id: widget.product!.id,
        title: title,
        price: price,
        image: widget.product!.image,
        description: widget.product!.description,
      );
      widget.viewModel.updateProduct(updated);
    } else {
      final created = Product(
        id: 0,
        title: title,
        price: price,
        image: "",
        description: "",
      );
      widget.viewModel.addProduct(created);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? "Editar Produto" : "Novo Produto"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Nome"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: "Preço"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _save,
              child: Text(_isEditing ? "Salvar alterações" : "Cadastrar"),
            ),
          ],
        ),
      ),
    );
  }
}
