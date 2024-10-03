import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../app.dart';
import 'SignIn_page.dart';
import 'introduction_page.dart'; // Importa la nuova pagina di introduzione

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  String _passwordStrength = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registrati")),
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
                prefixIcon: Icon(Icons.email, color: Colors.grey),
              ),
              textInputAction: TextInputAction.next,
              onSubmitted: (_) {
                FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
            ),
            SizedBox(height: 20),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock, color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    setState(() {
                      _passwordStrength = value.isEmpty ? '' : _evaluatePasswordStrength(value);
                    });
                  },
                ),
                Positioned(
                  right: 40,
                  child: _buildPasswordStrengthIndicator(),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: _confirmPasswordController,
              focusNode: _confirmPasswordFocusNode,
              obscureText: !_confirmPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Conferma Password',
                prefixIcon: Icon(Icons.lock, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: Icon(
                    _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    setState(() {
                      _confirmPasswordVisible = !_confirmPasswordVisible;
                    });
                  },
                ),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) {
                _submit();
              },
            ),
            SizedBox(height: 10),
            Text(
              "Oppure REGISTRATI con:",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(FontAwesomeIcons.google, color: Colors.red),
                  onPressed: () {
                    _signInWithGoogle();
                  },
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.facebook, color: Colors.blue),
                  onPressed: () {
                    // Implementa il login con Facebook
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
              child: Text("REGISTRATI"),
              onPressed: () {
                _submit();
              },
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Colors.green[50],
                border: Border.all(color: Colors.green, width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hai già un Account?",
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => SignInPage()),
                      );
                    },
                    child: Text(
                      "ACCEDI",
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

  String _evaluatePasswordStrength(String password) {
    if (password.length < 8) return 'Debole';
    if (!RegExp(r'(?=.*[A-Z])').hasMatch(password) ||
        !RegExp(r'(?=.*[0-9].*[0-9])').hasMatch(password) ||
        !RegExp(r'(?=.*[!@#$%^&*(),.?":{}|<>])').hasMatch(password)) {
      return 'Debole';
    }
    return 'Forte';
  }

  Widget _buildPasswordStrengthIndicator() {
    if (_passwordController.text.isEmpty) {
      return SizedBox.shrink();
    }

    Color borderColor;
    String label;

    switch (_passwordStrength) {
      case 'Debole':
        borderColor = Colors.red;
        label = 'Debole';
        break;
      case 'Forte':
        borderColor = Colors.green;
        label = 'Forte';
        break;
      default:
        borderColor = Colors.grey;
        label = '';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: borderColor, width: 2),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(color: borderColor, fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    try {
      // Effettua il logout prima di accedere con Google
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // L'utente ha annullato il login

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
          'emailVerified': true,
        });

        // Naviga verso la pagina di introduzione
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => IntroductionPage(userEmail: userCredential.user?.email ?? ''),
          ),
        );
      }
    } catch (error) {
      _showErrorDialog(context, error.toString());
    }
  }

  Future<void> _submit() async {
    if (_emailController.text.isEmpty) {
      _showErrorDialog(context, "Per favore, inserisci un'email.");
      return;
    }

    if (_passwordController.text.isEmpty) {
      _showErrorDialog(context, "Per favore, inserisci una password.");
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorDialog(context, "Le password non corrispondono.");
      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'email': userCredential.user?.email,
        'createdAt': Timestamp.now(),
        'emailVerified': false,
      });

      // Naviga verso la pagina di introduzione
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => IntroductionPage(userEmail: _emailController.text),
        ),
      );
    } on FirebaseAuthException catch (error) {
      _showErrorDialog(context, error.message ?? "Si è verificato un errore.");
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Errore"),
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
