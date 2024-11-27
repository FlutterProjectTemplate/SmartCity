import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final double size;
  final String avatar;
  final bool? enableEdit;

  const UserAvatar(
      {super.key, required this.avatar, required this.size, this.enableEdit});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size / 2),
            // border: Border.all(color: Colors.black54)
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size / 2),
          child: CachedNetworkImage(
            imageUrl: avatar,
            placeholder: (context, url) => Image.asset(
              'assets/images/user.png',
              fit: BoxFit.fill,
            ),
            errorWidget: (context, url, error) => Image.asset(
              'assets/images/user.png',
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
      if (enableEdit?? false) Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
              onTap: () {}, child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey
                ),
                color: Colors.white
              ),
              child: Icon(Icons.edit))))
    ]);
  }
}
