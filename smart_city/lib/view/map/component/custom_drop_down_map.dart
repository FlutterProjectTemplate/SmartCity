import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constant_value/const_colors.dart';
import '../../../controller/vehicles_bloc/vehicles_bloc.dart';

class CustomDropdown extends StatefulWidget {
  final Map<VehicleType, String> transport;
  final VehicleType currentVehicle;
  final Function(VehicleType) onSelected;

  const CustomDropdown({
    Key? key,
    required this.transport,
    required this.currentVehicle,
    required this.onSelected,
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlay();
      Overlay.of(context).insert(_overlayEntry!);
      _animationController.forward();
    } else {
      _animationController.reverse().then((_) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    }
  }

  OverlayEntry _createOverlay() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) {
        return Positioned(
          left: offset.dx - 10,
          top: offset.dy -  210 * 3 / 4 - 5,
          width: 70,
          child: Material(
            color: Colors.transparent,
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  height: 210 * 3 / 4,
                  decoration: BoxDecoration(
                    color: ConstColors.tertiaryContainerColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: widget.transport.keys.where((vehicle) => vehicle != widget.currentVehicle).map((vehicle) {
                      return GestureDetector(
                        onTap: () {
                          widget.onSelected(vehicle);
                          _toggleDropdown();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            widget.transport[vehicle]!,
                            width: 40,
                            height: 40,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleDropdown,
      child: Image.asset(
        widget.transport[widget.currentVehicle] ??
            widget.transport[VehicleType.pedestrians]!,
        width: 40,
        height: 40,
      ),
    );
  }
}