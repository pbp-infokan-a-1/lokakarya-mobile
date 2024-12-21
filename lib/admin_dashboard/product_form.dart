import 'package:flutter/material.dart';

class ProductForm extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  // Dummy dropdown options
  final List<String> categories = ['Category 1', 'Category 2'];
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Product Form'),
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
                  selectedCategory = value;
                },
              ),
              TextFormField(
                controller: minPriceController,
                decoration: InputDecoration(labelText: 'Minimum Price'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: maxPriceController,
                decoration: InputDecoration(labelText: 'Maximum Price'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // TODO: Implement API call to save the product
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
