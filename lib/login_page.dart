import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobileapp/home_page.dart';
import 'package:dio/dio.dart';
import 'package:mobileapp/register_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();


}

class _LoginPageState extends State<LoginPage> {

  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api/';

  late Color myColor;
  late Size mediaSize;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberUser = false;
  @override
  Widget build(BuildContext context) {
    myColor = Colors.white;
    mediaSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: myColor,
        image: DecorationImage(
          image: const AssetImage("assets/images/bg.jpeg"),
          fit: BoxFit.cover,
          colorFilter: 
              ColorFilter.mode(myColor.withOpacity(0.01), BlendMode.dstOver)
              )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Positioned(top: 30, child: _buildTop()),
          Positioned(bottom: 0, child: _buildBottom()),
        ]),
      ),
    );
  }

  Widget _buildTop(){
    return SizedBox(
      width: mediaSize.width,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.align_vertical_center_rounded,
            size: 150,
            color: Colors.white,
          ),
          Text(
            "S & L",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 40,
              letterSpacing: 2,
            ),
          ),
          Text(
            "Save and Lend : Aplikasi Simpan Pinjam Terdepan",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: 14,
              letterSpacing: 1,
              
            ),
            
          )
        ],
      ),
    );
  }

  Widget _buildBottom(){
    return SizedBox(
      width: mediaSize.width,
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          )),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Selamat Datang",
          style: TextStyle(
            color: Colors.indigo,
            fontSize: 32,
            fontWeight: FontWeight.w500
          ),
        ),
        _buildGreyText("Mohon login dengan data Anda"),
        const SizedBox(height: 18,),
        _buildGreyText("Alamat Email"),
        _buildInputField(emailController),
        const SizedBox(height: 15,),
        _buildGreyText("Password"),
        _buildInputField(passwordController),
        _buildRememberForgot(),
        const SizedBox(height: 15,),
        _buildLoginButton(),
        const SizedBox(height: 10,),
        _buildBlackText("Belum memiliki akun? Daftar disini"),
        const SizedBox(height: 10,),
        _buildRegisterButton(),
      ],
    );
  }

  Widget _buildGreyText(String text){
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.grey,
        fontWeight: FontWeight.bold
      ),
    );
  }


  Widget _buildInputField(TextEditingController controller,
      {isPassword = false}){
      return TextField(
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: isPassword? const Icon(Icons.remove_red_eye) : const Icon(Icons.done),
        ),
        obscureText: isPassword,
      );
  }

  Widget _buildRememberForgot(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(value: rememberUser, onChanged: (value){
              setState(() {
                rememberUser = value!;
              });
            }),
            _buildGreyText("Ingat saya"),
          ],
        ),
        TextButton(onPressed: (){}, child: _buildUnderlineText("Lupa password?"))
      ],

    );
  }

  Widget _buildLoginButton(){
    return ElevatedButton(
      onPressed: (){
        goLogin();
        
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 20,
        backgroundColor: Colors.indigo,
        shadowColor: Colors.indigo,
        minimumSize: const Size.fromHeight(60),
      ),
      child: const Text(
          "LOGIN",
          style: TextStyle(
            color: Colors.white
          ),
        ),
      );
  }

  Widget _buildBlackText(String text){
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  Widget _buildRegisterButton(){
    return ElevatedButton(
      onPressed: (){
        
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegisterPage())
        );
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 20,
        backgroundColor: Colors.white,
        shadowColor: Colors.indigo,
        minimumSize: const Size.fromHeight(45),
      ),
      child: const Text(
          "DAFTAR DI SINI",
          style: TextStyle(
            color: Colors.indigo
          ),
      ),
    );
  }

  Widget _buildUnderlineText(String text){
    return Text(
      text,
      style: const TextStyle(
        decoration: TextDecoration.underline,
      ),
    );
  }
  void goLogin() async{
    try {
      final response = await _dio.post(
        '${_apiUrl}login',  
        data: {
          'email':emailController.text,
          'password':passwordController.text
        }
      );
      print(response.data);
      if(response.statusCode == 200){
        _storage.write('token', response.data['data']['token']);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage())
        );
      }else{
        print('Login gagal: ${response.data}');
      }

    } on DioException catch (e) {
      print('Halo ${e.response} - ${e.response?.statusCode}');
    }
  }
}

