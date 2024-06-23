import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import 'package:mobileapp/transaksi/tambah_bunga.dart';

class ListBunga extends StatefulWidget {
  const ListBunga({super.key});

  @override
  State<ListBunga> createState() => _ListBungaState();
}

class _ListBungaState extends State<ListBunga> {
  BungaData? bungaData;
  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  @override
  void initState() {
    super.initState();
    getBungaData();
  }

  Future<void> getBungaData() async {
    try {
      final _response = await _dio.get(
        '$_apiUrl/settingbunga',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      setState(() {
        bungaData = BungaData.fromJson(_response.data);
        print('Bunga data: $bungaData');
      });
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: Text(
          'Bunga',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.indigo,
              ),
        ),
        actions: [
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(26, 60, 32, 239),
            ),
            child: IconButton(
              onPressed: () {
                getBungaData();
              },
              icon: const Icon(
                Icons.refresh,
                size: 32,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(26, 88, 66, 231),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TambahBunga())
                );
              },
              icon: const Icon(
                Icons.add,
                size: 32,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: bungaData == null
            ? const Center(child: CircularProgressIndicator())
            : bungaData!.isEmpty()
                ? const Center(
                    child: Text(
                      "Belum ada bunga yang ditambahkan.",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  )
                : ListView(
                    children: [
                      if (bungaData!.activeBunga != null)
                        Text(
                          'Bunga Aktif',
                          style:
                              Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo,
                                  ),
                        ),
                        Card(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                          child: ListTile(
                            title: Text(
                              'id: ${bungaData!.activeBunga!.id}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            trailing: Text(
                              'persen: ${bungaData!.activeBunga!.persen}%',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      const Divider(),
                      Text(
                        'Bunga Tidak Aktif',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo,
                                ),
                      ),
                      if (bungaData!.inactiveBunga.isNotEmpty)
                        ...bungaData!.inactiveBunga
                            .map((bunga) => Card(
                                  margin: const EdgeInsets.symmetric(vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  elevation: 3,
                                  child: ListTile(
                                    title: Text(
                                      'id: ${bunga.id}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    trailing: Text(
                                      'persen: ${bunga.persen}%',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ))
                            ,
                    ],
                  ),  
      ),
    );
  }
}

class Bunga {
  final int id;
  final int persen;
  final int isaktif;

  Bunga({
    required this.id,
    required this.persen,
    required this.isaktif,
  });

  factory Bunga.fromJson(Map<String, dynamic> json) {
    return Bunga(
      id: json['id'],
      persen: json['persen'],
      isaktif: json['isaktif'],
    );
  }
}

class BungaData {
  final Bunga? activeBunga;
  final List<Bunga> inactiveBunga;

  BungaData({this.activeBunga, required this.inactiveBunga});

  factory BungaData.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final activeBungaJson = data['activebunga'];
    final List<dynamic> settingbungasJson = data['settingbungas'];

    Bunga? activeBunga;
    List<Bunga> inactiveBunga = [];

    if (activeBungaJson != null) {
      activeBunga = Bunga.fromJson(activeBungaJson);
    }

    if (settingbungasJson != null) {
      inactiveBunga = settingbungasJson
          .map((data) => Bunga.fromJson(data))
          .where((bunga) => bunga.isaktif == 0)
          .toList();
    }

    return BungaData(
      activeBunga: activeBunga,
      inactiveBunga: inactiveBunga,
    );
  }


  bool isEmpty() {
    return activeBunga == null && inactiveBunga.isEmpty;
  }
}