import 'package:cg/auth.dart';
import 'package:cg/liste_conges_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'liste_types_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('fr'),
      ],
      title: 'CG',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _handleCurrentScreen(),
    );
  }
}

Widget _handleCurrentScreen() {
  return new StreamBuilder<FirebaseUser>(
    stream: FirebaseAuth.instance.onAuthStateChanged,
    builder: (BuildContext context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return LinearProgressIndicator();
      } else {
        if (snapshot.hasData) {
          return MainPage();
//          return MainPage(uuid: snapshot.data.uid) ;
        }
        return _loginScreen();
      }
    },
  );
}

Widget _loginScreen() {
  return Center(
    child: const RaisedButton(
      onPressed: _login,
      child: Text('Connexion'),
    ),
  );
}

void _login() {
  AuthService().signIn();
}

class MainPage extends StatefulWidget {
  @override
  _MainPageWidgetState createState() => _MainPageWidgetState();
}

class _MainPageWidgetState extends State<MainPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
     _selectedIndex = index; 
    });
  }  
  Widget _getPageSelected() {
    if (_selectedIndex == 1) return ListeCongesPage();
    return ListTypesPages() ;
  }

  _add() {

  }

  FloatingActionButton _getFab() {
    return FloatingActionButton(
        onPressed: _add,
        tooltip: 'Ajouter',
        child: Icon(Icons.add),
      );
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CG - Gestion congés'),
      ),
      body: _getPageSelected(),
      floatingActionButton: _getFab(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Liste congés'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('Types congés'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,),
    );
  }

}