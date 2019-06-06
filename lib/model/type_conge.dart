import 'package:cloud_firestore/cloud_firestore.dart';

class TypeConge {
  final String nom ;
  final DateTime dateDebut ;
  final DateTime dateFin ;
  final int nombreJours ;
  final DocumentReference reference ;

  TypeConge.fromMap(Map<String, dynamic> map, {this.reference}) :
    nom = map['nom'],
    dateDebut = map['dateDebut'],
    dateFin = map['dateFin'],
    nombreJours = map['nombreJours'];

  TypeConge.fromSnapshot(DocumentSnapshot snapshot)
    : this.fromMap(snapshot.data, reference: snapshot.reference) ;
}