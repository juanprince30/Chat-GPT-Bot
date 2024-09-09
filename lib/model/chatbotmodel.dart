//chaque repository doit etre relier a un model qui va creer une instance
// pour le resultat de la requetes

class Message{
  final String message;
  final String type;

  Message({required this.message, required this.type});
}