import 'package:flutter/material.dart';
import 'package:galt/access/selectionleague_page.dart';
import 'package:galt/access/creationleague_page.dart';

class IntroductionPage extends StatelessWidget {
  final String userEmail;

  IntroductionPage({required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Benvenuto")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Ciao, $userEmail!", style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text("Seleziona un'opzione:"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Naviga a SelectionLeaguePage passando l'email
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SelectionLeaguePage(userEmail: userEmail),
                  ),
                );
              },
              child: Text("Entra in una lega esistente"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Naviga a CreationLeaguePage passando l'email
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CreationLeaguePage(userEmail: userEmail),
                  ),
                );
              },
              child: Text("Crea una nuova lega"),
            ),
          ],
        ),
      ),
    );
  }
}
