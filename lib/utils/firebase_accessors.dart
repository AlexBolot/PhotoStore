/*..............................................................................
 . Copyright (c)
 .
 . The firebase_accessors.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 11/02/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:photo_store/services/account_service.dart';
import 'package:photo_store/utils/extensions.dart';

class FirebaseFields {
  static final String lastAccess = 'last_access';
  static final String albums = 'albums';
  static final String lastAlbumIndex = 'last_album_index';
  static final String labels = 'labels';
}

String get _userName => AccountService.currentAccount.name;

Future<DocumentReference> _getFirestoreDocument(String collectionName, String fileName) async {
  var document = FirebaseFirestore.instance.collection(collectionName).doc(fileName);
  if (await document.notExists) await document.createEmpty();
  return document;
}

/// Gets the Storage reference of a file :: [userName/fileName]
Reference getFileReference(String fileName) => FirebaseStorage.instance.ref(_userName).child(fileName);

/// Gets the Firestore document of a file :: [userName/fileName]
Future<DocumentReference> getFileDocument(String fileName) async => _getFirestoreDocument(_userName, fileName);

/// Gets the Firestore document containing the albums metadata
Future<DocumentReference> getAlbumsDocument() async => _getFirestoreDocument('Autre', 'Albums_$_userName');

/// Gets the Firestore document containing the labels metadata
Future<DocumentReference> getLabelsDocument() async => _getFirestoreDocument('Autre', 'Labels_$_userName');
