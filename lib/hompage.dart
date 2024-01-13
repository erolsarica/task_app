import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TASK APP'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            _addTodoWidget(),
            _todoListWidget(),
          ],
        ),
      ),
    );
  }

  Container _addTodoWidget() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: const TextField(
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: null,
            icon: Icon(Icons.add),
          ),
          hintText: 'Enter a task',
          border: OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }

  Expanded _todoListWidget() {
    return Expanded(
      child: ListView.separated(
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('Task ${index + 1}'),
            trailing: const IconButton(
              onPressed: null,
              icon: Icon(Icons.delete),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            height: 1,
            thickness: 0,
            color: Colors.grey,
          );
        },
      ),
    );
  }
}
