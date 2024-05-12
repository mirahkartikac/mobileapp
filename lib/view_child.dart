import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobileapp/edit_child.dart';

class ViewChildPage extends StatefulWidget {
  final _storage = GetStorage();

  ViewChildPage({Key? key}) : super(key: key);

  @override
  _ViewChildPageState createState() => _ViewChildPageState();
}

class _ViewChildPageState extends State<ViewChildPage> {
  late List<Map<String, dynamic>> _anakList;

  @override
  void initState() {
    super.initState();
    // Ambil data anak dari local storage saat halaman dimuat
    List<dynamic>? anakListDynamic = widget._storage.read<List<dynamic>>("children");
    // Konversi ke List<Map<String, dynamic>> jika tidak null
    _anakList = anakListDynamic != null ? List<Map<String, dynamic>>.from(anakListDynamic) : [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Anak'),
      ),
      body: _anakList.isNotEmpty
          ? ListView.builder(
              itemCount: _anakList.length,
              itemBuilder: (context, index) {
                // Tampilkan daftar anak
                return ListTile(
                  title: Text(_anakList[index]["nama"] ?? ""),
                  subtitle: Text(_anakList[index]["nomor_induk"] ?? ""),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _editAnak(index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _hapusAnak(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            )
          : const Center(
              child: Text('Belum ada data anak.'),
            ),
    );
  }

  void _editAnak(int index) {
    // Navigasi ke halaman EditChildPage dengan mengirimkan index data anak yang akan diedit
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditChildPage(index: index),
      ),
    );
  }

  void _hapusAnak(int index) {
    setState(() {
      _anakList.removeAt(index);
      widget._storage.write("children", _anakList);
    });
  }
}
