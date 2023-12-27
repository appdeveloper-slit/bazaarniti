import 'package:flutter/material.dart';

class podcastDetail extends StatefulWidget {
  const podcastDetail({super.key});

  @override
  State<podcastDetail> createState() => _podcastDetailState();
}

class _podcastDetailState extends State<podcastDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Podcast'),
      ),
    );
  }
}
