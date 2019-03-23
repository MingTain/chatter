import 'package:flutter/material.dart';
import 'contact.dart';

class ChatPage extends StatefulWidget {

  final Contact contact;

  ChatPage({Key key, @required this.contact}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChatPageState();
}

class Message {
  final Contact contact;
  final String data;
  final MessageType type;

  Message(this.contact, this.data, this.type);
}

enum MessageType {
  text,
  image,
  video
}

class _ChatPageState extends State<ChatPage> {

  List<Message> messages = [
    Message(Contact('Yang'), 'Hello!', MessageType.text),
    Message(Contact('Liu'), 'I\'m coming!  hjshadhsakhdakhdashdhajsd  sadhasjdhasda     gfyytfty sada', MessageType.text),
    Message(Contact('Zhao'), 'OH, is good!', MessageType.text)
  ];

  final TextEditingController _controller = TextEditingController();



  _send() async {
    setState(() {
      messages.insert(0, Message(Contact('Yang'), _controller.text, MessageType.text));
      _controller.clear();
    });
  }

  VoidCallback _getSendAction() {
    if (_controller.text.isEmpty) {
      return null;
    } else {
      return _send();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact.name),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              reverse: true,
              itemBuilder:
                  (_, index) => MessageListItem(message: messages[index]),
              itemCount: messages.length,
            ),
          ),
          Divider(height: 8,),
          TextField(
            controller: _controller,
            maxLines: null,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.send,
            onEditingComplete: _getSendAction,
            autofocus: false,
            decoration: InputDecoration(
              hintText: 'Type something',
              prefix: Padding(padding: EdgeInsets.only(left: 8)),
              suffixIcon: IconButton(
                onPressed: _getSendAction,
                icon: Icon(IconData(0xe163, fontFamily: 'MaterialIcons', matchTextDirection: true)),
              )
            ),
          ),
        ],
      ),
    );
  }
}

class MessageListItem extends StatelessWidget {

  final Message message;


  MessageListItem({Key key, @required this.message}):
        super(key: ObjectKey(message));

  Widget _buildMessageItemSend(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    message.contact.name,
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
                Text(
                  message.data,
                  style: TextStyle(fontSize: 16.0),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: CircleAvatar(
                radius: 22.0,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  message.contact.name[0],
                )
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMessageItemReceived(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
                radius: 22.0,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  message.contact.name[0],
                )
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    message.contact.name,
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
                Text(
                  message.data,
                  style: TextStyle(fontSize: 16.0),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (message.contact.name == 'Yang') {
      return _buildMessageItemSend(context);
    } else {
      return _buildMessageItemReceived(context);
    }
  }
}