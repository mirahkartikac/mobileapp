import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobileapp/category_card.dart';
import 'package:mobileapp/profile_page.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api/';
  late Color mainColor;
  late String name = "";

  @override
  void initState(){
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    mainColor = Colors.indigo;
    String username = name;
    return Scaffold(
      
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: 80,
        color: Colors.indigo,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            BottomNavItem(title: "Trending", svgSrc: "assets/images/trending.svg", press: (){},),
            BottomNavItem(title: "Home", svgSrc: "assets/images/calendar.svg", isActive: true, press: (){},),
            BottomNavItem(title: "Saya", svgSrc: "assets/images/account.svg",press: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage())
              );
            },),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * .45,
            decoration: BoxDecoration(
              color: mainColor,
              image: DecorationImage(
                image: const AssetImage("assets/images/honeybg.png"),
                alignment: Alignment.centerLeft,
                colorFilter: ColorFilter.mode(mainColor.withOpacity(0.1), BlendMode.dstATop )
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      alignment: Alignment.center,
                      height: 52,
                      width: 52,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset("assets/images/natural.svg"),
                    ),
                  ),
                  Text(
                    'Halo $username',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 42,
                    )
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 30),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(29.5),
                    ),
                    child: TextField( 
                      decoration: InputDecoration(
                        hintText: "Cari",
                        icon: SvgPicture.asset("assets/images/search.svg"),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Expanded(
                    
                    child: GridView.count(
                      
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      
                      children: const <Widget>[
                        CategoryCard(
                          svgSrc: "assets/images/healthy (1).svg",
                          title: "Kalkulator Gizi",
                        ),
                        CategoryCard(
                          svgSrc: "assets/images/eat-healthy (1).svg",
                          title: "Asupan Sehat",
                        ),
                        CategoryCard(
                          svgSrc: "assets/images/sleep.svg",
                          title: "Kualitas Tidur",
                        ),
                        CategoryCard(
                          svgSrc: "assets/images/healthy-study.svg",
                          title: "Pembelajaran Kesehatan",
                        ),
                        
                      ],
                    )
                  ),
                ],
              ),
            )
          )
        ],
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
      final username = response.data['data']['user']['name'];;
      setState(() {
        name = username;
      });
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }
}

class BottomNavItem extends StatelessWidget {
  final String svgSrc;
  final String title;
  final Function press;
  final bool isActive;
  const BottomNavItem({
    super.key, required this.svgSrc, required this.title, required this.press, this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        press();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SvgPicture.asset(
            svgSrc,
            width: 40,
            height: 40,
            colorFilter: ColorFilter.mode(
              isActive? Colors.white : Colors.black,
              BlendMode.srcATop),
            ),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive? Colors.white : Colors.black
            ),
          ),
        ],
      ),
    );
  }
}

