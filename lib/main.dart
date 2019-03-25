import 'package:flutter/material.dart';
import 'login.dart';
import 'contact.dart';
import 'constants.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
      analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatter',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      navigatorObservers: <NavigatorObserver>[observer],
      home: MyHomePage(title: 'Chatter')
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String name = '';
  bool needRefresh = false;

  @override
  void initState() {
    _initLogin();
    super.initState();
  }

  _initLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt(PREF_KEY_USER_ID);
    print("user id: $userId");
    if (userId == null || userId == 0) {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser
          .authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print("google id token: ${googleAuth.idToken}");

      final FirebaseUser user = await _auth.signInWithCredential(credential);
      print("signed in ${user.displayName}, id: ${googleUser.id}");
      final idToken = await user.getIdToken();
      print("id token: $idToken");
    }
  }

  _refresh() async {
    // TODO load msg
    needRefresh = false;
    setState(() {
      name = 'Need refresh';
    });
  }

  _startChat() async {
      var contacts = <Contact>[
        Contact('Yang'),
        Contact('Zhang'),
        Contact('Huang'),
        Contact('Liu'),
        Contact('Zhao'),
        Contact('Tom')
      ]..sort();
      final result = await Navigator.push<Contact>(context, MaterialPageRoute(
          builder: (context) => ContactPage(contacts: contacts)));
      setState(() {
        if (result != null) {
          name = result.name;
        }
      });
  }

  _getWelcomeText() {
    if (name.isEmpty) {
      return Text('Welcome!');
    } else {
      return Text('Welcome $name!');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (needRefresh) {
      _refresh();
    }
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: _getWelcomeText(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startChat,
        tooltip: 'Start chat',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void deactivate() {
    super.deactivate();
    needRefresh = true;
  }
}
