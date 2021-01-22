/*..............................................................................
 . Copyright (c)
 .
 . The save_path.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/22/21 9:51 AM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

class SavePath {
  String directory;
  String fileName;

  SavePath(this.directory, this.fileName);

  String get formatted => '$directory/$fileName';
}
