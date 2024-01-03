import 'package:flutter/material.dart';

class LinkTvScreen extends StatefulWidget {
  const LinkTvScreen({super.key});

  @override
  State<LinkTvScreen> createState() => _LinkTvScreenState();
}

class _LinkTvScreenState extends State<LinkTvScreen> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Link with TV code'),
      ),
      body: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              SizedBox(
                width: 200,
                child: TextFormField(
                  keyboardAppearance: Brightness.dark,
                  controller: _controller,
                  focusNode: _focusNode,
                  maxLength: 15,
                  onTapOutside: (event) {
                    _focusNode.requestFocus();
                  },
                  keyboardType: TextInputType.number,
                  autocorrect: false,
                  canRequestFocus: true,
                  autofocus: true,
                  cursorOpacityAnimates: true,
                  cursorColor: Colors.blue,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: Colors.blue,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: Colors.blue,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: Colors.white,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: Colors.white,
                      ),
                    ),
                    labelStyle: TextStyle(
                      color: Colors.blue,
                    ),
                    labelText: 'Enter TV code',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey),
                  padding: MaterialStateProperty.all(
                    const EdgeInsetsDirectional.symmetric(
                      vertical: 8,
                      horizontal: 24,
                    ),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                ),
                child: const Text(
                  'Link',
                  style: TextStyle(
                    color: Colors.white54,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(thickness: 1.5, height: 0),
        ],
      ),
    );
  }
}
