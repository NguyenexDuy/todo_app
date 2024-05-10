import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AppPages extends StatefulWidget {
  final Map? todo;
  const AppPages({super.key, this.todo});

  @override
  State<AppPages> createState() => _AppPagesState();
}

class _AppPagesState extends State<AppPages> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final descripton = todo['description'];
      _titleController.text = title;
      _descriptionController.text = descripton;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Page" : "Add Page")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(hintText: "title"),
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(hintText: "descripton"),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: isEdit ? editData : submitData,
                child: Text(isEdit ? "Edit note" : "Add note")),
          )
        ],
      ),
    );
  }

  Future<void> editData() async {
    final todo = widget.todo;
    if (todo == null) {
      print("You can not update");
      return;
    }

    final id = todo['_id'];
    // final isCompleted = todo['is_completed'];
    final title = _titleController.text;
    final descripton = _descriptionController.text;

    final body = {
      "title": title,
      "description": descripton,
      "is_completed": false
    };
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      print("Updation Success");
      showSuccessUpdateMessage("Updation Success");
    } else {
      print("Creation fail");
      print(response.body);
      showFailMessage("Updation fail");
    }
  }

  Future<void> submitData() async {
    //get data
    final title = _titleController.text;
    final descripton = _descriptionController.text;

    final body = {
      "title": title,
      "description": descripton,
      "is_completed": false
    };

    const url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201) {
      print("Creation Success");
      showSuccessMessage("Creation Success");
    } else {
      print("Creation fail");
      print(response.body);
      showFailMessage("Creation fail");
    }

    //submit data to sever
    //show notifycaiton sucess or fail
  }

  void showSuccessUpdateMessage(String mess) {
    final snackBar = SnackBar(content: Text(mess));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showSuccessMessage(String mess) {
    _titleController.text = '';
    _descriptionController.text = '';
    final snackBar = SnackBar(content: Text(mess));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showFailMessage(String mess) {
    final snackBar = SnackBar(
      content: Text(
        mess,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
