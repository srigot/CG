import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _fAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<FirebaseUser> signIn() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn() ;
    GoogleSignInAuthentication authentication = await googleSignInAccount.authentication ;
  
    FirebaseUser user = await _fAuth.signInWithGoogle(
      idToken: authentication.idToken,
      accessToken: authentication.accessToken
    ) ;
    return user ;
  }

  void signOut() {
    _googleSignIn.signOut();
  }
}