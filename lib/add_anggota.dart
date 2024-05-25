import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mobileapp/user_model.dart';

class AddUserPage extends StatefulWidget {
  final Function(UserModel) onUserAdded;

  const AddUserPage({Key? key, required this.onUserAdded}) : super(key: key);

  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _noIndukController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();

  Future<void> _addUser() async {
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
        final response = await Dio().post(
          'https://mobileapis.manpits.xyz/api/anggota',
          data: formData,
          options: Options(
            headers: {'Authorization': 'Bearer $authToken'},
          ),
        );
        print('Response status: ${response.statusCode}');
        print('Response data: ${response.data}');
        if (response.statusCode == 201 || response.statusCode == 200) {
          UserModel newUser = UserModel(
            noInduk: noInduk.toString(),
            name: _nameController.text,
            address: _addressController.text,
            dateOfBirth: _dobController.text,
            phoneNumber: _phoneController.text,
          );

          widget.onUserAdded(newUser);
          Navigator.pop(context);
        } else {
          print('Failed to add user: ${response.statusCode}');
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
        title: Text('Add User'),
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
                onPressed: _addUser,
                child: Text('Add User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}