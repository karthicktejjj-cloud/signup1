import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Bespoke vector brand mark implemented cleanly with CustomPainter.
/// Crisp on all DPI screens, requires zero external PNG/SVG assets,
/// avoids generic AI clichés while delivering confident, high-end identity.
class BrandLogo extends StatelessWidget {
  final double size;
  final bool showBadge;

  const BrandLogo({
    super.key,
    this.size = 64.0,
    this.showBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      label: 'Application Brand Logo',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size * 0.28),
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(size * 0.2),
        child: CustomPaint(
          painter: _LogoPainter(
            primaryColor: isDark ? AppColors.primaryDark : AppColors.primary,
            accentColor: isDark ? const Color(0xFF60A5FA) : const Color(0xFF1E40AF),
          ),
        ),
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  final Color primaryColor;
  final Color accentColor;

  _LogoPainter({required this.primaryColor, required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Geometric layered apex crest
    final path1 = Path();
    path1.moveTo(w * 0.5, 0);
    path1.lineTo(w, h * 0.35);
    path1.lineTo(w * 0.75, h);
    path1.lineTo(w * 0.5, h * 0.65);
    path1.close();

    final paint1 = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(path1, paint1);

    final path2 = Path();
    path2.moveTo(w * 0.5, 0);
    path2.lineTo(0, h * 0.35);
    path2.lineTo(w * 0.25, h);
    path2.lineTo(w * 0.5, h * 0.65);
    path2.close();

    final paint2 = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(path2, paint2);

    // Subtle center highlight node
    final paintDot = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(w * 0.5, h * 0.35), w * 0.08, paintDot);
  }

  @override
  bool shouldRepaint(covariant _LogoPainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor ||
        oldDelegate.accentColor != accentColor;
  }
}
