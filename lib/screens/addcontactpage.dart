import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phone_book_deneme/database/dbHelper.dart';
import 'package:phone_book_deneme/model/contact.dart';

class AddContactPage extends StatelessWidget {
  final Contact contact;

  const AddContactPage({Key key, @required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contact.id == null ? "New Contact" : contact.name),
      ),
      body: SingleChildScrollView(
          child: ContactForm(contact: contact, child: AddContactForm())),
    );
  }
}

class ContactForm extends InheritedWidget {
  final Contact contact;

  ContactForm({Key key, Widget child, @required this.contact})
      : super(key: key, child: child);

  static ContactForm of(BuildContext context) {
    // ignore: deprecated_member_use
    return context.inheritFromWidgetOfExactType(ContactForm);
  }

  @override
  bool updateShouldNotify(ContactForm oldWidget) {
    return contact.id != oldWidget.contact.id;
  }
}

class AddContactForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddContactFormState();
  }
}

class AddContactFormState extends State {
  final _formKey = GlobalKey<FormState>();
  File _file;
  DbHelper _dbHelper;

  @override
  void initState() {
    _dbHelper = DbHelper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Contact contact = ContactForm.of(context).contact;

    return Column(
      children: [
        Image.asset(
          _file == null ? "assets/img/avatar.jpg" : _file.path,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 250,
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              buildnameField(contact),
              buildnumberField(contact),
              buildSubmitButton(contact)
            ],
          ),
        ),
      ],
    );
  }

  addToList(contact) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (contact.id == null) {
        await _dbHelper.insertContact(contact);
      } else {
        await _dbHelper.updateContact(contact);
      }
      var snackBar = Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(milliseconds: 300),
        content: Text("${contact.name} was saved."),
      ));

      snackBar.closed.then((value) => Navigator.pop(context));
    }
  }

  buildnameField(contact) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: TextFormField(
        onSaved: (value) => contact.name = value,
        initialValue: contact.name,
        decoration: InputDecoration(hintText: "Contact Name"),
        // ignore: missing_return
        validator: (value) {
          if (value.isEmpty) {
            return "This part can not be empty";
          }
        },
      ),
    );
  }

  buildnumberField(contact) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: TextFormField(
        onSaved: (value) => contact.number = value,
        initialValue: contact.number,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(hintText: "Phone Number"),
        // ignore: missing_return
        validator: (value) {
          if (value.isEmpty) {
            return "This part can not be empty";
          }
        },
      ),
    );
  }

  buildSubmitButton(contact) {
    return RaisedButton(
        child: Text("Submit"),
        color: Colors.lightBlueAccent,
        textColor: Colors.black,
        onPressed: () async {
          addToList(contact);
        });
  }
}
