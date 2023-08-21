import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    Key? key,
    required this.name,
    required this.bio,
    required this.imageUrl,
    required this.color,

  }) : super(key: key);

  final String name;
  final String bio;
  final String imageUrl;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: MediaQuery.of(context).size.width*0.07,),
         imageUrl.isEmpty
    ? Container(
        width: 95,
        height: 95,
        child: Icon(Icons.person,color: color,),
      )
    : Container(
        width: 90,
        height:90,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: color,
            width:1,
          ),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
      SizedBox(width: MediaQuery.of(context).size.width*0.07,),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style:  GoogleFonts.inter(
              color: Color.fromARGB(255, 32, 81, 34),
              
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 5,),
          Text(
            bio,
            style: GoogleFonts.aclonica(
              color: Color.fromARGB(255, 28, 60, 29),
             
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      ],
    );
  }
}
