import 'package:flutter/material.dart';
import 'package:arabakiralama/urunler.dart';

import 'CarDetail.dart';

class SearchPage extends StatefulWidget {
  final String username;
  final bool isDarkMode;
  final bool isTurkish;

  const SearchPage({Key? key, required this.username, required this.isDarkMode, required this.isTurkish}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late List<Urun> filteredUrunler;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    filteredUrunler = urunler;
    super.initState();
  }
  void _onCarTapped(Urun urun) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CarDetail(urun: urun, username: widget.username, isDarkMode: widget.isDarkMode, isTurkish: widget.isTurkish,)),
    );
  }

  void filterUrunler(String query) {
    setState(() {
      filteredUrunler = urunler.where((urun) {
        final nameLower = urun.name.toLowerCase();
        final queryLower = query.toLowerCase();
        return nameLower.contains(queryLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.grey[700] : Colors.grey[300],
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
                        widget.isTurkish ? 'Arama Yapın' : 'Search',
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
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: filterUrunler,
              decoration: InputDecoration(
                hintText: widget.isTurkish ? 'Arama Yapın...' : 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(widget.isTurkish ? 'Lütfen aramak istediğini arabayı yukarı yazın.' : 'Please type the car you want to search for above.',
            style: TextStyle(
              fontSize: 17,
              color: widget.isDarkMode ? Colors.white : Colors.black,

            ),),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUrunler.length,
              itemBuilder: (context, index) {
                final urun = filteredUrunler[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: GestureDetector(
                    onTap: () => _onCarTapped(urun),
                    child: Card(
                      child: ListTile(
                        leading: Image.asset(urun.imageUrl),
                        title: Text(urun.name),
                        subtitle: Text(urun.price),
                      ),
                    ),
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
