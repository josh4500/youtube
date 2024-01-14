// MIT License
//
// Copyright (c) 2024 Ajibola Akinmosin (https://github.com/josh4500)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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
