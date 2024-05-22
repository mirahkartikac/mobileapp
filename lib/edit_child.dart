import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class EditChildPage extends StatefulWidget {
  final int index; // Index dari data anak yang akan diedit
  final GetStorage storage = GetStorage();

  EditChildPage({super.key, required this.index});

  @override
  State<EditChildPage> createState() => _EditChildPageState();
}

class _EditChildPageState extends State<EditChildPage> {
  late TextEditingController nomorIndukController;
  late TextEditingController namaController;
  late TextEditingController alamatController;
  late TextEditingController tanggalLahirController;
  late TextEditingController noTeleponController;
  late List<Map<String, dynamic>> _anakList;

  @override
  void initState() {
    super.initState();
    // Ambil data anak berdasarkan index saat halaman dimuat
    final List<dynamic>? anakListDynamic = widget.storage.read<List<dynamic>>("children");
    if (anakListDynamic != null) {
      // Konversi ke List<Map<String, dynamic>> jika tidak null
      _anakList = List<Map<String, dynamic>>.from(anakListDynamic);
    } else {
      // Jika data kosong atau tidak ada, inisialisasi _anakList dengan list kosong
      _anakList = [];
    }
    // Inisialisasi controller dengan nilai default jika data tidak ditemukan
    Map<String, dynamic> defaultChildData = {
      'nomor_induk': '',
      'nama': '',
      'alamat': '',
      'tgl_lahir': '',
      'telepon': '',
    };
    if (_anakList.isNotEmpty && widget.index < _anakList.length) {
      nomorIndukController = TextEditingController(text: _anakList[widget.index]["nomor_induk"] ?? defaultChildData["nomor_induk"]);
      namaController = TextEditingController(text: _anakList[widget.index]["nama"] ?? defaultChildData["nama"]);
      alamatController = TextEditingController(text: _anakList[widget.index]["alamat"] ?? defaultChildData["alamat"]);
      tanggalLahirController = TextEditingController(text: _anakList[widget.index]["tgl_lahir"] ?? defaultChildData["tgl_lahir"]);
      noTeleponController = TextEditingController(text: _anakList[widget.index]["telepon"] ?? defaultChildData["telepon"]);
    } else {
      nomorIndukController = TextEditingController(text: defaultChildData["nomor_induk"]);
      namaController = TextEditingController(text: defaultChildData["nama"]);
      alamatController = TextEditingController(text: defaultChildData["alamat"]);
      tanggalLahirController = TextEditingController(text: defaultChildData["tgl_lahir"]);
      noTeleponController = TextEditingController(text: defaultChildData["telepon"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Data Anak'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nomorIndukController,
              decoration: InputDecoration(labelText: 'Nomor Induk'),
            ),
            TextField(
              controller: namaController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: alamatController,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            TextField(
              controller: tanggalLahirController,
              decoration: InputDecoration(labelText: 'Tanggal Lahir (yyyy-mm-dd)'),
            ),
            TextField(
              controller: noTeleponController,
              decoration: InputDecoration(labelText: 'Nomor Telepon'),
            ),
            ElevatedButton(
              onPressed: () {
                _simpanPerubahan();
              },
              child: Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }

  void _simpanPerubahan() {
    // Simpan perubahan data anak ke penyimpanan lokal
    List<dynamic>? existingChildrenDynamic = widget.storage.read<List<dynamic>>("children");
    List<Map<String, dynamic>> existingChildren = existingChildrenDynamic != null 
        ? List<Map<String, dynamic>>.from(existingChildrenDynamic) 
        : [];
    if (widget.index < existingChildren.length) {
      existingChildren[widget.index] = {
        'nomor_induk': nomorIndukController.text,
        'nama': namaController.text,
        'alamat': alamatController.text,
        'tgl_lahir': tanggalLahirController.text,
        'telepon': noTeleponController.text
      };
    } else {
      // Handle case where index is out of range
      return;
    }
    widget.storage.write("children", existingChildren);
    // Kembali ke halaman sebelumnya setelah menyimpan perubahan
    Navigator.pop(context);
  }

  @override
  void dispose() {
    // Pastikan untuk membebaskan sumber daya ketika widget dihapus
    nomorIndukController.dispose();
    namaController.dispose();
    alamatController.dispose();
    tanggalLahirController.dispose();
    noTeleponController.dispose();
    super.dispose();
  }
}
