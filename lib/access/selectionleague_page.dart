import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:galt/pages/home_page.dart'; // Assicurati che questo file contenga la definizione di HomePage

class SelectionLeaguePage extends StatefulWidget {
  final String userEmail;

  SelectionLeaguePage({required this.userEmail});

  @override
  _SelectionLeaguePageState createState() => _SelectionLeaguePageState();
}

class _SelectionLeaguePageState extends State<SelectionLeaguePage> {
  String? _selectedLeague; // Variabile per tenere traccia della lega selezionata
  List<String> _leagues = []; // Lista per memorizzare le leghe disponibili

  @override
  void initState() {
    super.initState();
    _fetchLeagues(); // Recupera le leghe quando la pagina viene caricata
  }

  Future<void> _fetchLeagues() async {
    try {
      // Recupera tutti i documenti della collezione 'leagues'
      QuerySnapshot leagueSnapshot = await FirebaseFirestore.instance
          .collection('leagues')
          .get();

      List<String> leaguesWithEmail = []; // Lista per le leghe con l'email dell'utente

      for (var leagueDoc in leagueSnapshot.docs) {
        // Per ogni lega, recupera la sottocollezione 'Staff'
        QuerySnapshot staffSnapshot = await leagueDoc.reference.collection('Staff').get();

        // Controlla se l'email dell'utente è presente tra gli staff
        for (var staffDoc in staffSnapshot.docs) {
          // Recupera i dati del documento e fa il cast in Map<String, dynamic>
          final staffData = staffDoc.data() as Map<String, dynamic>?;

          // Verifica che i dati non siano nulli e che il campo 'email' esista
          if (staffData != null && staffData.containsKey('email')) {
            if (staffData['email'] == widget.userEmail) {
              leaguesWithEmail.add(leagueDoc.id); // Aggiungi la lega alla lista
              break; // Esci dal ciclo una volta trovata l'email
            }
          }
        }
      }

      setState(() {
        _leagues = leaguesWithEmail; // Aggiungi le leghe alla lista
      });
    } catch (e) {
      // Gestisci eventuali errori durante il recupero delle leghe
      print('Errore nel recupero delle leghe: $e');
    }
  }

  void _selectLeague() {
    if (_selectedLeague != null) {
      // Naviga alla home page della lega passando l'email dell'utente e la lega selezionata
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            leagueName: _selectedLeague!, // Passa il nome della lega selezionata
            userEmail: widget.userEmail,   // Passa l'email dell'utente
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Seleziona una Lega")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _selectedLeague,
              hint: Text('Seleziona una lega'),
              isExpanded: true,
              items: _leagues.map((league) {
                return DropdownMenuItem<String>(
                  value: league,
                  child: Text(league),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLeague = value; // Aggiorna la lega selezionata
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectLeague,
              child: Text('Seleziona Lega'),
            ),
          ],
        ),
      ),
    );
  }
}
