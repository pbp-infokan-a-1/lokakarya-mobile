import 'package:flutter/material.dart';
import 'package:lokakarya_mobile/models/store_entry.dart' as storeEntry;

class StoreForm extends StatefulWidget {
  final storeEntry.StoreEntry? store;
  final Function(storeEntry.StoreEntry) onSave;

  const StoreForm({Key? key, this.store, required this.onSave}) : super(key: key);

  @override
  _StoreFormState createState() => _StoreFormState();
}

class _StoreFormState extends State<StoreForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController openDaysController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController gmapsLinkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.store != null) {
      nameController.text = widget.store!.fields.nama;
      openDaysController.text = widget.store!.fields.hariBuka.toString();
      addressController.text = widget.store!.fields.alamat;
      emailController.text = widget.store!.fields.email;
      phoneController.text = widget.store!.fields.telepon;
      gmapsLinkController.text = widget.store!.fields.gmapsLink;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.store == null ? 'Add Store' : 'Edit Store'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Store Name'),
                validator: (value) => value!.isEmpty ? 'This field is required' : null,
              ),
              TextFormField(
                controller: openDaysController,
                decoration: InputDecoration(labelText: 'Open Days'),
              ),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'This field is required';
                  }
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'This field is required';
                  }
                  final phoneRegex = RegExp(r'^[0-9]+$');
                  if (!phoneRegex.hasMatch(value)) {
                    return 'Enter a valid phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: gmapsLinkController,
                decoration: InputDecoration(labelText: 'Google Maps Link'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final storeEntry.StoreEntry newStore = storeEntry.StoreEntry(
                model: storeEntry.Model.STOREPAGE_TOKO,
                pk: widget.store?.pk ?? 0,
                fields: storeEntry.Fields(
                  nama: nameController.text,
                  hariBuka: storeEntry.hariBukaValues.map[openDaysController.text] ?? storeEntry.HariBuka.SENIN_JUMAT,
                  alamat: addressController.text,
                  email: emailController.text,
                  telepon: phoneController.text,
                  gmapsLink: gmapsLinkController.text,
                ),
              );
              widget.onSave(newStore);
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
