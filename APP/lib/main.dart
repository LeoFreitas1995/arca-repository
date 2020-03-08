import 'dart:convert';
import 'package:first_app/ExpansionCard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ARCA',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: LoginPage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String userId;

  HomePage({this.userId});

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  List data;
  List<bool> expanded = List<bool>();
  bool load = false;

  getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(
            "https://heroku-arca.herokuapp.com/arca/mobile/login/${widget.userId}"),
        // "http://192.168.0.103:9011/arca/mobile/login/${widget.userId}"),
        // "http://10.20.30.95:9011/arca/mobile/login/${widget.userId}"),
        headers: {"Accept": "application/json"});

    if (response.body == "False") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginPage()));
    }

    this.setState(() {
      data = json.decode(response.body);
      data.forEach((item) {
        expanded.add(false);
      });
    });

    setState(() {
      load = true;
    });
    return "Success!";
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  List colorsArca = [
    Color(0xFF3EB39E),
    Color(0xFF3E53B3),
    Color(0xFFB33E53),
    Color(0xFFB39E3E)
  ];

  List<Widget> renderGroups(items) {
    List<Widget> r = new List<Widget>();
    for (int i = 0; i < items.length; i++) {
      r.add(ExpansionCard(items[i], colorsArca[i % colorsArca.length]));
    }
    return r;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          backgroundColor: Color(0xFF3E53B3),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text("Seus grupos de carona"),
              Image.asset(
                "assets/images/icon_arca.png",
                width: 40,
                height: 40,
              ),
            ],
          )),
      body: SingleChildScrollView(
          child: load
              ? data.length > 0
                  ? Column(children: renderGroups(data))
                  : Column(
                      children: <Widget>[
                        Center(
                          child: Icon(
                            Icons.mood_bad,
                            size: 60,
                          ),
                        ),
                        Center(
                          child: Text(
                            "Que pena...",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Center(
                          child: Text(
                            "Ainda não há grupos com rotas semelhantes às suas",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
              : Center(
                  heightFactor: 15,
                  child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Color(0xFF3E53B3)),
                  ),
                )),
    );
  }

//NÃO APAGAR
  // List<Widget> renderUsers(List listUsers) {
  //   List<Widget> childs = [];
  //   for (var i = 0; i < listUsers.length; i++) {
  //     childs.add(Column(
  //       children: <Widget>[
  //         Text("Moid: ${listUsers[i]["Moid"]}"),
  //         Text("Licence: ${listUsers[i]["Licence"]}"),
  //         Text("Model: ${listUsers[i]["Model"]}"),
  //       ],
  //     ));
  //   }
  //   return childs;
  // }
}

class LoginPage extends StatelessWidget {
  TextEditingController getUserId = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/logo_arca.png',
              width: 180,
              height: 100,
            ),
            Form(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextFormField(
                      controller: getUserId,
                      decoration: InputDecoration(labelText: "Informe seu id"),
                    ),
                  ),
                  RaisedButton(
                    child: Text("Entrar"),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => HomePage(
                                userId: getUserId.text,
                              )));
                    },
                    textColor: Colors.white,
                    color: Color(0xFF3E53B3),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
