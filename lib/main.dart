import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Memo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'My Memo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, String>> _memo = [];

  void _showDialog() {
    var newMemo = {
      "title": "",
      "content": "",
    };
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Memo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(
                  hintText: 'title',
                ),
                onChanged: (value) => newMemo["title"] = value,
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'content',
                ),
                maxLines: null,
                onChanged: (value) => newMemo["content"] = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _memo.add(newMemo);
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _openMemo(int index) {
    Map<String, String> tempMemo = {
      "title": _memo[index]["title"]!,
      "content": _memo[index]["content"]!,
    };
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Memo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: TextEditingController(text: _memo[index]["title"]),
                onChanged: (value) => tempMemo["title"] = value,
              ),
              TextField(
                controller:
                    TextEditingController(text: _memo[index]["content"]),
                maxLines: null,
                onChanged: (value) => tempMemo["content"] = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _memo[index] = tempMemo;
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ReorderableListView(
          children: _memo
              .map((e) => Card(
                  key: ValueKey(e),
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(e["title"]!),
                          subtitle: Text(e["content"]!),
                          onTap: () => _openMemo(_memo.indexOf(e)),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _memo.remove(e);
                          });
                        },
                      ),
                    ],
                  )))
              .toList(),
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final Map<String, String> item = _memo.removeAt(oldIndex);
              _memo.insert(newIndex, item);
            });
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialog,
        tooltip: 'Add Memo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
