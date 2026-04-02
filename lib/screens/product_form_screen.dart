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
  final _descriptionController = TextEditingController();
  final _imageController = TextEditingController();

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _titleController.text = widget.product!.title;
      _priceController.text = widget.product!.price.toString();
      _descriptionController.text = widget.product!.description;
      _imageController.text = widget.product!.image;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0;
    final description = _descriptionController.text.trim();
    final image = _imageController.text.trim();

    if (title.isEmpty) return;

    if (_isEditing) {
      final updated = Product(
        id: widget.product!.id,
        title: title,
        price: price,
        image: image,
        description: description,
      );
      widget.viewModel.updateProduct(updated);
    } else {
      final created = Product(
        id: 0,
        title: title,
        price: price,
        image: image,
        description: description,
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
      body: SingleChildScrollView(
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
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Descrição"),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _imageController,
              decoration: const InputDecoration(labelText: "URL da imagem"),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: Text(_isEditing ? "Salvar alterações" : "Cadastrar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
