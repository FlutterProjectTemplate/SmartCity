import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_city/base/widgets/button.dart';
import 'package:smart_city/base/widgets/custom_container.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_fonts.dart';

class MapUi extends StatefulWidget {
  const MapUi({super.key});

  @override
  State<MapUi> createState() => _MapUiState();
}

class _MapUiState extends State<MapUi> with SingleTickerProviderStateMixin {
  late GoogleMapController _controller;
  late String _mapStyleString='';
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool hidden = true;
  LatLng _currentUserLocation = const LatLng(20.980238, 105.844616);

  @override
  void initState() {
    DefaultAssetBundle.of(context).loadString('assets/dark_mode_style.json').then((string) {
      _mapStyleString = string;
    });
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween<double>(begin: 3, end: 0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if(status == AnimationStatus.forward){
          setState(() {
            hidden = false;
          });
        }
        if (status == AnimationStatus.completed) {
          setState(() {
            hidden = true;
          });
        }
      });
    super.initState();
  }
  @override
  void dispose() {
    _animationController.dispose();
      super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: width,
            height: height,
          ),
          GoogleMap(
            style: _mapStyleString,
            mapType: MapType.normal,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: _currentUserLocation,
                zoom: 14.4746,
              ),
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
                setState(() {});
              }
          ),
          Positioned(
              top: 50,
              right: 20,
              child: SizedBox(
                height: 180,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    controlButton(icon: Icons.notifications, onPressed:(){},color: ConstColors.tertiaryColor),
                    controlButton(icon: Icons.settings, onPressed:(){},color: ConstColors.tertiaryColor),
                    controlButton(icon: Icons.layers, onPressed:(){},color: ConstColors.tertiaryColor),
                  ],
                ),
              )
          ),
          Align(
            alignment: Alignment.center,
            child: Text(hidden?"":
            _animation.value.toInt() == 0.0 ?"Start":_animation.value.toStringAsFixed(1),
              style: ConstFonts().heading,),
          ),
          Positioned(
              bottom: 15,
              left: 15,
              child:ClipPath(
                clipper: CustomContainer(),
                child: Container(
                  width: width-30,
                  height: 105,
                  color:ConstColors.tertiaryContainerColor,
                  child: Padding(
                    padding: const EdgeInsets.only(top:35,left: 10,right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/sport-car.png",height: 60,width: 60,),
                        controlButton(icon: Icons.turn_left_rounded, onPressed: (){}),
                        controlButton(icon: Icons.straight_rounded, onPressed: (){}),
                        controlButton(icon: Icons.turn_right_rounded, onPressed: (){}),
                        GestureDetector(
                          onLongPress:(){
                            _animationController.forward(from: 0.0);
                          },
                          onLongPressEnd: (details){
                            _animationController.reset();
                            setState(() {
                              hidden = true;
                            });
                          },
                          child:Button(
                            width: 60, height: 60, color: ConstColors.primaryColor,
                            isCircle: true,
                            child: const Icon(Icons.play_arrow_rounded,color: ConstColors.tertiaryContainerColor,size:45,),
                          ).getButton(),
                        )
                      ],
                    ),
                  ),
                ),
              ),
          ),
          Positioned(
              bottom: 85,
              left: width/2.55,
              child: Center(
                child: Text("00:00:00",style: ConstFonts().information,),
              )
          ),
        ],
      ),
    );
  }

  Widget controlButton({required IconData icon,required Function() onPressed,Color? color}){
    return Button(
        width: 45, height: 45, color: Colors.white,
        isCircle: true,
        child:IconButton(
          onPressed: onPressed,
          icon: Center(
              child: Icon(icon,color: color??ConstColors.secondaryContainerColor,size: 30,)),
        )
    ).getButton();
  }
}
