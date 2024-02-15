import 'package:flutter/material.dart';

class ScrollToBottomButton extends StatelessWidget {
  const ScrollToBottomButton({
    required this.scrollController,
    super.key,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      left: 0,
      top: null,
      bottom: 4,
      child: SizedBox(
        width: 48,
        height: 48,
        child: RawMaterialButton(
          elevation: 4,
          fillColor: Theme.of(context).colorScheme.secondaryContainer,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.keyboard_double_arrow_down_outlined,
          ),
          onPressed: () {
            scrollController.animateTo(
              0.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
      ),
    );
  }
}
