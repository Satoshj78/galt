import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart'; // Per formattare la data
import '../app.dart';

class CreationLeaguePage extends StatefulWidget {
  final String userEmail;

  CreationLeaguePage({required this.userEmail});

  @override
  _CreationLeaguePageState createState() => _CreationLeaguePageState();
}

class _CreationLeaguePageState extends State<CreationLeaguePage> {
  final TextEditingController _leagueNameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController(); // Controller per la data di nascita
  File? _selectedImage;
  bool _isLoading = false; // Per visualizzare un indicatore di caricamento
  String? _errorMessage;

  @override
  void dispose() {
    _leagueNameController.dispose();
    _surnameController.dispose();
    _nameController.dispose();
    _dobController.dispose(); // Rilascia il controller della data di nascita
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<String?> _uploadImageToFirebase(String leagueName) async {
    if (_selectedImage == null) return null;

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('league_icons/$leagueName.jpg');

      UploadTask uploadTask = storageRef.putFile(_selectedImage!);
      TaskSnapshot snapshot = await uploadTask;

      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Errore durante il caricamento dell\'immagine: $e');
      return null;
    }
  }

  Future<void> _createLeague() async {
    String leagueName = _leagueNameController.text.trim();
    String surname = _surnameController.text.trim();
    String name = _nameController.text.trim();
    String dob = _dobController.text.trim(); // Data di nascita

    if (leagueName.isEmpty || surname.isEmpty || name.isEmpty || dob.isEmpty) {
      setState(() {
        _errorMessage = "Tutti i campi sono obbligatori!";
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Carica l'immagine su Firebase Storage e ottieni l'URL
      String? leagueIconUrl = await _uploadImageToFirebase(leagueName);

      // Crea la lega e aggiungi il creatore come MANGER
      final leagueRef = FirebaseFirestore.instance.collection('leagues').doc(leagueName);
      await leagueRef.set({
        'createdBy': widget.userEmail,
        'createdAt': Timestamp.now(),
        'userCount': 1,
        'leagueIcon': leagueIconUrl,
      });

      // Crea l'ID concatenando cognome, nome e data di nascita
      String staffId = '${surname}_${name}_${dob.replaceAll('/', '-')}';

      // Aggiungi l'utente creatore della lega alla collezione 'staff'
      await leagueRef.collection('Staff').doc(staffId).set({
        'Cognome': surname,
        'Nome': name,
        'Gruppo di Lavoro': 'MANAGER',
        'Stato del Rapporto di Lavoro': 'IN ESSERE',
        'email': widget.userEmail,
        'Data di Nascita': dob, // Salva anche la data di nascita

      });

      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: {
          'leagueName': leagueName,
          'userEmail': widget.userEmail,
        },
      );

    } catch (e) {
      print('Errore durante la creazione della lega: $e');
      setState(() {
        _errorMessage = "Si è verificato un errore durante la creazione della lega.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Crea una nuova lega")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(
                "CREA UNA NUOVA LEGA",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              TextField(
                controller: _leagueNameController,
                decoration: InputDecoration(
                  labelText: 'Nome della lega',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.file(_selectedImage!, fit: BoxFit.cover),
                  )
                      : Center(
                    child: Text(
                      "Tocca qui per caricare l'icona della lega",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _surnameController,
                decoration: InputDecoration(
                  labelText: 'Cognome',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              // Campo per inserire la data di nascita
              TextField(
                controller: _dobController,
                decoration: InputDecoration(
                  labelText: 'Data di nascita (dd/mm/yyyy)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
              ),
              SizedBox(height: 20),
              if (_isLoading)
                CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _createLeague,
                  child: Text("Crea Lega"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
