/*..............................................................................
 . Copyright (c)
 .
 . The iterable_extension.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 06/03/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

extension IterableExtension<E> on Iterable<E> {
  int count(bool test(E element)) => this.where(test).length;
}
