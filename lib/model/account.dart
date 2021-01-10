/*..............................................................................
 . Copyright (c)
 .
 . The account.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/10/21 5:22 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

class Account {
  String name;
  String email;
  String password;

  Account(this.email, this.password, [this.name]);

  Account.fromJSON(Map<String, dynamic> data) {
    this.email = data['email'];
    this.password = data['password'];

    if (data.containsKey('name')) this.name = data['name'];
  }

  bool matches(String email, String password) {
    return this.email.toLowerCase() == email.toLowerCase() && this.password == password;
  }
}
