import 'package:flutter/material.dart';
import 'package:mobileapp/transaksi/jenis_transaksi.dart';

class DetailPage extends StatelessWidget {
  final JenisTransaksi jenisTransaksi;

  const DetailPage({Key? key, required this.jenisTransaksi}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mendapatkan lebar layar
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Transaksi'),
      ),
      body: Center(
        // Membuat Center agar kartu berada di tengah secara horizontal
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            // Mengatur lebar kartu secara dinamis
            child: Container(
              width: screenWidth * 0.9, // Kartu mengambil 90% lebar layar
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      jenisTransaksi.namaTransaksi,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
