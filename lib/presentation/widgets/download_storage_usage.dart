import 'package:flutter/material.dart';

class DownloadStorageUsage extends StatelessWidget {
  const DownloadStorageUsage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const LinearProgressIndicator(
            backgroundColor: Colors.grey,
            value: 0,
            valueColor: AlwaysStoppedAnimation(Colors.blue),
            minHeight: 12,
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 12,
                    width: 12,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'O MB used',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '4.5 GB free',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    height: 12,
                    width: 12,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
