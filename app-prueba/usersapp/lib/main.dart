import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'contador.dart';
import 'package:flutter/services.dart';


//MAIN
void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();
  Map data;
  List usersData;

  /*** ----------------------------- ***/
  String _nombre, _usuario, _search;

  // Crea un controlador de texto para recuperar el valor actual
  final myController = TextEditingController();
  final myController2 = TextEditingController();
  final searchController = TextEditingController();

  Future getUsers() async {
    http.Response response =
    await http.get('http://192.168.0.39:8080/api/clientes');
    setState(() {
      usersData = json.decode(response.body);
      print("------JSON: >");
      print(usersData);
    });

    // debugPrint(usersData.toString());
    debugPrint(usersData.length.toString());
  }

  Future<http.Response> postRequest() async {
    print("entrando");
    //tomar los datos tecleados por el usuario
    String user = myController2.text;
    String name = myController.text;

    var url = 'http://192.168.0.39:8080/api/clientes';

    Map data = {'nombre': name, 'usuario': user, 'avatar': 'deloitte'};

    //encode Map to JSON
    var body = json.encode(data);

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Registro guardado",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Operacion fallida",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  void getSearch() async {
    print("entrando");
    //tomar los datos tecleados por el usuario
    String search = searchController.text;
    var url = 'http://192.168.0.39:8080/api/clientes/';

    http.Response response = await http.get(url + search);

    setState(() {
      usersData = [json.decode(response.body)];
    });
    print("${response.statusCode}");
    print("${response.body}");
  }

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _alert();
            },
            child: Icon(Icons.refresh),
            backgroundColor: Colors.redAccent,
          ),
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.supervised_user_circle)),
                Tab(icon: Icon(Icons.create)),
              ],
            ),
            title: Text('Tabs Demo'),
          ),
          body: TabBarView(
            children: [
              _Lista(context),
              _Create(context),
            ],
          ),
        ),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  Widget _Create(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(padding: const EdgeInsets.all(10.0)),
          TextFormField(
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
            // Recupera el texto que el usuario ha digitado utilizando nuestro
            controller: myController,
            decoration: InputDecoration(labelText: 'Nombre'),
            validator: (input) =>
            input.isEmpty ? ' Es obligatorio el Nombre' : null,
            onSaved: (input) => _nombre = input,
          ),
          SizedBox(height: 10),
          Padding(padding: const EdgeInsets.all(10.0)),
          TextFormField(
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
            // Recupera el texto que el usuario ha digitado utilizando nuestro
            controller: myController2,
            decoration: InputDecoration(
              labelText: 'Usuario',
            ),
            validator: (input) =>
            input.isEmpty ? ' Es obligario el usuario' : null,
            onSaved: (input) => _usuario = input,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    //color: Colors.red,
                    onPressed: _submit,
                    child: Text('Registrate'),
                  ))
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget _Lista(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: usersData == null ? 0 : usersData.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // Text("${usersData[index]["_id"]} - "),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${usersData[index]["id"]} - ",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w500),
                          ),
                        ),
                        // CircleAvatar(
                        // backgroundImage:
                        // NetworkImage(usersData[index]['avatar'])),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "${usersData[index]["usuario"]} ${usersData[index]["nombre"]}",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w700),
                          ),
                        ),
                        _Botones("${usersData[index]["id"]}", "${usersData[index]["nombre"]}", "${usersData[index]["usuario"]}"),
                      ],
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }

    @override
    Widget _Botones(id, nombre, usuario) {

    return Row(
      children: <Widget>[
        FloatingActionButton(heroTag: "btn_editar$id", mini: true, child: Icon(Icons.edit), onPressed: () => _editar(id, nombre, usuario),),
        FloatingActionButton(heroTag: "btn_Borrar$id",mini: true, child: Icon(Icons.delete), onPressed: () => _borrar(id),),
      ],
    ); 
    
  }

  @override
  Widget _Form(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Search',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            controller: searchController,
            onSaved: (input) => _search = input,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: RaisedButton(
                  onPressed: _buscar,
                  child: Text('Search'),
                ),
              )),
        ],
      ),
    );
  }

  //vallidacion y evento del button
  void _submit() {
    if (formKey.currentState.validate()) {
      postRequest();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
      getUsers();
    }
  }

  //vallidacion y evento del button
  void _buscar() {
    getSearch();
  }

  // Editar Usuario
  void _editar(id, nombre, usuario) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContadorPage(), settings: RouteSettings(arguments: [id, nombre, usuario])),
    );
  }

  void _borrar(id) async  {
    
    String url = 'http://192.168.0.39:8080/api/clientes/';

    http.Response response = await http.delete(url + id);
    print("${response.statusCode}");
    getUsers();
  }

  void _alert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Buscar ID:"), content: _Form(context));
        });
  }
  
}