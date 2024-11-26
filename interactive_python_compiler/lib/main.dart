import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(PythonCompilerApp());
}

class PythonCompilerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PythonCompilerScreen(),
    );
  }
}

class PythonCompilerScreen extends StatefulWidget {
  @override
  _PythonCompilerScreenState createState() => _PythonCompilerScreenState();
}

class _PythonCompilerScreenState extends State<PythonCompilerScreen> {
  final TextEditingController _codeController = TextEditingController();
  String _output = "";
  String _error = "";

  Future<void> executeCode() async {
    final url = Uri.parse("http://127.0.0.1:5000/execute"); 
    final headers = {"Content-Type": "application/json"};
    final body = json.encode({"code": _codeController.text});

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        setState(() {
          _output = result["output"];
          _error = result["error"];
        });
      } else {
        final result = json.decode(response.body);
        setState(() {
          _output = "";
          _error = result["error"] ?? "Unknown error";
        });
      }
    } catch (e) {
      setState(() {
        _output = "";
        _error = "Error connecting to server: $e";
      });
    }
  }

  void clearCode() {
    setState(() {
      _codeController.clear();
      _output = "";
      _error = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Interactive Python Compiler"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _codeController,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: "Enter Python code here...",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: executeCode,
                  child: Text("Submit"),
                ),
                ElevatedButton(
                  onPressed: clearCode,
                  child: Text("Clear"),
                  style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              "Output:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              padding: EdgeInsets.all(8),
              color: Colors.black12,
              height: 100,
              child: SingleChildScrollView(
                child: Text(
                  _output.isNotEmpty ? _output : "No output",
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ),
            SizedBox(height: 16),
            if (_error.isNotEmpty)
              Text(
                "Error:",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
            if (_error.isNotEmpty)
              Container(
                padding: EdgeInsets.all(8),
                color: Colors.black12,
                height: 100,
                child: SingleChildScrollView(
                  child: Text(
                    _error,
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
