import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/WelcomeScreen.dart';

class Homescreem extends StatefulWidget {
  const Homescreem({super.key});

  @override
  State<Homescreem> createState() => _HomescreemState();
}

class _HomescreemState extends State<Homescreem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 120),
          Lottie.network(
            'https://lottie.host/0257fa13-be10-4e13-bcb4-8bae6017e5e1/PL3Cpr9Xin.json',
          ),
          SizedBox(height: 40),
          Text(
            "Welcome To Weather",
            style: GoogleFonts.oswald(
              fontSize: 30,
              color: Colors.purpleAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Know the weather of any city",
            style: GoogleFonts.oswald(fontSize: 20),
          ),
          SizedBox(height: 100),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Welcomescreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purpleAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              minimumSize: Size(250, 50),
            ),
            child: Text("Get Started", style: GoogleFonts.oswald(fontSize: 15)),
          ),
        ],
      ),
    );
  }
}
