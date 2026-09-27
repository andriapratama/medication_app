import 'package:flutter/material.dart';

class MedicationCardList extends StatelessWidget {
  final ScrollController? scrollController;
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

  const MedicationCardList({
    super.key,
    this.scrollController,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListView.separated(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: itemCount,
          separatorBuilder: (context, index) =>
              Divider(height: 1, color: Colors.grey.shade200),
          itemBuilder: itemBuilder,
        ),
      ),
    );
  }
}
