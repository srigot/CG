import 'package:flutter/material.dart';
import 'model/type_conge.dart';
import 'package:intl/intl.dart';

final dummyList = [
  {"nom":"Congés payés", "dateDebut": DateTime.now(), "dateFin": DateTime.now(), "nombreJours": 25},
  {"nom":"Jours de repos", "dateDebut": DateTime.now(), "dateFin": DateTime.now(), "nombreJours": 10},
  {"nom":"Congés ancienneté", "dateDebut": DateTime.now(), "dateFin": DateTime.now(), "nombreJours": 2},
];

class ListTypesPages extends StatefulWidget {
  ListTypesPages({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ListTypesPages> {
  _addTypeConge() {

  }

  void _more() {
//    Navigator.of(context).push();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CG - Gestion congés'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _more),
        ],
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTypeConge,
        tooltip: 'Ajouter',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildBody(BuildContext context) {
    return _buildList(context, dummyList);
  }

  Widget _buildList(BuildContext context, List<Map> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, Map data) {
    DateFormat df = new DateFormat().add_yMd();
    final typeConges = TypeConge.fromMap(data) ;
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
          trailing: Text(typeConges.nombreJours.toString() + " / " + typeConges.nombreJours.toString() + "j"),
        ),
      ),
    );
  }
}