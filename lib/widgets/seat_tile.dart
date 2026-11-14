import 'package:flutter/material.dart';

enum SeatState { available, unavailable, selected }

class SeatTile extends StatelessWidget {
  final int number;
  final SeatState state;
  final double size;
  final VoidCallback onTap;

  const SeatTile({
    super.key,
    required this.number,
    required this.state,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    late final Color fill;
    late final Color border;
    late final Color fg;
    switch (state) {
      case SeatState.available:
        fill = Colors.white;
        border = scheme.primary;
        fg = scheme.primary;
        break;
      case SeatState.unavailable:
        fill = const Color(0xFFE0E0E0);
        border = const Color(0xFFBDBDBD);
        fg = const Color(0xFF9E9E9E);
        break;
      case SeatState.selected:
        fill = scheme.primary;
        border = scheme.primary;
        fg = scheme.onPrimary;
        break;
    }
    return Padding(
      padding: const EdgeInsets.all(3),
      child: SizedBox(
        width: size,
        height: size,
        child: Material(
          color: fill,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: border, width: 1.5),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onTap,
            child: Center(
              child: state == SeatState.unavailable
                  ? Icon(Icons.close, size: size * 0.5, color: fg)
                  : Text('$number',
                      style: TextStyle(
                          color: fg,
                          fontWeight: FontWeight.w600,
                          fontSize: size * 0.34)),
            ),
          ),
        ),
      ),
    );
  }
}
