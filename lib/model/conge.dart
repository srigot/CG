import 'package:cloud_firestore/cloud_firestore.dart';

class Conge {
  final DateTime dateDebut;
  final DateTime dateFin;
  List<DocumentReference> joursPris;
  final DocumentReference reference ;

  Conge.fromMap(Map<String, dynamic> map, {this.reference}) :
    dateDebut = map['dateDebut'],
    dateFin = map['dateFin'] {
      List<dynamic> liste = map['joursPris'] ;
      List<DocumentReference> listeJoursPris = liste.cast<DocumentReference>();
      joursPris = listeJoursPris ;
    }

  Conge.fromSnapshot(DocumentSnapshot snapshot)
    : this.fromMap(snapshot.data, reference: snapshot.reference) ;
}

class AssoTypeConges {
  String typeConges;
  int nombreJours;
}