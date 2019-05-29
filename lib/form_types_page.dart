import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class FormTypesPages extends StatefulWidget {
  FormTypesPages({Key key, this.title}) : super(key: key);

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

class _MyHomePageState extends State<FormTypesPages> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = new TextEditingController();

  Future _selectDate(String initalDateString) async {
    DateTime now = new DateTime.now();
    DateTime initialDate = convertToDate(initalDateString) ?? now;
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2030)
    );
    if (picked != null) setState(() => _controller.text = new DateFormat.yMd().format(picked));
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
                  onPressed: () => _selectDate(_controller.text),
                ),
              ),
              controller: _controller,
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
                    Navigator.pop(context);
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