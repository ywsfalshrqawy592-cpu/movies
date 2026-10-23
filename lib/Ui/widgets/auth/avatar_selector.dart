import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_colors.dart';

const List<String> authAvatarAssets = [
  'assets/images/avatar1.png',
  'assets/images/avatar2.png',
  'assets/images/avatar3.png',
  'assets/images/avatar4.png',
  'assets/images/avatar5.png',
  'assets/images/avatar6.png',
  'assets/images/avatar7.png',
  'assets/images/avatar8.png',
  'assets/images/avatar9.png',
];

/// Three-position avatar picker matching the register screen artwork.
class AvatarSelector extends StatelessWidget {
  const AvatarSelector({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final sideSize = width * .22;
    final selectedSize = width * .37;

    Widget avatar(int index, double size, {required bool selected}) =>
        Semantics(
          button: true,
          selected: selected,
          label: 'Avatar ${index + 1}',
          child: GestureDetector(
            onTap: () => onSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: size,
              height: size,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: selected
                      ? AppColors.primaryColor
                      : AppColors.transparentColor,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(authAvatarAssets[index], fit: BoxFit.cover),
              ),
            ),
          ),
        );

    final leftIndex =
        (selectedIndex - 1 + authAvatarAssets.length) % authAvatarAssets.length;
    final rightIndex = (selectedIndex + 1) % authAvatarAssets.length;

    return SizedBox(
      height: selectedSize + 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          avatar(leftIndex, sideSize, selected: false),
          avatar(selectedIndex, selectedSize, selected: true),
          avatar(rightIndex, sideSize, selected: false),
        ],
      ),
    );
  }
}
