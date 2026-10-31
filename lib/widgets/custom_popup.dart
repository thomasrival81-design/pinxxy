import 'dart:ui';
import 'package:flutter/material.dart';

class CustomPopup {
  static void show(BuildContext context, {required String title, required String message, String? confirmText, VoidCallback? onConfirm, String? cancelText, VoidCallback? onCancel, IconData? icon, Color? iconColor}) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (BuildContext context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF4FC3F7).withOpacity(0.3), width: 1.5),
              boxShadow: [BoxShadow(color: const Color(0xFF4FC3F7).withOpacity(0.1), blurRadius: 24, offset: const Offset(0, 10))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: (iconColor ?? const Color(0xFF4FC3F7)).withOpacity(0.15), shape: BoxShape.circle, border: Border.all(color: (iconColor ?? const Color(0xFF4FC3F7)).withOpacity(0.3), width: 1)),
                    child: Icon(icon, size: 36, color: iconColor ?? const Color(0xFF4FC3F7)),
                  ),
                  const SizedBox(height: 20),
                ],
                Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, fontFamily: 'Orbitron', color: Colors.white, letterSpacing: 1.0)),
                const SizedBox(height: 12),
                Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.white70, height: 1.5, fontFamily: 'ShareTechMono')),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (cancelText != null) ...[
                      Expanded(child: OutlinedButton(onPressed: onCancel ?? () => Navigator.of(context).pop(), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), foregroundColor: Colors.white70, side: BorderSide(color: Colors.white.withOpacity(0.2)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text(cancelText, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)))),
                      const SizedBox(width: 12),
                    ],
                    Expanded(child: ElevatedButton(onPressed: () { if (onConfirm != null) { onConfirm(); } else { Navigator.of(context).pop(); } }, style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), backgroundColor: const Color(0xFF4FC3F7), foregroundColor: Colors.black, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text(confirmText ?? 'OK', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
