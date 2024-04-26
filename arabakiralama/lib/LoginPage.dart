import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AnaSayfa.dart';
import 'SignupPage.dart';
//import 'HomePage.dart';

// BLoC Events
class LoginEvent extends AuthEvent {
  final String username;
  final String password;

  LoginEvent({required this.username, required this.password});
}

// BLoC State
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthenticatedState extends AuthState {
  final String username;

  AuthenticatedState({required this.username});
}

class UnauthenticatedState extends AuthState {}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is LoginEvent) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final savedPassword = prefs.getString('password_${event.username}');

      if (savedPassword == event.password) {
        yield AuthenticatedState(username: event.username);
      } else {
        yield UnauthenticatedState();
      }
    }
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isDarkMode = false;
  String selectedLanguage = 'English'; // Varsayılan dil İngilizce
  bool isTurkish = false; // Türkçe dil seçeneği kontrolü

  void _onLanguageChanged(String value) {
    setState(() {
      selectedLanguage = value;
      // Seçilen dil Türkçe ise isTurkish true olacak, aksi halde false
      isTurkish = value == 'Turkish';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.grey[700] : Colors.grey[300],
      body: BlocProvider(
        create: (context) => AuthBloc(),
        child: SingleChildScrollView(
          child: LoginForm(
            isDarkMode: _isDarkMode,
            toggleDarkMode: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
            isTurkish: isTurkish, // Türkçe dil seçeneğini iletiliyor
            onLanguageChanged: _onLanguageChanged,
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleDarkMode;
  final bool isTurkish; // Türkçe dil seçeneği
  final ValueChanged<String> onLanguageChanged; // Dil değişikliği bildirimi

  const LoginForm({Key? key, required this.isDarkMode, required this.toggleDarkMode, required this.isTurkish, required this.onLanguageChanged}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatedState) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage(username: state.username, isDarkMode: widget.isDarkMode, isTurkish: widget.isTurkish,)),
          );


        } else if (state is UnauthenticatedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lütfen bilgilerinizi kontrol edin.'),
            ),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                SizedBox(height: 20.0), // Fotoğraf ile yazı arasında boşluk
                Image.asset(
                  'images/car.png', // Fotoğrafın yolunu belirtin
                  height: 280.0, // Fotoğrafın yüksekliği
                  width: 280.0, // Fotoğrafın genişliği
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isTurkish! ? 'Hoşgeldiniz!' : 'Welcome!',
                        style: TextStyle(
                          fontSize: 23.0, fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(widget.isTurkish! ? 'Evden araba kiralamanın yeni deneyimini yaşayın ve seyahat edin.' : "Travel and live the new experience of rent the cars from your home.",
                      style: TextStyle(fontSize: 18),)
                    ],
                  ),
                ),
                SizedBox(height: 20.0), // Yazı ile container arasında boşluk
              ],
            ),
          ),

          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0, left: 20, right: 20),
            child: Row(
              children: [
                Text(
                  widget.isTurkish! ? 'Kullanıcı Adı' : 'Username',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: widget.isDarkMode ? Colors.white : Colors.black, // Metin rengini ayarla
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: widget.isTurkish! ? 'Kullanıcı Adı' : 'username',
                hintStyle: TextStyle(
                  color: Color(0xFFB6A9A9),
                ),
              ),
            ),
          ),

          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0, left: 20, right: 20),
            child: Row(
              children: [
                Text(
                  widget.isTurkish! ? 'Parola' : 'Password',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: widget.isDarkMode ? Colors.white : Colors.black, // Metin rengini ayarla
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: '**********',
                hintStyle: TextStyle(
                  color: Color(0xFFB6A9A9),
                ),
              ),
            ),
          ),
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                  final username = _usernameController.text;
                  final password = _passwordController.text;
                  BlocProvider.of<AuthBloc>(context).add(LoginEvent(
                    username: username,
                    password: password,
                  ));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.isTurkish! ? 'Giriş Yap' : 'Sign in',
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
                ),
              ),
            ),
          ),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.isTurkish! ? 'Hesabınız yok mu? ' : 'Dont have an account? ',
                style: TextStyle(
                  fontSize: 17,
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage(isDarkMode: widget.isDarkMode, isTurkish: widget.isTurkish,)),
                  );
                },
                child: Text(
                  widget.isTurkish! ? 'Bedava kayıt olun' : "Sign up for free",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.isTurkish! ? 'Karanlık Mod' : 'Dark Mode',
                style: TextStyle(
                  fontSize: 17,
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(width: 20),
              Switch(
                value: widget.isDarkMode,
                onChanged: (value) {
                  widget.toggleDarkMode();
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.isTurkish! ? 'Dil Seçin' : 'Select Language',
                style: TextStyle(
                  fontSize: 17,
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                ),
              ),

              SizedBox(width: 20),
              DropdownButton<String>(
                value: widget.isTurkish ? 'Turkish' : 'English',
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.black),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? newValue) {
                  widget.onLanguageChanged(newValue ?? '');
                },
                items: <String>['English', 'Turkish']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,style: TextStyle(
                      color: widget.isDarkMode ? Colors.grey : Colors.black,
                    ),),
                  );
                }).toList(),
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
