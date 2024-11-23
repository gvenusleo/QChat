import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _controller = TextEditingController();
  bool _textIsEmpty = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: ListTile(
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                title: TextField(
                  controller: _controller,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: '搜索',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                  ),
                  onChanged: (value) async {
                    if (value.isEmpty && !_textIsEmpty) {
                      setState(() {
                        _textIsEmpty = true;
                      });
                    } else if (value.isNotEmpty && _textIsEmpty) {
                      setState(() {
                        _textIsEmpty = false;
                      });
                    }
                  },
                ),
                trailing: _textIsEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _controller.clear();
                          if (!_textIsEmpty) {
                            setState(() {
                              _textIsEmpty = true;
                            });
                          }
                        },
                        icon: const Icon(Icons.clear_outlined),
                      ),
                horizontalTitleGap: 0,
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                minVerticalPadding: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(48),
                ),
                tileColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
