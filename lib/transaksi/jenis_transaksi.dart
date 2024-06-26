import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import 'package:mobileapp/transaksi/detail_jenis_tranx.dart';

class JenisTranx extends StatefulWidget {
  const JenisTranx({super.key});

  @override
  State<JenisTranx> createState() => _JenisTranxState();
}

class _JenisTranxState extends State<JenisTranx> {
  JenisTransaksis? jenisTransaksis;
  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  @override
  void initState() {
    super.initState();
    getTransactionType();
  }

  Future<void> getTransactionType() async {
    try {
      final _response = await _dio.get(
        '$_apiUrl/jenistransaksi',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      Map<String, dynamic> responseData = _response.data;
      setState(() {
        jenisTransaksis = JenisTransaksis.fromJson(responseData['data']);
      });
    } on DioError catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }

  void navigateToDetail(JenisTransaksi jenisTransaksi) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(jenisTransaksi: jenisTransaksi),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.indigo),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Transaksi',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.indigo,
                )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: jenisTransaksis == null
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: jenisTransaksis!.jenisTransaksis.length,
                itemBuilder: (context, index) {
                  final jenisTransaksi =
                      jenisTransaksis!.jenisTransaksis[index];
                  final multiply = jenisTransaksi.multiplyTransaksi == '1'
                      ? 'Penambahan'
                      : 'Pengurangan';
                  return InkWell(
                    onTap: () {
                      navigateToDetail(jenisTransaksi);
                    },
                    child: Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(jenisTransaksi.namaTransaksi),
                        subtitle: Row(
                          children: [
                            Icon(Icons.wallet_membership, size: 14),
                            SizedBox(width: 6),
                            Text(multiply),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class JenisTransaksi {
  final int id;
  final String namaTransaksi;
  final String multiplyTransaksi;

  JenisTransaksi({
    required this.id,
    required this.namaTransaksi,
    required this.multiplyTransaksi,
  });

  factory JenisTransaksi.fromJson(Map<String, dynamic> json) {
    return JenisTransaksi(
      id: json['id'],
      namaTransaksi: json['trx_name'],
      multiplyTransaksi: json['trx_multiply'].toString(),
    );
  }
}

class JenisTransaksis {
  final List<JenisTransaksi> jenisTransaksis;

  JenisTransaksis({required this.jenisTransaksis});

  factory JenisTransaksis.fromJson(Map<String, dynamic> json) {
    final jenisTransaksi = json['jenistransaksi'] as List<dynamic>;
    return JenisTransaksis(
      jenisTransaksis: jenisTransaksi
          .map((dataJenis) =>
              JenisTransaksi.fromJson(dataJenis as Map<String, dynamic>))
          .toList(),
    );
  }
}
