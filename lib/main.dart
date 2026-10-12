import 'package:flutter/material.dart';

void main() {
  runApp(const ShoppingListApp());
}

class ShoppingListApp extends StatelessWidget {
  const ShoppingListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List',
      theme: ThemeData(colorSchemeSeed: Colors.green, useMaterial3: true),
      home: const ShoppingListPage(),
    );
  }
}

class Item {
  String name;
  bool bought;
  Item(this.name, {this.bought = false});
}

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Item> _items = [];

  void _addItem() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Type an item first')),
      );
      return;
    }
    setState(() {
      _items.add(Item(text));
      _controller.clear();
    });
  }

  void _toggleBought(int index) {
    setState(() {
      _items[index].bought = !_items[index].bought;
    });
  }

  void _deleteItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final boughtCount = _items.where((i) => i.bought).length;
    final notBoughtCount = _items.length - boughtCount;

    return Scaffold(
      appBar: AppBar(title: const Text('Shopping List')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Add an item',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addItem(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _addItem, child: const Text('Add')),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Not bought: $notBoughtCount',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Bought: $boughtCount',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return ListTile(
                    leading: Icon(
                      item.bought
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: item.bought ? Colors.green : Colors.grey,
                    ),
                    title: Text(
                      item.name,
                      style: TextStyle(
                        decoration:
                        item.bought ? TextDecoration.lineThrough : null,
                        color: item.bought ? Colors.grey : null,
                      ),
                    ),
                    subtitle: Text(item.bought ? 'Bought' : 'Not bought yet'),
                    onTap: () => _toggleBought(index),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteItem(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}