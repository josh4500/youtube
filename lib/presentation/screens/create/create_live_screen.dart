import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/screens/accounts/accounts_screen.dart';
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
            const SizedBox(height: 40),
            const Text(
              'Eligibility',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            CustomActionChip(
              onTap: () {},
              title: 'OK',
              backgroundColor: Colors.white,
              textStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: context.theme.colorScheme.inverseSurface,
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(12),
            ),
            const SizedBox(height: 4),
            CustomActionChip(
              onTap: () {},
              title: 'Learn More',
              alignment: Alignment.center,
              padding: const EdgeInsets.all(12),
              textStyle: TextStyle(
                fontSize: 15,
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
