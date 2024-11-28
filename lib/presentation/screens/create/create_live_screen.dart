import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class CreateLiveScreen extends StatelessWidget {
  const CreateLiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Expanded(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      // 'Eligibility',
                      'Almost there!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Try creating more Shorts to reach 50 subscribers and unlock live streaming',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CustomActionChip(
              onTap: () {},
              title: 'Create Shorts',
              backgroundColor: Colors.white,
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: context.theme.colorScheme.inverseSurface,
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
            ),
            const SizedBox(height: 8),
            CustomActionChip(
              onTap: () {},
              title: 'Learn More',
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: context.theme.colorScheme.surface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
