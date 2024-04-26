import 'dart:convert';

import 'package:arabakiralama/urunler.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CarDetail.dart';
import 'MyProfile.dart';
import 'Notifications.dart';
import 'SearchPage.dart';


class HomePage extends StatefulWidget {
  final String username;
  final bool isDarkMode;
  final bool isTurkish;

  const HomePage({Key? key, required this.username, required this.isDarkMode, required this.isTurkish}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Urun> cartItems = []; // Sepete eklenen ürünlerin listesi

  @override
  void initState() {
    super.initState();
    // Kullanıcı sepetini yükle
    _loadCart();
  }



  void _loadCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartJsonList = prefs.getStringList(widget.username);
    if (cartJsonList != null) {
      setState(() {
        cartItems = cartJsonList.map((json) => Urun.fromJson(jsonDecode(json))).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions(context).elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black45,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }



  List<Widget> _widgetOptions(BuildContext context) {
    return <Widget>[
      ShopPage(
        username: widget.username,
        isDarkMode: widget.isDarkMode, isTurkish: widget.isTurkish,
      ),
      SearchPage(username: widget.username, isDarkMode: widget.isDarkMode, isTurkish: widget.isTurkish,),
      NotificationsPage(isDarkMode: widget.isDarkMode, isTurkish: widget.isTurkish,),
      MyProfile(username: widget.username, isDarkMode: widget.isDarkMode, isTurkish: widget.isTurkish,),
    ];
  }
}

class ShopPage extends StatefulWidget {
  final String username;
  final bool isDarkMode;
  final bool isTurkish;

  ShopPage({required this.username, required this.isDarkMode, required this.isTurkish});
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  late List<Urun> filteredUrunler = urunler; // filteredUrunler listesini burada tanımlayın
  late Map<int, bool> isAddedToCartMap = {}; // isAddedToCartMap haritasını burada tanımlayın

  // SharedPreferences nesnesi
  late SharedPreferences _prefs;

  void _onCarTapped(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CarDetail(urun: urunler[index], username: widget.username, isDarkMode: widget.isDarkMode, isTurkish: widget.isTurkish,)),
    );
  }


  @override
  void initState() {
    super.initState();
    // SharedPreferences örneğini yükleyin
    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
      // Kaydedilmiş sepet durumunu yükle
    });
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: widget.isDarkMode ? Colors.grey[700] : Colors.grey[300],
        body: SingleChildScrollView(
          child: Column(
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
                            widget.isTurkish ? 'Ana Sayfa' : 'Home',
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
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Text(widget.isTurkish ? 'EN İYİ FIRSATLAR' : 'TOP DEALS',
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,
                        color: widget.isDarkMode ? Colors.white : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SizedBox(
                  height: 320, // İstediğiniz yüksekliği ayarlayabilirsiniz
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal, // Yatay kaydırma
                    itemCount: 3, // İlk 3 araç
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 8), // Araçlar arası boşluk
                        child: GestureDetector(
                          onTap: () => _onCarTapped(index),
                          child: Card(
                            color: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                  child: Image.asset(
                                    urunler[index].imageUrl,
                                    fit: BoxFit.cover,
                                    width: 250, // İstediğiniz genişliği ayarlayabilirsiniz
                                    height: 180, // İstediğiniz yüksekliği ayarlayabilirsiniz
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        urunler[index].name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        widget.isTurkish ? '${urunler[index].price} \nAylık' : '${urunler[index].price} \nMonthly',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[900],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Text(widget.isTurkish ? 'TÜM ARAÇLAR' : 'ALL CARS',
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,
                        color: widget.isDarkMode ? Colors.white : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: urunler.length, // Tüm araba sayısı
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _onCarTapped(index),
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                            child: Image.asset(
                              urunler[index].imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  urunler[index].name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  widget.isTurkish ? '${urunler[index].price} \nAylık' : '${urunler[index].price} \nMonthly',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }
  }
