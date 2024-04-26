class Urun {
  final String imageUrl;
  final String name;
  final String price;

  Urun({required this.imageUrl, required this.name, required this.price});

  // JSON'dan Urun nesnesi oluşturan factory metodu
  factory Urun.fromJson(Map<String, dynamic> json) {
    return Urun(
      imageUrl: json['imageUrl'],
      name: json['name'],
      price: json['price'],
    );
  }

  // Urun nesnesini JSON'a dönüştüren metot
  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'name': name,
      'price': price,
    };
  }
}

final List<Urun> urunler = [
  Urun(imageUrl: 'images/arac1.png', name: 'Nissan GTR', price: '1250 dolar'),
  Urun(imageUrl: 'images/arac2.png', name: 'Land Rover Discovery', price: '1350 dolar'),
  Urun(imageUrl: 'images/arac3.png', name: 'Chevrolet Camaro', price: '1400 dolar'),
  Urun(imageUrl: 'images/arac4.png', name: 'Toyota Supra', price: '1100 dolar'),
  Urun(imageUrl: 'images/arac5.png', name: 'Ferrari F40', price: '1450 dolar'),
  Urun(imageUrl: 'images/arac6.png', name: 'Bugatti Bolide', price: '1600 dolar'),

];
