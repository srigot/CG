class TypeConge {
  final String nom ;
  final DateTime dateDebut ;
  final DateTime dateFin ;
  final int nombreJours ;

  TypeConge.fromMap(Map<String, dynamic> map) :
    nom = map['nom'],
    dateDebut = map['dateDebut'],
    dateFin = map['dateFin'],
    nombreJours = map['nombreJours'];
}