import 'package:flutter/material.dart';
import 'package:phone_book_deneme/database/dbHelper.dart';
import 'package:phone_book_deneme/model/contact.dart';
import 'package:phone_book_deneme/screens/addcontactpage.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ContactMenuState();
  }
}

class ContactMenuState extends State {
  DbHelper _dbHelper;
  var photo = Image.asset("assets/img/avatar.jpg");

  @override
  void initState() {
    _dbHelper = DbHelper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Menu"),
        centerTitle: true,
      ),
      body: buildFutureBuilder(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddContactPage(
                        contact: Contact(),
                      )));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  buildFutureBuilder() {
    return FutureBuilder(
        future: _dbHelper.getContact(),
        builder: (BuildContext context, AsyncSnapshot<List<Contact>> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          if (snapshot.data.isEmpty) return Text("Contact List is empty!");
          return buildListView(snapshot);
        });
  }

  buildListView(snapshot) {
    return ListView.builder(
      key: GlobalKey(),
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        Contact contact = snapshot.data[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddContactPage(
                          contact: contact,
                        )));
          },
          child: buildDismissible(contact),
        );
      },
    );
  }

  buildListTile(contact) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: photo.image,
        child: Text(
          contact.name[0].toUpperCase(),
          style:
              TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(contact.name),
      subtitle: Text(contact.number),
      trailing: IconButton(
        icon: Icon(Icons.phone),
        onPressed: () async => _callContact(contact.number),
      ),
    );
  }

  _callContact(String number) async {
    String tel = "tel:$number";
    if (await canLaunch(tel)) {
      await launch(tel);
    }
  }

  buildDismissible(contact) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: Colors.redAccent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      key: UniqueKey(),
      onDismissed: (direction) {
        _dbHelper.removeContact(contact.id);
        setState(() {});
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(contact.name + " has been deleted"),
          action: SnackBarAction(
            label: "Undo",
            onPressed: () async {
              await _dbHelper.insertContact(contact);
              setState(() {});
            },
          ),
        ));
      },
      child: buildListTile(contact),
    );
  }
}
