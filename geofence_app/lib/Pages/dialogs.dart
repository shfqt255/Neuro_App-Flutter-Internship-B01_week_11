import 'package:flutter/material.dart';

class Dialogs {
  static Future<bool?> showLocationDisabledDialog(BuildContext context) {
    return _buildDialog(
      context,
      icon: Icons.location_off,
      iconColor: Colors.red,
      title: 'Location Services Disabled',
      content: 'Turn on Location.',
      showCancel: true,
    );
  }

  static Future<void> showPermissionDeniedDialog(BuildContext context) {
    return _buildDialog(
      context,
      icon: Icons.location_on,
      iconColor: Colors.orange,
      title: 'Location Permission Required',
      content: 'Please grant location permission to continue.',
      showCancel: false,
    );
  }

  static Future<bool?> showPermissionPermanentlyDeniedDialog(
    BuildContext context,
  ) {
    return _buildDialog(
      context,
      icon: Icons.warning,
      iconColor: Colors.red,
      title: 'Permission Permanently Denied',
      content: 'Enable permission from app settings.',
      showCancel: true,
    );
  }

  static Future<bool?> _buildDialog(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
    required bool showCancel,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 10),
            Expanded(child: Text(title)),
          ],
        ),
        content: Text(content),
        actions: [
          if (showCancel)
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
