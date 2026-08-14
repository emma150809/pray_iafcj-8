import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'phrase_service.dart';

///==============================================================
/// Servicio de Notificaciones Locales
///
/// Se encarga de inicializar y programar notificaciones en el
/// dispositivo del usuario.
///==============================================================
class NotificationService {
  // Usamos un Singleton para tener una única instancia del servicio.
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // IDs para las notificaciones. Usar constantes evita errores.
  static const int _dailyPhraseId = 0;
  static const int _dailyReminderId = 1;

  final _notifications = FlutterLocalNotificationsPlugin();

  /// Inicializa el servicio de notificaciones.
  /// Pide los permisos necesarios en iOS.
  Future<void> init() async {
    try {
      // Configuración para Android. Usa el ícono de la app.
      const android = AndroidInitializationSettings('@mipmap/ic_notification');

      // Configuración para iOS. Pide permisos de alerta, sonido, etc.
      const ios = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const settings = InitializationSettings(android: android, iOS: ios);
      await _notifications.initialize(settings: settings);

      // Pide permiso explícitamente en Android 13+.
      final androidPlugin = _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await androidPlugin?.requestNotificationsPermission();

      // Configura las zonas horarias para programar notificaciones correctamente.
      await _configureTimezone();
    } catch (e, s) {
      // Usamos debugPrint para un mejor log en modo debug.
      debugPrint('Error al inicializar notificaciones: $e\n$s');
    }
  }

  /// Configura la zona horaria local del dispositivo.
  Future<void> _configureTimezone() async {
    try {
      tz.initializeTimeZones();
      final timeZoneInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneInfo.identifier));
    } catch (e, s) {
      debugPrint('Error al configurar la zona horaria: $e\n$s');
    }
  }

  /// Programa una notificación diaria con una frase inspiradora.
  Future<void> scheduleDailyPhraseNotification() async {
    try {
      // Cancelamos notificaciones anteriores para evitar duplicados.
      await _notifications.cancel(id: _dailyPhraseId);

      // Elegimos una frase al azar (Firestore o locales como respaldo).
      final random = Random();
      final frases = await PhraseService().phrases();
      final phrase = frases[random.nextInt(frases.length)];

      // Detalles del canal de notificación para Android.
      const androidDetails = AndroidNotificationDetails(
        'daily_phrase_channel',
        'Frase del Día',
        channelDescription: 'Notificaciones diarias con frases inspiradoras.',
        importance: Importance.max,
        priority: Priority.high,
      );
      const platformDetails = NotificationDetails(android: androidDetails);

      // Programamos la notificación para todos los días a las 9:00 AM.
      await _notifications.zonedSchedule(
        id: _dailyPhraseId,
        title: 'Frase del Día',
        body: phrase,
        scheduledDate: _nextInstanceOf(9, 0), // La hora: 9:00 AM
        notificationDetails: platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time, // Repetir diariamente
      );
    } catch (e, s) {
      debugPrint('Error al programar la frase diaria: $e\n$s');
    }
  }

  /// Programa un recordatorio diario personalizable.
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    try {
      // Detalles del canal de notificación para Android.
      const androidDetails = AndroidNotificationDetails(
        'daily_reminder_channel', // ID del canal
        'Recordatorio Diario', // Nombre del canal
        channelDescription: 'Recordatorio para registrar tus actividades.',
        importance: Importance.max,
        priority: Priority.high,
      );
      const platformDetails = NotificationDetails(android: androidDetails);

      await _notifications.zonedSchedule(
        id: _dailyReminderId,
        title: 'Recordatorio de Pray',
        body: '¡No olvides registrar tu oración y lectura de hoy!',
        scheduledDate: _nextInstanceOf(hour, minute),
        notificationDetails: platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time, // Repetir diariamente
      );
    } catch (e, s) {
      debugPrint('Error al programar el recordatorio diario: $e\n$s');
    }
  }

  /// Cancela el recordatorio diario personalizable.
  Future<void> cancelDailyReminder() async {
    await _notifications.cancel(id: _dailyReminderId);
  }

  /// Calcula la próxima instancia de la hora y minuto especificados.
  tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
