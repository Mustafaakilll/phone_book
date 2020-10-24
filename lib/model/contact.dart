class Contact {
  int id;
  String name;
  String number;

  Contact({this.id, this.name, this.number});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["name"] = name;
    map["number"] = number;
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  Contact.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    name = map["name"];
    number = map["number"];
  }
}
