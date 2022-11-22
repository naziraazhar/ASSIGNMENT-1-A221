import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Movie App Bar'),
        ),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    height: 150,
                    child: Center(
                      child: Image.asset('assets/images/movie.jpg', scale: 1.5),
                    )),
                Container(child: MovieForm()),
                SizedBox(
                  height: 100, //
                ),
              ]),
        ),
      ),
    );
  }
}

class MovieForm extends StatefulWidget {
  const MovieForm({super.key});

  @override
  State<MovieForm> createState() => _MovieFormState();
}

class _MovieFormState extends State<MovieForm> {
  @override
  TextEditingController _searchController = TextEditingController();
  String search = "";
  String title = "";
  String descG = "";
  String desP = "";

  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
      const Text("Movie App",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      SizedBox(height: 20),
      TextField(
        controller: _searchController,
        decoration: InputDecoration(
            hintText: 'Movie Title',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
        keyboardType: TextInputType.emailAddress,
      ),
      const SizedBox(height: 30),
      ElevatedButton(
          onPressed: () {
            _getMovie(_searchController.text);
          },
          child: const Text("Load",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
      SizedBox(height: 10),
      SizedBox(
        width: 300.0,
        height: 100.0,
        child: Card(
          color: Color.fromARGB(255, 98, 18, 79),
          child: Center(
            child: Text(
              descG,
              style: TextStyle(color: Colors.white),
            ), //Text
          ), //Center
        ), //Card
      ), //SizedBox

      SizedBox(
        width: 300.0,
        height: 100.0,
        child: Card(
          color: Color.fromARGB(255, 67, 8, 56),
          child: Center(
            child: Text(
              desP,
              style: TextStyle(color: Colors.white),
            ), //Text
          ), //Center
        ), //Card
      ), //SizedBox
    ]));
  }

  Future<void> _getMovie(String search) async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Progress"), title: const Text("Searching..."));
    progressDialog.show();
    search = _searchController.text;
    var url = Uri.parse('https://www.omdbapi.com/?t=$search&apikey=163f36f5');
    var response = await http.get(url);

    var rescode = response.statusCode;
    if (rescode == 200) {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);

      var genre = parsedJson['Genre'];
      var poster = parsedJson['Poster'];

      setState(() {
        descG = "Genre :$genre ";
        desP = "Poster: $poster";
      });
    } else
      setState(() {
        descG = "No record";
        desP = "No record";
      });
    progressDialog.dismiss();
  }
}
