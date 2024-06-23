import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';

class TambahBunga extends StatefulWidget {
  const TambahBunga({super.key});

  @override
  State<TambahBunga> createState() => _TambahBungaState();
}

class _TambahBungaState extends State<TambahBunga> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController persenController = TextEditingController();
  int? _selectedAktif;
  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  Future<void> addBunga() async {
    try {
      final response = await _dio.post(
        '$_apiUrl/addsettingbunga',
        data: {
          'persen': persenController.text,
          'isaktif': _selectedAktif,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${_storage.read('token')}',
          },
        ),
      );
      Map<String, dynamic> responseData = response.data;
      print('Response: ${responseData}');
      setState(() {
        if (responseData['success']) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Yeay!"),
                content: const Text('Bunga berhasil ditambahkan!'),
                actions: <Widget>[
                  TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Wait...'),
                content: Text(responseData['message']),
                actions: <Widget>[
                  TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      });
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Oops!"),
            content: Text(e.response?.data['message'] ?? 'An error occurred'),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: Text(
          'Penambahan Bunga',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.indigo,
              ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.indigo),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                const SizedBox(height: 10),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      DropdownButtonFormField<int>(
                        value: _selectedAktif,
                        onChanged: (value) {
                          setState(() {
                            _selectedAktif = value;
                          });
                        },
                        items: const [
                          DropdownMenuItem<int>(
                            value: 0,
                            child: Text('Tidak Aktif'),
                          ),
                          DropdownMenuItem<int>(
                            value: 1,
                            child: Text('Aktif'),
                          ),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Status Bunga',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) =>
                            value == null ? 'Silakan pilih status bunga' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: persenController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Persentase Bunga',
                          prefixIcon: const Icon(Icons.percent, color: Colors.indigo),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Silakan masukkan persentase bunga';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Nominal harus berupa angka';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState?.save();
                                  addBunga();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text(
                                'Tambahkan Bunga',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
