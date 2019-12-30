import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scb_pwd_mgr/service.dart';
import 'package:scb_pwd_mgr/storage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SCB Password Manager',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('SCB Password Manager'),
        ),
        body: MyHomePage(
          storage: Storage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Storage storage;

  MyHomePage({Key key, this.storage}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String pwd = '';

  @override
  void initState() {
    super.initState();

    widget.storage.readPwd().then((persistPwd) {
      if (persistPwd == '') {
        return onRegenerate();
      }

      setState(() {
        pwd = persistPwd;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 150),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: GestureDetector(
                onTap: onCopy,
                child: Tooltip(
                  message: 'Tap to copy',
                  child: Text(
                    pwd,
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
            ),
            RaisedButton(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              child: Text(
                'Generate',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              color: Colors.green,
              onPressed: onRegenerate,
            ),
          ],
        ),
      ),
    );
  }

  onRegenerate() {
    setState(() {
      final newPwd = generate(storage: widget.storage);
      pwd = newPwd;
    });
  }

  void onCopy() {
    Clipboard.setData(ClipboardData(text: pwd));

    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        "Password has been copied!",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
    ));
  }
}
