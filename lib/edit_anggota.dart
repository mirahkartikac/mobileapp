import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:mobileapp/user_model.dart';

class EditAnggotaPage extends StatefulWidget {
  final UserModel user;
  final Function(UserModel) onUserEdited;

  const EditAnggotaPage({Key? key, required this.user, required this.onUserEdited}) : super(key: key);

  @override
  _EditAnggotaPageState createState() => _EditAnggotaPageState();
}

class _EditAnggotaPageState extends State<EditAnggotaPage> {
  final _formKey = GlobalKey<FormState>();
  final _noIndukController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _noIndukController.text = widget.user.noInduk;
    _nameController.text = widget.user.name;
    _addressController.text = widget.user.address;
    _dobController.text = widget.user.dateOfBirth;
    _phoneController.text = widget.user.phoneNumber;
  }

  Future<void> _editUser() async {
    if (_formKey.currentState!.validate()) {
      final String? authToken = GetStorage().read('token');
      if (authToken == null) {
        print('Token not available');
        return;
      }
      int? noInduk = int.tryParse(_noIndukController.text);
      if (noInduk == null) {
        print('Invalid noInduk');
        return;
      }
      try {
        final formData = FormData.fromMap({
          'nomor_induk': noInduk.toString(), // Pastikan ini dikonversi ke string
          'nama': _nameController.text,
          'alamat': _addressController.text,
          'tgl_lahir': _dobController.text,
          'telepon': _phoneController.text,
        });
        final response = await Dio().put(
          'https://mobileapis.manpits.xyz/api/anggota/${widget.user.id}',
          data: formData,
          options: Options(
            headers: {'Authorization': 'Bearer $authToken'},
          ),
        );
        print('Response status: ${response.statusCode}');
        print('Response data: ${response.data}');
        if (response.statusCode == 200) {
          UserModel updatedUser = UserModel(
            id: widget.user.id,
            noInduk: noInduk.toString(),
            name: _nameController.text,
            address: _addressController.text,
            dateOfBirth: _dobController.text,
            phoneNumber: _phoneController.text,
          );

          widget.onUserEdited(updatedUser);
          Navigator.pop(context);
        } else {
          print('Failed to update user: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _noIndukController,
                decoration: InputDecoration(labelText: 'No Induk'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a No Induk';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dobController,
                decoration: InputDecoration(labelText: 'Date of Birth'),
                readOnly: true,
                onTap: () {
                  _selectDate(context);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date of birth';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _editUser,
                child: Text('Update User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
