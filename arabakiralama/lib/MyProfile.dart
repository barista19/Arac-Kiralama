import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfile extends StatefulWidget {
  final String username;
  final bool isDarkMode;
  final bool isTurkish;
  const MyProfile({Key? key, required this.username, required this.isDarkMode, required this.isTurkish}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  String name = '';
  String mail = '';
  String phoneNumber = '';
  List<String> rentedCars = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadRentedCars();
  }

  // Kullanıcı bilgilerini yükleme
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name_${widget.username}') ?? '';
      mail = prefs.getString('mail_${widget.username}') ?? '';
      phoneNumber = prefs.getString('phoneNumber_${widget.username}') ?? '';
    });
  }

  // Kiralanan araçları yükleme
  Future<void> _loadRentedCars() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      rentedCars = prefs.getStringList('rentedCars_${widget.username}') ?? [];
      // Eğer kiraladığınız araçlar boş değilse, her bir aracın ismini yükleyin
      for (String carKey in rentedCars) {
        String carName = prefs.getString('rentedCarName_${widget.username}_$carKey') ?? '';
        // İsim ile ID arasındaki _ karakterini bul
        int separatorIndex = carName.indexOf('_');
        // ID'den önceki kısmı al
        carName = carName.substring(0, separatorIndex);
        rentedCars.add(carName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.grey[700] : Colors.grey[300],

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                          widget.isTurkish! ? 'Profilim' : 'My Profile',
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text(
                        widget.isTurkish ? 'Profilim' : 'My Profile',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                          color: widget.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    child: Icon(Icons.person, size: 80),
                    radius: 50,
                  ),
                  SizedBox(height: 20),
                  // İsim Kartı
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text(widget.isTurkish ? 'İsim: $name' : 'Name: $name', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text(widget.isTurkish ? 'Kullanıcı Adı: ${widget.username}' : 'Username: ${widget.username}', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  SizedBox(height: 10),
                  // E-posta Kartı
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.mail),
                      title: Text(widget.isTurkish ? 'E-posta: $mail' : 'E-mail: $mail', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Telefon Kartı
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.phone),
                      title: Text(widget.isTurkish ? 'Telefon: $phoneNumber' : 'Phone: $phoneNumber', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Kiralanan Araçlar Kartları
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                widget.isTurkish ? 'Kiraladığınız Araçlar' : 'Rented Cars',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: rentedCars.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(rentedCars[index]),
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
