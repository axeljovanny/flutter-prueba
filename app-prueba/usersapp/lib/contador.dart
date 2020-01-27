import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

import 'main.dart';

class ContadorPage extends StatefulWidget {

  @override
  createState() => _ContadorPageState();
  
}

class _ContadorPageState extends State<ContadorPage> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Modificar Usuario'),
        centerTitle: true,
      ),
      body: Center(
        child:  _Edit(context),
      ),
    );

    
  }

   final formKey = GlobalKey<FormState>();
   final myController = TextEditingController();
   final myController2 = TextEditingController();

  Widget _Edit(BuildContext context) {
    var datos_Usuario = ModalRoute.of(context).settings.arguments as List;
    var nombre = datos_Usuario[1];
    var usuario = datos_Usuario[2];
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
            decoration: InputDecoration(
              hintText: '$nombre',
              labelText: 'Nombre'),
            validator: (input) =>
            input.isEmpty ? ' Es obligatorio el Nombre' : null,
            //onSaved: (input) => _nombre = input,
          ),
          SizedBox(height: 10),
          Padding(padding: const EdgeInsets.all(10.0)),
          TextFormField(
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
            // Recupera el texto que el usuario ha digitado utilizando nuestro
            controller: myController2,
            decoration: InputDecoration(
              hintText: '$usuario',
              labelText: 'Usuario',
            ),
            validator: (input) =>
            input.isEmpty ? ' Es obligario el usuario' : null,
            //onSaved: (input) => _usuario = input,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    //color: Colors.red,
                    onPressed: _submitEditar,
                    child: Text('Actualizar'),
                  ))
            ],
          )
        ],
      ),
    );

  }

  editarUsuario() async {
    //tomar los datos tecleados por el usuario
    var datos_Usuario = ModalRoute.of(context).settings.arguments as List;
    var id = datos_Usuario[0];
    print(id);
    String user = myController2.text;
    String name = myController.text;

    String url = 'http://192.168.0.39:8080/api/clientes';

    Map data = {'id': id, 'nombre': name, 'usuario': user, 'avatar': 'deloitte'};
    print(data);

    //encode Map to JSON
    var body = json.encode(data);
    print(body);

    http.Response response = await http.post(url, headers: {"Content-Type": "application/json"}, body: body + '$id');

    /* var response = await http.put(url,
        headers: {"Content-Type": "application/json"}, body: body); */

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Registro Actualizado",
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

  void _submitEditar() {
    if (formKey.currentState.validate()) {
      editarUsuario();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
      //getUsers();
    }
  }

  /* List usersData;

    void getSearch(id) async {
    print("entrando");
    //tomar los datos tecleados por el usuario
    var url = 'http://10.0.2.2:8080/api/clientes/';

    http.Response response = await http.get(url + id);

      usersData = [json.decode(response.body)];
    
    print("${response.statusCode}");
    print("${response.body}");
  } */


}