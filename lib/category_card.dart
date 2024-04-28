import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CategoryCard extends StatelessWidget {
  final String svgSrc;
  final String title;
  const CategoryCard({
    super.key, required this.svgSrc, required this.title, 
  });

  @override
  Widget build(BuildContext context) {
    
      return Container(
        // padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: const [
            BoxShadow(
              offset: Offset(25, 17),
              blurRadius: 17,
              spreadRadius: -23,
              color: Colors.black
            )
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: (){},
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: <Widget>[
                  SvgPicture.asset(
                    svgSrc,
                    width: 100,
                    height: 100,
                  ),
                  
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  
                ],
                ),
            ),
          ),
        ),
      );
    
  }
}