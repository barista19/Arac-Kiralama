import 'package:arabakiralama/SplashScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue, // AppBar rengi
          foregroundColor: Colors.white, // AppBar metin rengi
          elevation: 0, // AppBar yükseltisi
          iconTheme: IconThemeData(color: Colors.white), // AppBar ikon rengi
        ),
        // Metin stilleri
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Başlık metni
          bodyText1: TextStyle(fontSize: 16, color: Colors.black), // Ana metin
          button: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), // Buton metni
        ),
        // Buton teması
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue, // Butonun arkaplan rengi
            onPrimary: Colors.white, // Butonun metin rengi
            elevation: 4, // Buton yükseltisi
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Buton şekli
          ),
        ),
        // Input alanı teması
        inputDecorationTheme: InputDecorationTheme(
        ),
      ),
      home: SplashScreen(),
    );
  }
}
