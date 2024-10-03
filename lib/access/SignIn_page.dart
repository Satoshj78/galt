import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galt/access/creationleague_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SignUp_page.dart';
import 'package:galt/pages/home_page.dart';
import 'introduction_page.dart'; // Importa la tua IntroductionPage

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool _obscurePassword = true;
  bool _rememberEmail = false;

  @override
  void initState() {
    super.initState();
    _loadEmail();
    _loadRememberEmail();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    if (savedEmail != null) {
      _emailController.text = savedEmail;
    }
  }

  Future<void> _loadRememberEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberEmail = prefs.getBool('rememberEmail') ?? false;
    });
  }

  Future<void> _saveEmail() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberEmail) {
      prefs.setString('email', _emailController.text);
    } else {
      prefs.remove('email');
    }
  }

  Future<void> _saveRememberEmail() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberEmail', _rememberEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Accedi")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'GALT',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.green,
                fontSize: 60,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 0),
            Image.asset('assets/images/three-trucks-grassy-sphere.jpg', height: 220),
            SizedBox(height: 0),
            TextField(
              controller: _emailController,
              focusNode: _emailFocusNode,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.mail, color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                labelStyle: TextStyle(color: Colors.green),
                hintStyle: TextStyle(color: Colors.green),
              ),
              cursorColor: Colors.green,
              textInputAction: TextInputAction.next,
              onSubmitted: (_) {
                FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                labelStyle: TextStyle(color: Colors.green),
                hintStyle: TextStyle(color: Colors.green),
              ),
              cursorColor: Colors.green,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) {
                _signIn(context);
              },
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  value: _rememberEmail,
                  onChanged: (value) {
                    setState(() {
                      _rememberEmail = value!;
                    });
                  },
                ),
                Text("Ricorda Email"),
              ],
            ),
            SizedBox(height: 0),
            Text(
              "Oppure ACCEDI con:",
              style: TextStyle(color: Colors.grey), // Imposta il testo in grigio
            ),
            SizedBox(height: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(FontAwesomeIcons.google, color: Colors.red),
                  onPressed: () {
                    _signInWithGoogle(); // Implementa il login con Google
                  },
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.facebook, color: Colors.blue),
                  onPressed: () {
                    // _signInWithFacebook(); // Puoi commentare o implementare questa funzione se desideri usarla
                  },
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.instagram, color: Colors.pink),
                  onPressed: () {
                    // Implementa il login con Instagram
                  },
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.twitter, color: Colors.blue),
                  onPressed: () {
                    // Implementa il login con Twitter
                  },
                ),
              ],
            ),
            SizedBox(height: 0),
            ElevatedButton(
              child: Text("ACCEDI"),
              onPressed: () {
                _signIn(context);
              },
            ),
            SizedBox(height: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 17.0),
                  child: Text(
                    "Non ricordi la Password?",
                    style: TextStyle(color: Colors.grey), // Imposta il testo in grigio
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _resetPassword();
                  },
                  child: Text(
                    "CLICCA QUI",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 0),
            Container(
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.green),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Non hai un Account?",
                    style: TextStyle(color: Colors.grey), // Imposta il testo in grigio
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    child: Text(
                      "REGISTRATI",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signIn(BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      User? user = userCredential.user;

      if (user != null && !user.emailVerified) {
        await _auth.signOut();
        _showErrorDialog(context, "Devi verificare la tua email prima di accedere.");
        return;
      }

      await _saveEmail();
      await _saveRememberEmail();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => IntroductionPage(userEmail: user?.email ?? ''),
        ),
      );
    } on FirebaseAuthException catch (e) {
      print(e.message);
      _showErrorDialog(context, "Email o password non validi.");
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      // Logout dall'account Google prima di accedere
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // L'utente ha annullato il login
        return;
      }

      final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        final UserCredential userCredential = await _auth.signInWithCredential(
          GoogleAuthProvider.credential(
            accessToken: googleAuth!.accessToken,
            idToken: googleAuth.idToken,
          ),
        );

        // Aggiungi l'utente a Firestore
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
          'email': userCredential.user?.email,
          'createdAt': Timestamp.now(),
          'emailVerified': false,
        });

        // Naviga all'interfaccia principale o alla pagina successiva
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => IntroductionPage(userEmail: userCredential.user?.email ?? '')),
        ); // Sostituisci con la tua HomePage
      }
    } catch (error) {
      _showErrorDialog(context, error.toString());
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text;
    if (email.isNotEmpty) {
      try {
        await _auth.sendPasswordResetEmail(email: email);
        _showDialog(context, "Email di reimpostazione della password inviata a $email.");
      } catch (e) {
        _showErrorDialog(context, "Errore nell'invio dell'email di reimpostazione della password.");
      }
    } else {
      _showErrorDialog(context, "Inserisci un'email per reimpostare la password.");
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("ATTENZIONE"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Informazione"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}
