import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserAvatar extends StatelessWidget {
  final double size;
  final String avatar;
  const UserAvatar({super.key, required this.avatar, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size/2),
      ),
      child: CachedNetworkImage(
        imageUrl: avatar,
        placeholder: (context, url) => Image.asset(
          'assets/images/profile.png',
          fit: BoxFit.fill,
        ),
        errorWidget: (context, url, error) => Image.asset(
          'assets/images/profile.png',
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}