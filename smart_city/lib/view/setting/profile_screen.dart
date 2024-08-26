import 'package:flutter/material.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_fonts.dart';
import 'package:smart_city/model/user/user_info.dart';

class ProfileScreen extends StatelessWidget {
  final UserInfo? userInfo;
  const ProfileScreen({super.key,this.userInfo});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstColors.surfaceColor,
        title: Text('Profile',style: ConstFonts().copyWithTitle(fontSize: 25),),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white,size: 25,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: ConstColors.surfaceColor,
      body: SizedBox(
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: height*0.03),
            CircleAvatar(
              radius: width*0.15,
              // backgroundImage: AssetImage('assets/images/profile.png'),
            backgroundColor: ConstColors.primaryColor,
            ),
            const SizedBox(height: 15),
            Text('John Doe', style: ConstFonts().copyWithTitle(fontSize: 24),),
            const SizedBox(height: 5),
            Text('${userInfo!=null?userInfo!.username:"admin2"}', style: ConstFonts().copyWithSubHeading(fontSize: 20,color:ConstColors.secondaryColor),),
            const SizedBox(height: 20),
            _informationContainer(information: "Pedestrian", label: "Type vehicles", icon: Icons.directions_walk),
            _informationContainer(information: '0123456789',label: 'Phone number',icon:Icons.phone),

          ],
        ),
      ),
    );
  }
  Widget _informationContainer({required String information,required String label,required IconData icon,Function()? onTap}){
    return ListTile(
      leading: Icon(icon,color: ConstColors.secondaryColor,size: 30,),
      title: Text(label,style: ConstFonts().copyWithTitle(fontSize: 18),),
      trailing: Text(information,style: ConstFonts().copyWithTitle(fontSize: 16,color:ConstColors.primaryColor),),
      onTap: onTap,
    );
  }
}
