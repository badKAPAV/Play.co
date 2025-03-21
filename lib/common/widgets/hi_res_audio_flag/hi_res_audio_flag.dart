import 'package:flutter/material.dart';

class HiResAudioFlag extends StatelessWidget {
  const HiResAudioFlag({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      //height: height / 35,
      width: width / 4,
      decoration: BoxDecoration(
          color: Colors.white24, borderRadius: BorderRadius.circular(15)),
      child: const Center(
        child: Text(
          'Hi-Res Audio',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white54),
        ),
      ),
    );
  }
}
