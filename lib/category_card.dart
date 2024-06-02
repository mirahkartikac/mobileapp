import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CategoryCard extends StatelessWidget {
  final String svgSrc;
  final String title;
  final VoidCallback? press; // Added press callback

  const CategoryCard({
    super.key, 
    required this.svgSrc, 
    required this.title, 
    this.press, // Initialize the press callback
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          onTap: press, // Use the press callback
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 30),
                SvgPicture.asset(
                  svgSrc,
                  width: 60, // Set a width for the SVG image
                  height: 60, // Set a height for the SVG image
                ),
                SizedBox(height: 10),
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
