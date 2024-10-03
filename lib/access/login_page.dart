import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Assicurati che Firebase sia configurato correttamente
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'SignIn_page.dart';
import 'SignUp_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Login Page'), // La scritta "Login Page" nell'AppBar
        centerTitle: true,
      ),
      body: SingleChildScrollView( // Permette lo scrolling verticale in caso di overflow
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 0), // Spazio per distanziare la scritta dall'alto

              // Scritta "GALT" nel corpo della pagina
              Text(
                'GALT',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.green, // Colore verde per la scritta
                ),
              ),

              SizedBox(height: 0), // Spazio tra il titolo e il logo

              // Logo dell'app in alto
              Image.asset(
                'assets/images/three-trucks-grassy-sphere.jpg', // Assicurati che il percorso del logo sia corretto
                height: 250, // Imposta la dimensione desiderata
              ),

              SizedBox(height: 0),

              // Messaggio nel container verde chiaro
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.green[100], // Sfondo verde chiaro
                  borderRadius: BorderRadius.circular(15), // Raggio di bordo
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // Posizione della ombra
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Allinea il contenuto a sinistra
                  children: [
                    Text(
                      'Per motivi di sicurezza per poter accedere ad una lega esistente o crearne una nuova dovrai prima autentificarti per dimostrare la tua identità.\n\nPer procedere Registrati o Accedi se possiedi già un account.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.left, // Allineamento a sinistra
                    ),

                    SizedBox(height: 20), // Spazio tra il messaggio e i pulsanti

                    // Bottone per il Login
                    ElevatedButton.icon(
                      icon: FaIcon(FontAwesomeIcons.signInAlt, color: Colors.white),
                      label: Text('Accedi'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Riduzione delle dimensioni
                        textStyle: TextStyle(fontSize: 16), // Font più piccolo
                      ),
                    ),

                    SizedBox(height: 15), // Spazio tra i due pulsanti

                    // Bottone per la Registrazione
                    ElevatedButton.icon(
                      icon: FaIcon(FontAwesomeIcons.userPlus, color: Colors.white),
                      label: Text('Registrati'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Riduzione delle dimensioni
                        textStyle: TextStyle(fontSize: 16), // Font più piccolo
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30), // Spazio finale per il layout
            ],
          ),
        ),
      ),
    );
  }
}
