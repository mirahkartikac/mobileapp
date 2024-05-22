import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mobileapp/user_model.dart';
import 'package:mobileapp/view_child.dart';

class AddChild extends StatefulWidget{
  final Function(UserModel) onUserAdded;
  const AddChild({super.key, required this.onUserAdded});
  
  @override
  State<AddChild> createState() => AddChildState();
}

class AddChildState extends State<AddChild> {
  late Color myColor;

  final _dio = Dio();
  final _storage = GetStorage();

  final _formKey = GlobalKey<FormState>();
  final _noIndukController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();
  late Size mediaSize;
  
  @override
  Widget build(BuildContext context) {
    mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Halaman Register"),
      ),
      body: Stack(
        children: [
          Positioned(top: 20, child: _buildBox(),)
        ],
      ),
    );
  }

  Widget _buildBox(){
    return SizedBox(
      width: mediaSize.width,
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(45),
            bottomLeft: Radius.circular(45)
          )),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: _buildForm(),
        ),
      ),
    );
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
  Widget _buildForm(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tambah Anak",
          style: TextStyle(
            color: Colors.indigo,
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
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
        _buildAddButton()
        
      ],
    );
  }

  Widget _buildBlackText(String text){
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.bold
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller){
    return TextField(
      controller: controller,
    );
  }

  Widget _buildAddButton(){
    return ElevatedButton(
      onPressed: (){
        goTambahAnak();
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 20,
        backgroundColor: Colors.indigo,
        shadowColor: Colors.indigo,
        minimumSize: const Size.fromHeight(60),
      ),
      child: const Text(
          "Tambah Anak",
          style: TextStyle(
            color: Colors.white
          ),
        ),
      );
  }

  Future<void> goTambahAnak() async {
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
        final response = await _dio.post(
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
          _storage.write("children", newUser);
          widget.onUserAdded(newUser);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ViewChildPage())
          );
        } else {
          print('Failed to add user: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }
}