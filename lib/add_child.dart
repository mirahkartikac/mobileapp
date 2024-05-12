import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobileapp/home_page.dart';
import 'package:mobileapp/view_child.dart';

class AddChild extends StatefulWidget{
  const AddChild({super.key});
  
  @override
  State<AddChild> createState() => AddChildState();
}



class AddChildState extends State<AddChild> {
  late Color myColor;

  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  TextEditingController nomorIndukController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController tanggalLahirController = TextEditingController();
  TextEditingController noTeleponController = TextEditingController();
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
        const SizedBox(height: 10,),
        _buildBlackText("Nomor Induk Anak"),
        _buildInputField(nomorIndukController),
        const SizedBox(height: 10,),
        _buildBlackText("Nama"),
        _buildInputField(namaController),
        const SizedBox(height: 10,),
        _buildBlackText("Alamat"),
        _buildInputField(alamatController),
        const SizedBox(height: 10,),
        _buildBlackText("Tanggal Lahir"),
        _buildInputField(tanggalLahirController),
        const SizedBox(height: 10,),
        _buildBlackText("No Telepon"),
        _buildInputField(noTeleponController),
        const SizedBox(height: 10,),
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

  void goTambahAnak() async{
    final String noInduk = nomorIndukController.text;
    final String nama = namaController.text;
    final String alamat = alamatController.text;
    final String tanggalLahir = tanggalLahirController.text;
    final String noTelepon = noTeleponController.text;
    List<Map<String, dynamic>>? existingChildren = _storage.read<List<Map<String, dynamic>>>("children");
    existingChildren ??= [];
    existingChildren.add({
      'nomor_induk': noInduk,
      'nama': nama,
      'alamat': alamat,
      'tgl_lahir': tanggalLahir,
      'telepon': noTelepon
    });
    _storage.write("children", existingChildren);
    

    nomorIndukController.clear();
    namaController.clear();
    alamatController.clear();
    noTeleponController.clear();
    tanggalLahirController.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ViewChildPage()),
    );
  }
}