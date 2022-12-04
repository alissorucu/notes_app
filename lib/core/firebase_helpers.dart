import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:note_app/core/import_barrel.dart';
import 'package:note_app/core/shared_manager.dart';
import 'package:note_app/main.dart';
import 'package:note_app/views/auth/login_view.dart';
import 'package:note_app/views/notes/notes_view.dart';

final fbhelper = FirebaseHelpers._();

class FirebaseHelpers {
  FirebaseHelpers._();

  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  User? get user => auth.currentUser;
  String? get uid => user?.uid;

  Future<void> initalize() async {
    await Firebase.initializeApp();
    await auth.signOut();
  }

  bool onInit = true;
  startListeningAuthStateChanges() {
    auth.authStateChanges().listen((event) {
      if (onInit) {
        onInit = false;
        return;
      }
      if (event != null) {
        print('User is signed in');
        nextScreenCloseOthersAnimated(navigatorKey.currentContext!,
            const NotesView(), "notes", RouteFrom.TOP);
        SharedManager.instance.saveEmailEncrypted(event.email!);
      } else {
        print('User is signed out');
        SharedManager.instance.clearLastLogin();
        nextScreenCloseOthersAnimated(navigatorKey.currentContext!,
            const LoginView(), "login", RouteFrom.TOP);
      }
    });
  }

  DocRef get userReference => firestore.collection('users').doc(uid);
  CollRef get notesReference => firestore.collection('notes');

  Future<String> uploadImage(File imageFile) async {
    File? compressed = await FlutterImageCompress.compressAndGetFile(
        imageFile.path,
        "${imageFile.path}_compressed${imageFile.path.split(".").last}",
        quality: 50);
    final storageReference = FirebaseStorage.instance
        .ref()
        .child('note_images/${user!.uid}-${DateTime.now().toString()}');
    final uploadTask = storageReference.putFile(compressed ?? imageFile);

    await uploadTask.whenComplete(() async {});
    return await storageReference.getDownloadURL();
  }
}

typedef CollRef = CollectionReference<Map<String, dynamic>>;
typedef DocRef = DocumentReference<Map<String, dynamic>>;
