import 'package:flutter/material.dart';
import 'dart:io';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'SSDTP Client';
    return MaterialApp(title: title, home: MyHomePage(title: title));
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, @required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controller_data = TextEditingController();
  TextEditingController _controller_ip = TextEditingController();
  TextEditingController _controller_port = TextEditingController();
  String _responseData = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              child: TextFormField(
                controller: _controller_ip,
                decoration: InputDecoration(labelText: 'Enter ip'),
              ),
            ),
            Form(
              child: TextFormField(
                controller: _controller_port,
                decoration: InputDecoration(labelText: 'Enter port'),
              ),
            ),
            Form(
              child: TextFormField(
                controller: _controller_data,
                decoration: InputDecoration(labelText: 'Enter data'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Text(_responseData),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendRequest,
        tooltip: 'Send data',
        child: Icon(Icons.send),
      ),
    );
  }

  void _updateData(newData) {
    setState(() {
      _responseData = newData;
    });
  }

  void _sendRequest() {
    request(_controller_ip.text, int.parse(_controller_port.text),
        _controller_data.text);
  }

  void request(ip, port, String data) {
    Socket.connect(ip, port).then((Socket socket) {
      socket.write(data);
      socket.listen((charCodes) {
        _updateData(new String.fromCharCodes(charCodes));
      }, onError: (error, StackTrace trace) {
        _updateData("ERROR: " + error);
        socket.close();
      }, onDone: () {
        socket.close();
      }, cancelOnError: true);
    }).catchError((error) {
      _updateData("ERROR: " + error);
    });
  }
}
