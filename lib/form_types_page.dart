import 'package:cg/model/type_conge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class FormTypesPages extends StatefulWidget {
  FormTypesPages({Key key, this.typeConge}) : super(key: key);

  final TypeConge typeConge ;

  @override
  _MyHomePageState createState() => _MyHomePageState(typeConge: typeConge);
}

class _MyHomePageState extends State<FormTypesPages> {
  final TypeConge typeConge ;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerLibelle = new TextEditingController();
  final TextEditingController _controllerDateDebut = new TextEditingController();
  final TextEditingController _controllerDateFin = new TextEditingController();
  final TextEditingController _controllerNbJours = new TextEditingController();

  _MyHomePageState({this.typeConge}) {
    if (this.typeConge != null) {
      _controllerLibelle.text = this.typeConge.nom ;
      _controllerDateDebut.text = new DateFormat.yMd().format(typeConge.dateDebut);
      _controllerDateFin.text = new DateFormat.yMd().format(typeConge.dateFin);
      _controllerNbJours.text = this.typeConge.nombreJours.toString();
    }
  }

  Future _selectDate(TextEditingController ctrl) async {
    DateTime now = new DateTime.now();
    DateTime initialDate = convertToDate(ctrl.text) ?? now;
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2030)
    );
    if (picked != null) setState(() => ctrl.text = new DateFormat.yMd().format(picked));
  }

  DateTime convertToDate(String input) {
    try {
      DateTime d = new DateFormat.yMd().parseStrict(input);
      return d ;
    } catch (e) {
      return null ;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un type de congés'),
      ),
      body: _buildBody(context),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _addTypeConge,
//        tooltip: 'Ajouter',
//        child: Icon(Icons.add),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildBody(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Libellé',
              ),
              controller: _controllerLibelle,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Merci de saisir une valeur';
                }
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Date de début',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(_controllerDateDebut),
                ),
              ),
              controller: _controllerDateDebut,
              keyboardType: TextInputType.datetime,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Merci de saisir une valeur';
                }
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Date de fin',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(_controllerDateFin),
                ),
              ),
              controller: _controllerDateFin,
              keyboardType: TextInputType.datetime,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Merci de saisir une valeur';
                }
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nombre de jours',
              ),
              controller: _controllerNbJours,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Merci de saisir une valeur';
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    Map<String, dynamic> newType = {
                        "nom": _controllerLibelle.text,
                        "dateDebut": convertToDate(_controllerDateDebut.text),
                        "dateFin": convertToDate(_controllerDateFin.text),
                        "nombreJours": int.parse(_controllerNbJours.text),
                    } ;
                    var retour ;
                    if (this.typeConge != null) {
                      retour = this.typeConge.reference.updateData(newType);
                    } else {
                      retour = Firestore.instance.collection('types').add(newType) ;
                    }
                    retour.then((ref) {
                      Navigator.pop(context);
                    });
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}