import 'package:cg/model/conge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:async/async.dart';
import 'package:rxdart/rxdart.dart' show Observable;

class ListeCongesPage extends StatefulWidget {
  ListeCongesPage({Key key, this.uuid}) : super(key: key);

  final String uuid;

  @override
  ListeCongePageState createState() => ListeCongePageState(uuid);
}

class ListeCongePageState extends State<ListeCongesPage> {
  ListeCongePageState(uuid) {
    print(uuid);
  }

  void _more() {
//    Navigator.of(context).push();
  }

  void _addConge() {

  }

  @override
  Widget build(BuildContext context) {
      return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('conges').snapshots(),
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
  String _getNombreJours(AsyncSnapshot<DocumentSnapshot> snapshot) {
    if (!snapshot.hasData) return "-";
    return snapshot.data.data['nombreJours'].toString();
  }

  Stream<DocumentSnapshot> _getStreamsAsso(Conge conge) {
    return StreamGroup.merge(conge.joursPris.map((doc) => doc.snapshots()));
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    DateFormat df = new DateFormat.yMd();
    final conge = Conge.fromSnapshot(data) ;
    return StreamBuilder<DocumentSnapshot>(
      stream: _getStreamsAsso(conge),
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: ListTile(
              title: Text(df.format(conge.dateDebut) + " - " + df.format(conge.dateFin)), 
              trailing: Text(_getNombreJours(snapshot)),
            ),
          ),
        );
      },
    );
    
  }
}