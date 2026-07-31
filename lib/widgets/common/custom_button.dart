import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../core/theme/app_colors.dart';

/// Reusable Modern Material 3 Button with Gradient and Loading Spinner
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isSecondary;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isSecondary = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        gradient: isSecondary ? null : AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(14),
        boxShadow: isSecondary || onPressed == null
            ? []
            : [
                BoxShadow(
                  color: AppColors.primaryBlue.withAlpha(80),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSecondary ? Colors.transparent : Colors.transparent,
          shadowColor: Colors.transparent,
          side: isSecondary ? BorderSide(color: Theme.of(context).primaryColor, width: 1.5) : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: isLoading
            ? const SpinKitThreeBounce(color: Colors.white, size: 24)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: isSecondary ? Theme.of(context).primaryColor : Colors.white),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSecondary ? Theme.of(context).primaryColor : Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
