import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';

class TambahTabungan extends StatefulWidget {
  final int id;
  const TambahTabungan({Key? key, required this.id}) : super(key: key);

  @override
  _TambahTabunganState createState() => _TambahTabunganState();
}

class _TambahTabunganState extends State<TambahTabungan> {
  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';
  late TextEditingController _nominalController;
  late int _selectedTransactionID = 0;
  late int id;
  List<Map<String, dynamic>> _transactionTypes = [];
  
  @override
  void initState() {
    super.initState();
    id = widget.id;
    _nominalController = TextEditingController();
    fetchTransactionTypes();

  }

  @override
  void dispose() {
    _nominalController.dispose();
    super.dispose();
  }

  Future<void> fetchTransactionTypes() async {
    try {
      final _response = await _dio.get(
        '$_apiUrl/jenistransaksi',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      Map<String, dynamic> responseData = _response.data;
      if (responseData['success']) {
        setState(() {
          _transactionTypes = List<Map<String, dynamic>>.from(
              responseData['data']['jenistransaksi']);
        });
      }
    } catch (e) {
      print('Error fetching transaction types: $e');
    }
  }

  Future<void> addSaving() async {
    try {
      final _response = await _dio.post(
        '$_apiUrl/tabungan',
        data: {
          'anggota_id': id,
          'trx_id': _selectedTransactionID,
          'trx_nominal': int.parse(_nominalController.text)
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${_storage.read('token')}'
          },
        ),
      );
      Map<String, dynamic> responseData = _response.data;
      print(responseData);
      setState(() {
        if (responseData['success']) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Tabungan berhasil ditambahkan!"),
                  content: Text('Yeay!'),
                  actions: <Widget>[
                    TextButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(responseData['message']),
                  content: Text('Wait...'),
                  actions: <Widget>[
                    TextButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        }
      });
    } on DioError catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Oops!"),
              content: Text(e.response?.data['message'] ?? 'An error occurred'),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Tabungan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<int>(
              value: _selectedTransactionID,
              items: [
                DropdownMenuItem<int>(
                  value: 0,
                  child: Text('Select a transaction type'),
                ),
                ..._transactionTypes
                    .map((transactionType) => DropdownMenuItem<int>(
                          value: transactionType['id'],
                          child: Text(transactionType['trx_name']),
                        ))
                    .toList(),
              ],
              onChanged: (int? value) {
                setState(() {
                  _selectedTransactionID = value ?? 0;
                });
              },
              decoration: InputDecoration(
                labelText: 'Jenis Transaksi',
              ),
            ),


            SizedBox(height: 16.0),
            TextFormField(
              controller: _nominalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Nominal'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: addSaving,
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
