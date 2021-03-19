/*..............................................................................
 . Copyright (c)
 .
 . The string_extension.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 07/03/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

extension StringExtension on String {
  /// Formats a given [string] to used a 'sentence' format :
  ///
  /// UPPER CASE PHRASE -> Upper case phrase
  /// lower case phrase -> Lower case phrase
  /// Mixed CASE phrase -> Mixed case phrase
  ///
  String toFirstUpper() {
    return this[0].toUpperCase() + this.substring(1).toLowerCase();
  }
}
