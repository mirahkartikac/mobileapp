import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobileapp/home_page.dart';
import 'package:mobileapp/login_page.dart';
import 'package:mobileapp/view_anggota.dart';

class ProfilePage extends StatefulWidget{
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Color mainColor;
  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api/';
  String name = "";
  String email = "";

  @override
  void initState(){
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: 80,
        color: Colors.indigo,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            BottomNavItem(title: "Child", svgSrc: "assets/images/children.svg", press: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewAnggotaPage())
              );
            },
            ),
            BottomNavItem(title: "Home", svgSrc: "assets/images/calendar.svg", press: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage())
              );
            },),
            BottomNavItem(title: "Saya", svgSrc: "assets/images/account.svg", isActive: true, press: (){},),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            const CircleAvatar(
              radius: 70,
              backgroundImage: AssetImage('assets/images/mom.png'),
            ),
            const SizedBox(
              height: 20,
            ),
            itemsProfile('Nama', name, CupertinoIcons.person),
            const SizedBox(
              height: 20,
            ),
            itemsProfile('Email', email, CupertinoIcons.mail),
            const SizedBox(
              height: 20,
            ),
            itemsProfile('Password', 'Manage your password', Icons.password),
            const SizedBox(
              height: 120,
            ),
            itemsProfile('Logout', 'Logout here', Icons.logout_rounded, goLogout),
          ],
        ),
      ),
    );
  }

  itemsProfile(String title, String subtitle, IconData iconData, [Function? press]){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Colors.indigo.withOpacity(.2),
            spreadRadius: 4,
            blurRadius: 8,
          )
        ]
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
        onTap: press != null? () => press() : null,
        trailing: const Icon(Icons.arrow_forward, color: Colors.grey,),
        
        tileColor: Colors.white,
      ),
    );
  }

  void getUser() async{
    try {
      final response = await _dio.get(
        '${_apiUrl}user',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        )
      );
      print(response.data);
      final username = response.data['data']['user']['name'];
      final useremail = response.data['data']['user']['email'];
      setState(() {
        name = username;
        email = useremail;
      });
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }
  
  void goLogout() async{
    try {
      final response = await _dio.get(
        '${_apiUrl}logout',
        options: Options(
          headers: {'Authorization' : 'Bearer ${_storage.read('token')}'},
        )
      );
      print(response.data);
      if(response.statusCode == 200){

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage())
        );
      }else{
        print('Logout gagal: ${response.data}');
      }
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }
}