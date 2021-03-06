/*..............................................................................
 . Copyright (c)
 .
 . The document_reference_extension.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 06/03/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photo_store/utils/extensions.dart';

extension DocumentReferenceExtension on DocumentReference {
  Future<bool> get exists async => (await this.get()).exists;

  Future<bool> get notExists async => !await this.exists;

  Future createEmpty() async => await this.set({});

  Future<dynamic> getData([String field, dynamic orDefault]) async => (await getMap()).get(field, orDefault: orDefault);

  Future<Map<String, dynamic>> getMap() async => (await this.get()).data();
}
