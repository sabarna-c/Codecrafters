import 'package:flutter/material.dart';

/// Social OAuth Button (Google, Microsoft)
class SocialAuthButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const SocialAuthButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  factory SocialAuthButton.google({required VoidCallback onPressed}) {
    return SocialAuthButton(
      label: 'Continue with Google',
      icon: Icons.g_mobiledata_rounded,
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(
          color: isDark ? Colors.white24 : Colors.black12,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: isDark ? Colors.white : Colors.black87),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
