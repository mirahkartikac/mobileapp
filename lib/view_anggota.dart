import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobileapp/add_anggota.dart';
import 'package:mobileapp/home_page.dart';
import 'package:mobileapp/profile_page.dart';
import 'package:mobileapp/user_card.dart';
import 'package:mobileapp/user_model.dart';

class ViewAnggotaPage extends StatefulWidget {
  ViewAnggotaPage({super.key});

  @override
  State<ViewAnggotaPage> createState() => _ViewAnggotaPageState();
}

class _ViewAnggotaPageState extends State<ViewAnggotaPage> {
  final _storage = GetStorage();
  final Dio _dio = Dio();
  bool isLoading = true;
  String? errorMessage;
  late List<UserModel> users = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final String? authToken = _storage.read('token');
    if (authToken == null) {
      setState(() {
        errorMessage = 'Token not available';
        isLoading = false;
      });
      return;
    }

    try {
      final response = await _dio.get(
        'https://mobileapis.manpits.xyz/api/anggota',
        options: Options(
          headers: {'Authorization': 'Bearer $authToken'},
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data;
        print('Response Data: $responseData'); // Log the response data

        if (responseData.containsKey('data') && responseData['data'].containsKey('anggotas')) {
          List<dynamic> data = responseData['data']['anggotas'];

          List<UserModel> userList = data.map((item) {
            return UserModel(
              id: item['id'],
              noInduk: item['nomor_induk'].toString(),
              name: item['nama'],
              address: item['alamat'],
              dateOfBirth: item['tgl_lahir'],
              phoneNumber: item['telepon'],
            );
          }).toList();

          setState(() {
            users = userList;
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Data not found in the response';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to fetch data: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }
  Future<void> confirmDelete(UserModel user) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // pengguna harus menekan tombol
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Apakah Anda yakin ingin menghapus anggota ini?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tidak'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ya'),
              onPressed: () {
                Navigator.of(context).pop();
                deleteUser(user);
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> deleteUser(UserModel user) async {
    final String? authToken = _storage.read('token');
    if (authToken == null) {
      print('Token not available');
      return;
    }

    try {
      final response = await _dio.delete(
        'https://mobileapis.manpits.xyz/api/anggota/${user.id}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          users.remove(user); // Hapus pengguna dari daftar
        });
      } else {
        print('Failed to delete user: ${response.statusCode}');
        print('Response data: ${response.data}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void updateUser(UserModel updatedUser) {
    setState(() {
      int index = users.indexWhere((user) => user.id == updatedUser.id);
      if (index != -1) {
        users[index] = updatedUser;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('List Anggota'),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddUserPage(onUserAdded: (newUser) {
                    setState(() {
                      users.add(newUser);
                    });
                  })),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : errorMessage != null
                ? Text(errorMessage!)
                : users.isNotEmpty
                    ? ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return UserCard(
                            user: users[index],
                            onUserEdited: (editedUser) {
                              updateUser(editedUser);
                            },
                            onDelete: (user) {
                              confirmDelete(user);
                            },
                          );
                        },
                      )
                    : const Text("Empty"),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: 80,
        color: Colors.indigo,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            BottomNavItem(title: "Child", svgSrc: "assets/images/children.svg", isActive: true, press: (){},),
            BottomNavItem(title: "Home", svgSrc: "assets/images/calendar.svg", press: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage())
              );
            },),
            BottomNavItem(title: "Saya", svgSrc: "assets/images/account.svg", press: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage())
              );
            },),
          ],
        ),
      ),
    );
  }
}
