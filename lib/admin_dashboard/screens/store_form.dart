import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:lokakarya_mobile/stores/models/stores_entry.dart';

class StoreForm extends StatefulWidget {
  final StoresModel? store;

  const StoreForm({Key? key, this.store}) : super(key: key);

  @override
  _StoreFormState createState() => _StoreFormState();
}

class _StoreFormState extends State<StoreForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController gmapsLinkController = TextEditingController();
  HariBuka _selectedHariBuka = HariBuka.SENIN_JUMAT;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.store != null) {
      nameController.text = widget.store!.nama;
      addressController.text = widget.store!.alamat;
      emailController.text = widget.store!.email;
      phoneController.text = widget.store!.telepon;
      gmapsLinkController.text = widget.store!.gmapsLink;
      _selectedHariBuka = widget.store!.hariBuka;
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final request = context.read<CookieRequest>();
      final String endpoint = widget.store == null 
          ? 'http://localhost:8000/toko/api/create/'
          : 'http://localhost:8000/toko/api/${widget.store!.id}/edit/';

      Map<String, String> formData = {
        'nama': nameController.text,
        'hari_buka': hariBukaValues.reverse[_selectedHariBuka]!,
        'alamat': addressController.text,
        'email': emailController.text,
        'telepon': phoneController.text,
        'gmaps_link': gmapsLinkController.text,
      };

      final response = await request.post(endpoint, formData);

      if (response['status'] == 'success') {
        if (mounted) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.store == null 
                  ? 'Toko berhasil ditambahkan'
                  : 'Toko berhasil diperbarui'
              ),
            ),
          );
        }
      } else {
        throw Exception(response['message'] ?? 'Terjadi kesalahan');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.store == null ? 'Add New Store' : 'Edit Store'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Toko',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama toko tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<HariBuka>(
                value: _selectedHariBuka,
                decoration: const InputDecoration(
                  labelText: 'Hari Operasional',
                  border: OutlineInputBorder(),
                ),
                items: HariBuka.values.map((HariBuka hari) {
                  return DropdownMenuItem<HariBuka>(
                    value: hari,
                    child: Text(hariBukaValues.reverse[hari]!),
                  );
                }).toList(),
                onChanged: (HariBuka? value) {
                  if (value != null) {
                    setState(() => _selectedHariBuka = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!value.contains('@')) {
                    return 'Email tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Telepon',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor telepon tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: gmapsLinkController,
                decoration: const InputDecoration(
                  labelText: 'Link GMaps (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
