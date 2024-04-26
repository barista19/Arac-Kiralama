import 'dart:math';

import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  final bool isDarkMode;
  final bool isTurkish;
  const NotificationsPage({Key? key, required this.isDarkMode, required this.isTurkish}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<String> notificationsTurkish = [
    "Yüksek performanslı Nissan GTR şimdi kiralanabilir!",
    "Land Rover Discovery ile doğaya kaçış!",
    "Yeni Chevrolet Camaro: Egzotik bir sürüş deneyimi!",
    "Toyota Supra ile hız tutkunlarının tercihi!",
    "Ferrari F40: Efsane geri döndü!",
    "Bugatti Bolide: Hızın zirvesi!",
  ];

  final List<String> notificationsEnglish = [
    "High-performance Nissan GTR is now available for rent!",
    "Escape to nature with Land Rover Discovery!",
    "New Chevrolet Camaro: Exotic driving experience!",
    "Toyota Supra, the choice of speed enthusiasts!",
    "Ferrari F40: The legend is back!",
    "Bugatti Bolide: The pinnacle of speed!",
  ];

  @override
  Widget build(BuildContext context) {
    List<String> notifications = widget.isTurkish ? notificationsTurkish : notificationsEnglish;
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.grey[700] : Colors.grey[300],
      body: Column(
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
                SizedBox(height: 50.0), // Fotoğraf ile yazı arasında boşluk
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isTurkish! ? 'Bildirimler' : 'Notifications',
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
          Expanded(
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return Card(
                  color: widget.isDarkMode ? Colors.grey[900] : Colors.white,
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    leading: Icon(Icons.notifications,
                      color: widget.isDarkMode ? Colors.white : Colors.black,),
                    title: Text(
                      notifications[index],
                      style: TextStyle(fontSize: 16,
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    onTap: () {
                      // Buraya tıklanma işlemleri eklenebilir
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
