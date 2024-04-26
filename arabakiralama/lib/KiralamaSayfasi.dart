import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:arabakiralama/urunler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RentingCar extends StatefulWidget {
  final Urun urun;
  final String username;
  final bool isDarkMode;
  final bool isTurkish;

  const RentingCar({Key? key, required this.urun, required this.username, required this.isDarkMode, required this.isTurkish}) : super(key: key);

  @override
  State<RentingCar> createState() => _RentingCarState();
}

class _RentingCarState extends State<RentingCar> {
  String cardNumber = '';
  String cardDate = '';
  String cardCVV = '';
  String errorMessage = '';

  // FlutterLocalNotificationsPlugin instance'ı oluşturun
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.grey[700] : Colors.grey[300],

      appBar: AppBar(
        title: Text(widget.isTurkish ? 'Araba Kiralama' : 'Renting Car'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Kredi kartı görüntüsü
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kart Numarası',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(cardNumber),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tarih', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(cardDate),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('CVV', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(cardCVV),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Textfield'lar
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kart Numarası',style: TextStyle(
                        color: widget.isDarkMode ? Colors.white : Colors.black,

                      ),),
                      SizedBox(height: 8),
                      TextField(
                        maxLength: 16,
                        onChanged: (value) {
                          setState(() {
                            cardNumber = value.padRight(16, '*');
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tarih',
                      style: TextStyle(
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                      ),),
                      SizedBox(height: 8),
                      TextField(
                        maxLength: 4,
                        onChanged: (value) {
                          setState(() {
                            cardDate = value.padRight(4, '*');
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CVV',
                      style: TextStyle(
                        color: widget.isDarkMode ? Colors.white : Colors.black,

                      ),),
                      SizedBox(height: 8),
                      TextField(
                        maxLength: 3,
                        onChanged: (value) {
                          setState(() {
                            cardCVV = value.padRight(3, '*');
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Hata mesajı
            Text(
              errorMessage,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 20),
            // Ürün bilgileri
            Text(
              widget.isTurkish! ? 'Kiralanan Ürün: ${widget.urun.name}' : 'Rented Car:  ${widget.urun.name}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            Text(
              widget.isTurkish! ? 'Fiyat: ${widget.urun.price}' : 'Price: ${widget.urun.price}',
              style: TextStyle(fontSize: 18,
                color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            Spacer(),
            // Kiralama butonu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    if (cardNumber.isEmpty || cardDate.isEmpty || cardCVV.isEmpty) {
                      setState(() {
                        errorMessage = widget.isTurkish ? 'Lütfen boşlukları doldurun.' : 'Please fill in the blanks.';
                      });
                    } else {
                      _saveRentedCar();
                      showNotification();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.isTurkish! ? 'Aracı Kirala' : 'Rent Car',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                        ),
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: Icon(Icons.chevron_right, size: 35, color: Colors.blue,))
                      ],
                    ),
                  ),                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bildirim gösteren metod
  Future<void> showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_ID',
      'channel name',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'Ödemeniz Başarılı!',
      'Profilim sayfasından kiraladığınız araçları görebilirsiniz.',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

// Kiralanan aracı kaydeden metod
  Future<void> _saveRentedCar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Kiralanan aracın bilgilerini kullanıcı adına göre kaydet
    String rentedCarKey = '${widget.urun.name}_${DateTime.now().millisecondsSinceEpoch}';
    await prefs.setString('rentedCarName_${widget.username}_$rentedCarKey', widget.urun.name);
    await prefs.setString('rentedCarPrice_${widget.username}_$rentedCarKey', widget.urun.price);
    await prefs.setString('rentedCarCardNumber_${widget.username}_$rentedCarKey', cardNumber);
    await prefs.setString('rentedCarCardDate_${widget.username}_$rentedCarKey', cardDate);
    await prefs.setString('rentedCarCardCVV_${widget.username}_$rentedCarKey', cardCVV);

    // Kiralanan aracın anahtarını kullanıcı adına özel listede sakla
    List<String> rentedCars = prefs.getStringList('rentedCars_${widget.username}') ?? [];
    rentedCars.add(rentedCarKey);
    await prefs.setStringList('rentedCars_${widget.username}', rentedCars);
  }

}
