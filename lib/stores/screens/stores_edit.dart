import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import 'package:lokakarya_mobile/stores/models/stores_entry.dart';

class StoresEdit extends StatefulWidget {
  final StoresModel? store;
  
  const StoresEdit({super.key, this.store});

  @override
  _StoresEditState createState() => _StoresEditState();
}

class _StoresEditState extends State<StoresEdit> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  
  XFile? _imageFile;
  String? _existingImagePath;
  bool _isLoading = false;
  
  late TextEditingController _namaController;
  late TextEditingController _alamatController;
  late TextEditingController _emailController;
  late TextEditingController _teleponController;
  late TextEditingController _gmapsLinkController;
  
  HariBuka _selectedHariBuka = HariBuka.SENIN_JUMAT;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.store?.nama ?? '');
    _alamatController = TextEditingController(text: widget.store?.alamat ?? '');
    _emailController = TextEditingController(text: widget.store?.email ?? '');
    _teleponController = TextEditingController(text: widget.store?.telepon ?? '');
    _gmapsLinkController = TextEditingController(text: widget.store?.gmapsLink ?? '');
    
    if (widget.store != null) {
      _selectedHariBuka = widget.store!.hariBuka;
      _existingImagePath = widget.store!.image;
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _emailController.dispose();
    _teleponController.dispose();
    _gmapsLinkController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
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

    // Prepare form data
    Map<String, String> formData = {
      'nama': _namaController.text,
      'hari_buka': hariBukaValues.reverse[_selectedHariBuka]!,
      'alamat': _alamatController.text,
      'email': _emailController.text,
      'telepon': _teleponController.text,
      'gmaps_link': _gmapsLinkController.text,
    };

    // Add image if selected
    if (_imageFile != null) {
      List<int> imageBytes = await _imageFile!.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      formData['image'] = base64Image;
    }

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
              const Text(
                'Upload Gambar Toko',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _imageFile != null
                      ? FutureBuilder<Uint8List>(
                          future: _imageFile!.readAsBytes(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Image.memory(
                                snapshot.data!,
                                fit: BoxFit.cover,
                              );
                            }
                            return const Center(child: CircularProgressIndicator());
                          },
                        )
                      : _existingImagePath != null
                          ? Image.network(
                              'http://localhost:8000/toko/fetch-image/${widget.store!.id}/',
                              fit: BoxFit.cover,
                            )
                          : const Center(
                              child: Text('Choose File'),
                            ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _namaController,
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
                controller: _alamatController,
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
                controller: _emailController,
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
                controller: _teleponController,
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
                controller: _gmapsLinkController,
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