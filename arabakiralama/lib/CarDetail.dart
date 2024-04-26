import 'package:flutter/material.dart';
import 'package:arabakiralama/urunler.dart';

import 'KiralamaSayfasi.dart';

class CarDetail extends StatelessWidget {
  final Urun urun;
  final String username;
  final bool isDarkMode;
  final bool isTurkish;

  const CarDetail({Key? key, required this.urun, required this.username, required this.isDarkMode, required this.isTurkish}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[700] : Colors.grey[300],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: double.infinity, // Yatayda ekranı kaplayacak
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.0), // Sol üst köşe
                bottomRight: Radius.circular(30.0), // Sağ üst köşe
              ),
              color: Colors.white, // Container rengi
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isTurkish ? 'Kiralama Sayfası' : 'Renting Page',
                        style: TextStyle(
                            fontSize: 23.0, fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0), // Yazı ile container arasında boşluk
              ],
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              urun.imageUrl,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  urun.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "\$${urun.price} Total",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Text(isTurkish ? 'kiraladığınız araçları profilim sayfasından görüntüleyebilirsiniz.' : 'View the vehicles you rented from the profile page.',
            style: TextStyle(fontSize: 20,
              color: isDarkMode ? Colors.white : Colors.black,
            ),),
          ),

        ],
      ),
      bottomSheet: Container(
        height: 80,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isTurkish ? 'Aylık' : 'Monthly',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "\$${urun.price}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RentingCar(isDarkMode: isDarkMode, isTurkish: isTurkish, urun: urun, username: username,)),
                );
                },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
              child: Text(
                isTurkish ? 'Bu arabayı seç' : 'Select this car',
                style: TextStyle(
                  fontSize: 19,
                  color: Colors.white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
