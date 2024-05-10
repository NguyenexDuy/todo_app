import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todos_flutter/pages/add_pages.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List items = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getAllNote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title: const Text("Todo list")),
      body: Visibility(
        visible: isLoading,
        child: Center(
          child: const CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: getAllNote,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                "No todo here",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['_id'] as String;
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text("${index + 1}"),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(item['title']),
                    subtitle: Text(item['description']),
                    onTap: () {},
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == 'edit') {
                          navigatorToEditPage(item);
                        } else if (value == 'delete') {
                          deleteById(id);
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                            child: Text("Edit"),
                            value: 'edit',
                          ),
                          const PopupMenuItem(
                            child: Text("Delete"),
                            value: 'delete',
                          ),
                        ];
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          navigatorToAddPage();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> navigatorToAddPage() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AppPages(),
        ));
    setState(() {
      isLoading = true;
    });
    getAllNote();
  }

  Future<void> navigatorToEditPage(Map item) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AppPages(),
        ));
    setState(() {
      isLoading = true;
    });
    getAllNote();
  }

  Future<void> getAllNote() async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: {'accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteById(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      final filted = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filted;
      });
    } else {
      print("Delete failed");
    }
  }
}
