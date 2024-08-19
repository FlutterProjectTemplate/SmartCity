import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_city/base/widgets/button.dart';
import 'package:smart_city/base/widgets/custom_container.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_fonts.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class MapUi extends StatefulWidget {
  const MapUi({super.key});

  @override
  State<MapUi> createState() => _MapUiState();
}

class _MapUiState extends State<MapUi> with SingleTickerProviderStateMixin {
  late GoogleMapController _controller;
  late String _mapStyleString='';// map style
  bool hidden = true;// show or hide the countdown timer
  bool isCompleted = false; // check if the countdown timer is completed
  final LatLng _currentUserLocation = const LatLng(20.980238, 105.844616);

  @override
  void initState() {
    DefaultAssetBundle.of(context).loadString('assets/dark_mode_style.json').then((string) {
      _mapStyleString = string;
    });
    super.initState();
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
            child: hidden?const SizedBox():CircularCountDownTimer(
              isReverse: true,
              isReverseAnimation: false,
              duration: 3,
              width: width/3,
              height: width/3,
              fillColor: ConstColors.primaryColor,
              ringColor: ConstColors.tertiaryContainerColor,
              strokeWidth: 5.0,
              strokeCap: StrokeCap.round,
              autoStart: true,
              textStyle: ConstFonts().heading,
              onComplete: (){
                setState(() {
                  hidden = true;
                  isCompleted = true;
                });
              },
            )
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
                          onTap: (){
                            if(isCompleted){
                              _showDialog();
                            }
                          },
                          onLongPress:(){
                            setState(() {
                              hidden = false;
                            });
                          },
                          onLongPressEnd: (details){
                            setState(() {
                              hidden = true;
                            });
                          },
                          child:Button(
                            width: 60, height: 60, color:isCompleted?ConstColors.errorColor: ConstColors.primaryColor,
                            isCircle: true,
                            child: Icon(isCompleted?Icons.pause:Icons.play_arrow_rounded,color: isCompleted?Colors.white:ConstColors.tertiaryContainerColor,size:45,),
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

  void _showDialog() async{
    showDialog(
        context: context,
        builder: (context)=>AlertDialog(
          icon: const Icon(Icons.location_off_rounded,color: Colors.white,size: 45,),
          title:  Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Stop tracking',style: ConstFonts().copyWithTitle(fontSize: 19),),
              const SizedBox(height: 5,),
              Text('Are you sure you want to stop?',style: ConstFonts().copyWithSubHeading(fontSize: 15)),
              const SizedBox(height: 5,),
            ],
          ),
          backgroundColor: ConstColors.surfaceColor,
          actions: [
            Button(
                width: 105, height: 47,
                color:ConstColors.errorContainerColor,
                isCircle: false,
                child:TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Cancel",style: ConstFonts().copyWithTitle(fontSize: 16)),
                )
            ).getButton(),
            const SizedBox(width: 20,),
            Button(
                width: 105, height: 47,
                color:ConstColors.primaryColor,
                isCircle: false,
                child:TextButton(
                  onPressed: (){
                    setState(() {
                      isCompleted = false;// reset the countdown timer
                    });
                    Navigator.pop(context);
                  },
                  child: Text("Resume",style: ConstFonts().copyWithTitle(fontSize: 16)),
                )
            ).getButton(),
          ],
        )
    );
  }

  Widget controlButton({required IconData icon,required Function() onPressed,Color? color}){
    return Button(
        width: 45, height: 45, color: Colors.white,
        isCircle: true,
        child:IconButton(
          onPressed: onPressed,
          icon: Center(
              child: Icon(icon,color: color??(isCompleted?ConstColors.surfaceColor:ConstColors.secondaryContainerColor),size: 30,)),
        )
    ).getButton();
  }
}
