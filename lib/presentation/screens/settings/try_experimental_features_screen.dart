import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class TryExperimentalFeaturesScreen extends StatelessWidget {
  const TryExperimentalFeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(onPressed: context.pop),
        title: const Text('Try Experimental Features'),
      ),
    );
  }
}
