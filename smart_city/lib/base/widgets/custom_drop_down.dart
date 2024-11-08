import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  double? borderRadious;
  Widget? itemWidget;
  final ValueChanged<String> onChanged;
  final String initialValue;

  CustomDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    required this.initialValue,
    this.itemWidget,
    this.borderRadious,
  });

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  OverlayEntry? _overlayEntry;
  bool _isDropdownOpen = false;
  String _selectedItem = "";

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialValue;
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _isDropdownOpen = true;
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isDropdownOpen = false;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx + (widget.borderRadious??0 / 2),
        top: offset.dy + size.height,
        width: size.width - (widget.borderRadious??0) - 20,
        child: Material(
          elevation: 4,
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.items.map((item) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedItem = item;
                    });
                    widget.onChanged(item);
                    _closeDropdown();
                  },
                  child: widget.itemWidget ?? Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    child: Text(item),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleDropdown,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(widget.borderRadious??8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_selectedItem, style: TextStyle(
              color: Colors.white
            ),),
            Icon(
              _isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            ),
          ],
        ),
      ),
    );
  }
}
