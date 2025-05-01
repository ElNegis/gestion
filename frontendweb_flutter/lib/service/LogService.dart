import 'dart:convert';

class LogService {
  static LogService? _instance;
  final List<String> _logs = []; // Almacenamiento en memoria para los logs

  LogService._internal();

  /// Implementación de Singleton para LogService
  factory LogService() {
    _instance ??= LogService._internal();
    return _instance!;
  }

  /// **Registrar un evento en el log**
  void logEvent(String event) {
    final timestamp = DateTime.now().toIso8601String();
    final logEntry = '[$timestamp] $event';
    _logs.add(logEntry);
    print(logEntry); // Para depuración en consola
  }

  /// **Obtener todos los logs como texto**
  String getLogs() => _logs.join('\n');

  /// **Limpiar los logs**
  void clearLogs() => _logs.clear();

  /// **Exportar logs como base64 (para descargas en Web u otros usos)**
  Future<String> exportLogs() async {
    return base64Encode(utf8.encode(getLogs()));
  }
}
