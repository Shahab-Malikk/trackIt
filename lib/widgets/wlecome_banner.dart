import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class WlecomeBanner extends StatelessWidget {
  final String userName;
  const WlecomeBanner({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 35,
            child: ClipOval(
              child: FadeInImage(
                fit: BoxFit.cover,
                placeholder: MemoryImage(kTransparentImage),
                image: const NetworkImage(
                    'https://avatars.githubusercontent.com/u/74496590?v=4'),
                height: double.infinity,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome Back',
                style: TextStyle(fontSize: 14, color: Colors.black38),
              ),
              const SizedBox(
                height: 1,
              ),
              Text(userName,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600)),
            ],
          )
        ],
      ),
    );
  }
}
