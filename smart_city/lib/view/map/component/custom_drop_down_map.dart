import 'package:flutter/material.dart';
import 'package:smart_city/base/common/responsive_info.dart';
import 'package:smart_city/base/instance_manager/instance_manager.dart';
import 'package:smart_city/constant_value/const_size.dart';

import '../../../constant_value/const_colors.dart';
import '../../../services/api/get_vehicle/models/get_vehicle_model.dart';

class CustomDropdown extends StatefulWidget {
  VehicleTypeInfo? currentVehicle;
  final Function(VehicleTypeInfo) onSelected;
  final double? size;

   CustomDropdown({
    super.key,
    required this.currentVehicle,
    required this.onSelected,
    this.size,
  });

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

  Future<void> _toggleDropdown() async {
    if (_overlayEntry == null) {
      _overlayEntry = await _createOverlay();
      Overlay.of(context).insert(_overlayEntry!);
      _animationController.forward();
    } else {
      _animationController.reverse().then((_) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    }
  }

  Future<OverlayEntry> _createOverlay() async {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    VehicleTypeResponseModel ? vehicleTypeResponseModel = await InstanceManager().getVehicleTypeModel();
    double? height = (widget.size??40) * ((vehicleTypeResponseModel?.list??[]).length - 1) + 20 ;
    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: GestureDetector(
                onTap: () async {
                  await _toggleDropdown();
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            Positioned(
              left: offset.dx - 10,
              top: offset.dy - height - 10,
              width: (widget.size != null) ? widget.size! + 30 : 70,
              child: Material(
                color: Colors.transparent,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      height: height,
                      // height: 100,
                      decoration: BoxDecoration(
                        color: ConstColors.tertiaryContainerColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: (vehicleTypeResponseModel?.list??[]).where((vehicle) => vehicle != widget.currentVehicle).map((vehicle) {
                          return GestureDetector(
                            onTap: () {
                              setState(()  {
                                 _toggleDropdown();
                                widget.onSelected(vehicle);
                              });
                            },
                            child: Image.network(
                              vehicle.icon??"",
                              width: widget.size ?? 40,
                              height: widget.size ?? 40,
                              filterQuality: FilterQuality.low,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  getIconFromVehicleType(vehicle: vehicle),
                                  width: widget.size ?? 40,
                                  height: widget.size ?? 40,
                                  filterQuality: FilterQuality.low,
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

  }
  String getIconFromVehicleType({required VehicleTypeInfo vehicle}){
    String iconsStr = "assets/images/verhicle_type/pedestrians.png";
    switch(vehicle.shortName)
        {
      case "Ped":
        iconsStr = "assets/images/verhicle_type/pedestrians.png";
          break;
      case "Bik":
        iconsStr = "assets/images/verhicle_type/cycling.png";
        break;
      case "EVP":
        iconsStr = "assets/images/verhicle_type/ambulance.png";
        break;
      case "Bus":
        iconsStr = "assets/images/verhicle_type/Transit.png";
        break;
      case "Pol":
        iconsStr = "assets/images/verhicle_type/police.png";
        break;
      case "Ftr":
        iconsStr = "assets/images/verhicle_type/fire-truck.png";
        break;
    }
    return iconsStr;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: InstanceManager().getVehicleTypeModel(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return SizedBox.shrink();
          }
          VehicleTypeResponseModel ? vehicleTypeResponseModel = snapshot.data;
          return GestureDetector(
              onTap: () async {
               await _toggleDropdown();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(
                      width: (widget.size ?? 30),
                      height: (widget.size ?? 30),
                      child: ClipRect(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: (ResponsiveInfo.isTablet())
                              ? Image.network(widget.currentVehicle?.icon??"",
                            width: (widget.size ?? 30)-8,
                            height: (widget.size ?? 30)-8,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                getIconFromVehicleType(vehicle: widget.currentVehicle!),
                                width: (widget.size ?? 30)-8,
                                height: (widget.size ?? 30)-8,
                                filterQuality: FilterQuality.low,
                              );
                            },
                          ) : Image.network(
                            widget.currentVehicle?.icon??"",
                            width: (widget.size ?? 30)-8,
                            height: (widget.size ?? 30)-8,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                getIconFromVehicleType(vehicle: widget.currentVehicle!),
                                width:(widget.size ?? 30)-8,
                                height: (widget.size ?? 30)-8,
                                filterQuality: FilterQuality.low,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(vertical: 8.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Icon(Icons.arrow_drop_down, color: Colors.white, size: Dimens.size25Horizontal,),
                    ),
                  ),
                ],
              ));
        },);
  }
}
