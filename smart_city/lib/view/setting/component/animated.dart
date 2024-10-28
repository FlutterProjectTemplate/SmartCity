import 'package:flutter/material.dart';

class AnimatedListExample extends StatefulWidget {
  @override
  _AnimatedListExampleState createState() => _AnimatedListExampleState();
}

class _AnimatedListExampleState extends State<AnimatedListExample> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<String> _items = ["Item 1", "Item 2", "Item 3"];

  void _addItem() {
    final newIndex = _items.length;
    _items.add("Item ${newIndex + 1}");
    _listKey.currentState?.insertItem(newIndex);
  }

  void _removeAllItems() {
    for (var i = _items.length - 1; i >= 0; i--) {
      _removeItem(i);
    }
  }

  void _removeItem(int index) {
    final removedItem = _items[index];
    _items.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
          (context, animation) => _buildItem(removedItem, animation, isRemoving: true),
      duration: Duration(milliseconds: 500),
    );
  }

  Widget _buildItem(String item, Animation<double> animation, {bool isRemoving = false}) {
    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(
          begin: isRemoving ? Offset(1, 0) : Offset(-1, 0),
          end: isRemoving ? Offset.zero : Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOut)),
      ),
      child: ListTile(
        title: Text(item),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            final index = _items.indexOf(item);
            if (index != -1) _removeItem(index);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animated List Example"),
        actions: [
          IconButton(
            onPressed: _removeAllItems,
            icon: Icon(Icons.delete),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: AnimatedList(
              key: _listKey,
              initialItemCount: _items.length,
              itemBuilder: (context, index, animation) {
                return _buildItem(_items[index], animation);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _addItem,
              child: Text("Add Item"),
            ),
          ),
        ],
      ),
    );
  }
}
