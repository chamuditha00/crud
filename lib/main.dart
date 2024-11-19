import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          body: Center(
            child: TodoList(),
          ),
        ),
      ),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final TextEditingController _todoController = TextEditingController();
  final List<String> _todos = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  void _saveTodo() {
    if (_todoController.text.isNotEmpty) {
      setState(() {
        _todos.add(_todoController.text);
        _listKey.currentState?.insertItem(_todos.length - 1);
        _todoController.clear();
      });
    } else {
      _showErrorDialog("Please enter a to-do item.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editTodo(int index) {
    if (index < _todos.length) {
      _todoController.text = _todos[index];
      _deleteTodo(index);
    }
  }

  void _deleteTodo(int index) {
    if (index < _todos.length) {
      String removedTodo = _todos[index];
      setState(() {
        _listKey.currentState?.removeItem(
          index,
          (context, animation) => _buildTodoTile(removedTodo, index, animation),
        );
        _todos.removeAt(index);
      });
    }
  }

  Widget _buildTodoTile(String todo, int index, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: ListTile(
          tileColor: Colors.tealAccent.withOpacity(0.1),
          title: Text(
            todo,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.teal[900],
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blueAccent),
                onPressed: () => _editTodo(index),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () => _deleteTodo(index),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            'To-Do Manager',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.teal[800],
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextFormField(
              controller: _todoController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.work, color: Colors.teal),
                labelText: 'To-Do',
                hintText: 'Enter your task',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              ),
              keyboardType: TextInputType.text,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveTodo,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.teal, // Text color
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 5,
              shadowColor: Colors.tealAccent.withOpacity(0.3),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text("Save To-Do"),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: AnimatedList(
              key: _listKey,
              initialItemCount: _todos.length,
              itemBuilder: (context, index, animation) {
                if (index >= _todos.length) {
                  return const SizedBox.shrink(); // Prevents RangeError
                }
                return _buildTodoTile(_todos[index], index, animation);
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
