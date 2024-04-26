import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginPage.dart';

// BLoC Events
abstract class AuthEvent {}

class SignupEvent extends AuthEvent {
  final String name;
  final String mail;
  final String username;
  final String password;
  final String phoneNumber;

  SignupEvent({
    required this.name,
    required this.mail,
    required this.username,
    required this.password,
    required this.phoneNumber,
  });
}

// BLoC State
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthenticatedState extends AuthState {
  final String username;

  AuthenticatedState({required this.username});
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is SignupEvent) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Kullanıcı adını anahtar olarak kullanarak kullanıcı bilgilerini sakla
      await prefs.setString('name_${event.username}', event.name);
      await prefs.setString('mail_${event.username}', event.mail);
      await prefs.setString('password_${event.username}', event.password);
      await prefs.setString('phoneNumber_${event.username}', event.phoneNumber);

      yield AuthenticatedState(username: event.username);
    }
  }
}

// Signup Page
class SignupPage extends StatefulWidget {
  final bool isDarkMode;
  final bool isTurkish;

  const SignupPage({Key? key, required this.isDarkMode, required this.isTurkish}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.grey[700] : Colors.grey[300],

      body: BlocProvider(
        create: (context) => AuthBloc(),
        child: SingleChildScrollView(
          child: SignupForm(isDarkMode: widget.isDarkMode, isTurkish: widget.isTurkish,),
        ),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  final bool isDarkMode;
  final bool isTurkish;

  const SignupForm({Key? key, required this.isDarkMode, required this.isTurkish}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  late TextEditingController _nameController;
  late TextEditingController _mailController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _mailController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _phoneNumberController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatedState) {
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
                SizedBox(height: 50.0), // Fotoğraf ile yazı arasında boşluk
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isTurkish! ? 'Kayıt Ol' : 'Sign Up',
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

          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 6, left: 20, right: 20),
            child: Row(
              children: [
                Text(
                  widget.isTurkish! ? 'İsim' : 'Name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'example123',
                hintStyle: TextStyle(
                  color: Color(0xFFB6A9A9),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 6, left: 20, right: 20),
            child: Row(
              children: [
                Text(
                  widget.isTurkish! ? 'E posta' : 'Email',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: _mailController,
              decoration: InputDecoration(
                hintText: 'example123',
                hintStyle: TextStyle(
                  color: Color(0xFFB6A9A9),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 6, left: 20, right: 20),
            child: Row(
              children: [
                Text(
                  widget.isTurkish! ? 'Kullanıcı Adı' : 'Username',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: 'example123',
                hintStyle: TextStyle(
                  color: Color(0xFFB6A9A9),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 6, left: 20),
            child: Row(
              children: [
                Text(
                  widget.isTurkish! ? 'Parola' : 'Password',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: widget.isDarkMode ? Colors.white : Colors.black,
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
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 6,left: 20),
            child: Row(
              children: [
                Text(
                  widget.isTurkish! ? 'Telefon' : 'Phone' ,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                hintText: '+9011111111',
                hintStyle: TextStyle(
                  color: Color(0xFFB6A9A9),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              widget.isTurkish! ? 'Kaydolarak, Araba Kiralama Uygulamasının Kullanıcı Sözleşmesi ve Gizlilik Politikasını kabul ediyorum.' : 'By signing up, I agree to the Car Rental Apps User Agreement and Privacy Policy',
              style: TextStyle(fontSize: 15,
                color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          SizedBox(height: 20),

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
                  _signUp();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.isTurkish! ? 'Kaydet' : 'Submit',
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
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.isTurkish! ? 'Zaten hesabın var mı? ' : 'Already have an account? ',
                style: TextStyle(fontSize: 17,
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text(
                  widget.isTurkish! ? 'Giriş Yap' : 'Sign in',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 20),

        ],
      ),
    );
  }

  void _signUp() {
    final name = _nameController.text;
    final mail = _mailController.text;
    final username = _usernameController.text;
    final password = _passwordController.text;
    final phoneNumber = _phoneNumberController.text;

    if (name.isEmpty || mail.isEmpty || username.isEmpty || password.isEmpty || phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lütfen tüm alanları doldurun.'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      BlocProvider.of<AuthBloc>(context).add(SignupEvent(
        name: name,
        mail: mail,
        username: username,
        password: password,
        phoneNumber: phoneNumber,
      ));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kayıt Başarılı!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }
}

