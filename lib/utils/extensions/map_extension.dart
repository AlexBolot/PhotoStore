/*..............................................................................
 . Copyright (c)
 .
 . The map_extension.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 06/03/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

extension MapExtension<A, B> on Map<A, B> {
  /// Returns [orDefault] if the Map doesn't contain [key] or if the value is null
  B get(A key, {B orDefault}) {
    return this.containsKey(key) ? this[key] ?? orDefault : orDefault;
  }

  B add(A key, B value) => this.putIfAbsent(key, () => value);
}
