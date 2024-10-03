import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Assicurati che questo import sia presente
import 'app.dart'; // Assicurati di importare il file corretto con la classe GaltApp
import 'access/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inizializza Firebase
  runApp(GaltApp());
}
