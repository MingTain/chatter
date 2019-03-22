import 'package:flutter/material.dart';
import 'chat.dart';

class ContactPage extends StatefulWidget {
  final List<Contact> contacts;

  ContactPage({Key key, this.contacts}): super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        itemBuilder: (_, index) => ContactListItem(widget.contacts[index]),
        itemCount: widget.contacts.length,
      ),
    );
  }
}

class Contact implements Comparable<Contact> {
  final String name;
  Contact(this.name);

  @override
  int compareTo(Contact other) {
      return this.name.compareTo(other.name);
  }
}

class ContactListItem extends StatelessWidget {

  final Contact contact;

  ContactListItem(this.contact): super(key: ObjectKey(contact));

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => ChatPage(contact: contact)))
      },
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(contact.name[0])
      ),
      title: Text(contact.name),
    );
  }
}