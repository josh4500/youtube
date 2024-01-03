import 'package:flutter/material.dart';

class AccountIncognitoScreen extends StatelessWidget {
  const AccountIncognitoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(36),
                  margin: const EdgeInsets.symmetric(horizontal: 94),
                  alignment: Alignment.center,
                  child: const SizedBox(
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 62.0),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: const Text(
                  'Nothing is added to the "You" tab while you\'re incognito',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(height: 9),
              TextButton(
                child: const Text('Turn off Incognito'),
                onPressed: () {},
              ),
            ],
          ),
        ),
        const Expanded(
          child: Column(
            children: [
              if (false) Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ],
    );
  }
}
