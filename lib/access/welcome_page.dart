import 'package:flutter/material.dart';
import 'package:galt/access/SignIn_page.dart';
import 'package:galt/access/login_page.dart';
import 'introduction_page.dart'; // Importa la pagina di introduzione

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Imposta il colore di sfondo su bianco
      body: SingleChildScrollView( // Aggiungi SingleChildScrollView
        child: Center(
          child: Column(
            // Rimuovi il mainAxisAlignment per mantenere la scritta più in alto
            children: [
              SizedBox(height: 100), // Spazio sopra la scritta "Welcome in"
              Text(
                'Welcome in',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'GALT',
                style: TextStyle(
                  fontSize: 68,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 20),
              // Aggiungi il logo
              Image.asset(
                'assets/images/three-trucks-grassy-sphere.jpg',
                height: 350, // Aumenta l'altezza del logo
              ),
              SizedBox(height: 20),
              // Aggiungi il pulsante Prosegui
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInPage()),
                  );
                },
                child: Text(
                  'Prosegui',
                  style: TextStyle(
                    fontSize: 20, // Dimensione del testo
                  ),
                ),
                // Non specificare il padding qui, usa il tema globale
              ),
              SizedBox(height: 50), // Padding sotto il pulsante
            ],
          ),
        ),
      ),
    );
  }
}