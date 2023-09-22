import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LobbyPage extends StatefulWidget {
  const LobbyPage({Key? key}) : super(key: key);
  
  @override
  _LobbyPage createState() => _LobbyPage();
}

class _LobbyPage extends State<LobbyPage> {

  Future<void> _disconnectFunction() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user_token','');
      
      Navigator.of(context).pushReplacementNamed('/');
    }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nouvelle Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenue sur la nouvelle page !',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _disconnectFunction,
              child: Text('Appuyez ici'),
            ),
          ],
        ),
      ),
    );
  }
}
