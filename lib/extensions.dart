/*..............................................................................
 . Copyright (c)
 .
 . The extensions.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 07/02/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

extension Count<E> on Iterable<E> {
  int count(bool test(E element)) => this.where(test).length;
}

extension EuropeanFormat on DateTime {
  String toEuropeanFormat() {
    var day = '${this.day < 10 ? '0' : ''}${this.day}';
    var month = '${this.month < 10 ? '0' : ''}${this.month}';

    var hour = '${this.hour < 10 ? '0' : ''}${this.hour}';
    var min = '${this.minute < 10 ? '0' : ''}${this.minute}';
    var sec = '${this.second < 10 ? '0' : ''}${this.second}';

    return '{$day/$month/$year $hour:$min:$sec}';
  }
}

extension MapExtension<A, B> on Map<A, B> {
  B get(A key, {B orDefault}) {
    return this.containsKey(key) ? this[key] : orDefault;
  }

  List<dynamic> reduce(dynamic mapper(A key, B value)) {
    return this.keys.map((key) => mapper(key, this[key])).toList();
  }
}

extension ListExtension<T> on List<T> {
  /// Adds a new item only if not null and not already contained
  List<T> addNew(T value) {
    if (value != null && !this.contains(value)) {
      this.add(value);
    }
    return this;
  }

  Future<List> addIfAsync(T value, Future<bool> test(T value)) async {
    if (await test(value)) add(value);
    return this;
  }

  Future<List<dynamic>> mapAsync(Future<dynamic> mapper(T value)) async {
    List<T> result = [];
    await Future.forEach(this, (item) async => result.add(await mapper(item)));
    return result;
  }

  Future<List<T>> whereAsync(Future<bool> test(T item)) async {
    List<T> result = [];
    forEach((item) => result.addIfAsync(item, test));
    return result;
  }
}
