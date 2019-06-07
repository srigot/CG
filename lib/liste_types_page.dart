import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'model/type_conge.dart';
import 'form_types_page.dart';
import 'package:intl/intl.dart';
import 'auth.dart';

class ListTypesPages extends StatefulWidget {
  ListTypesPages({Key key, this.uuid}) : super(key: key);

  final String uuid;

  @override
  _MyHomePageState createState() => _MyHomePageState(uuid);
}

class _MyHomePageState extends State<ListTypesPages> {
  _MyHomePageState(uuid) {
    print(uuid);
  }

  _editTypeConge(TypeConge typeConge) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => FormTypesPages(typeConge: typeConge)
      )
    );
  }

  _addTypeConge() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => FormTypesPages()
      )
    );
  }

  void _more() {
    AuthService().signIn().then((user) {
      print(user.displayName);
    });
//    Navigator.of(context).push();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context) ;
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('types').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
    
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  String _calculerNombreJours(AsyncSnapshot<QuerySnapshot> snapshot) {
    if (!snapshot.hasData) return "-";
    if (snapshot.data.documents.length < 1) return "0" ;
    return snapshot.data.documents
      .map((data) => data['nombreJours'])
      .reduce((valeur, element) => valeur + element)
      .toString() ;
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    DateFormat df = new DateFormat.yMd();
    final typeConges = TypeConge.fromSnapshot(data) ;
    print("ID = " + typeConges.reference.path);
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('assoTypes')
        .where('typeConges', isEqualTo: typeConges.reference).snapshots(),
      builder: (context, snapshot) {
        return Padding(
          key: ValueKey(typeConges.nom),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: ListTile(
              title: Text(typeConges.nom),
              subtitle: Text(df.format(typeConges.dateDebut) + " - " + df.format(typeConges.dateFin)),
              trailing: Text(_calculerNombreJours(snapshot) + " / " + typeConges.nombreJours.toString() + "j"),
              onLongPress: () {
                _editTypeConge(typeConges);
              },
            ),
          ),
        );
      },
    );
  }
}