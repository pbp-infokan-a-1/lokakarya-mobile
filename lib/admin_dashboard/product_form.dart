import 'package:flutter/material.dart';
import 'package:lokakarya_mobile/models/product_entry.dart';

class ProductForm extends StatefulWidget {
  final ProductEntry? product;
  final Function(ProductEntry) onSave;

  const ProductForm({Key? key, this.product, required this.onSave}) : super(key: key);

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final List<String> categories = ['Category 1', 'Category 2'];
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      nameController.text = widget.product!.fields.name;
      minPriceController.text = widget.product!.fields.minPrice.toString();
      maxPriceController.text = widget.product!.fields.maxPrice.toString();
      descriptionController.text = widget.product!.fields.description;
      selectedCategory = widget.product!.fields.category.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) => value!.isEmpty ? 'This field is required' : null,
              ),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: categories
                    .map((category) => DropdownMenuItem(value: category, child: Text(category)))
                    .toList(),
                decoration: InputDecoration(labelText: 'Category'),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                validator: (value) => value == null ? 'This field is required' : null,
              ),
              TextFormField(
                controller: minPriceController,
                decoration: InputDecoration(labelText: 'Minimum Price'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'This field is required' : null,
              ),
              TextFormField(
                controller: maxPriceController,
                decoration: InputDecoration(labelText: 'Maximum Price'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'This field is required' : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'This field is required' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final product = ProductEntry(
                model: 'productpage.product',
                pk: widget.product?.pk ?? '',
                fields: Fields(
                  name: nameController.text,
                  category: Category(name: selectedCategory!),
                  minPrice: int.parse(minPriceController.text),
                  maxPrice: int.parse(maxPriceController.text),
                  description: descriptionController.text,
                  store: widget.product?.fields.store ?? [],
                  image: widget.product?.fields.image,
                  averageRating: widget.product?.fields.averageRating ?? 0.0,
                  numReviews: widget.product?.fields.numReviews ?? 0,
                  ratings: widget.product?.fields.ratings ?? [],
                ),
              );
              widget.onSave(product);
              Navigator.pop(context);
            }
          },
          child: Text('Save'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
