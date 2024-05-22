import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobileapp/user_card.dart';
import 'package:mobileapp/user_model.dart';

class ViewChildPage extends StatefulWidget {
  ViewChildPage({super.key});

  @override
  State<ViewChildPage> createState() => _ViewChildPageState();
}

class _ViewChildPageState extends State<ViewChildPage> {
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
      int index = users.indexWhere((user) => user.noInduk == updatedUser.noInduk);
      if (index != -1) {
        users[index] = updatedUser;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Anak'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
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
                              deleteUser(user);
                            },
                          );
                        },
                      )
                    : Text("Empty"),
      ),
    );
  }
}
