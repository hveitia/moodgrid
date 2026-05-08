import 'package:flutter/material.dart';

/// GlobalKey para el [ScaffoldMessenger] raíz de la app.
/// Permite mostrar SnackBars desde controllers (sin BuildContext) o desde
/// cualquier lugar fuera del árbol de widgets.
///
/// Se conecta en `main.dart` con `GetMaterialApp(scaffoldMessengerKey: ...)`.
final GlobalKey<ScaffoldMessengerState> appScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

enum AppSnackKind { info, success, error, warning }

/// Muestra un SnackBar global con título + mensaje.
///
/// Si por algún motivo el messenger no está disponible (la app aún no
/// montó el árbol), la llamada es no-op silenciosa.
void appSnackBar({
  required String title,
  required String message,
  AppSnackKind kind = AppSnackKind.info,
  Duration duration = const Duration(seconds: 4),
}) {
  final messenger = appScaffoldMessengerKey.currentState;
  if (messenger == null) return;

  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(message),
        ],
      ),
      backgroundColor: _backgroundFor(kind),
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
  );
}

Color? _backgroundFor(AppSnackKind kind) {
  switch (kind) {
    case AppSnackKind.success:
      return Colors.green.shade600;
    case AppSnackKind.error:
      return Colors.red.shade600;
    case AppSnackKind.warning:
      return Colors.orange.shade700;
    case AppSnackKind.info:
      return null; // usa el color por defecto del tema
  }
}
