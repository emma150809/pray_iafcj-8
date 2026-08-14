import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/phrases.dart';

/// Servicio de frases inspiradoras.
///
/// Obtiene las frases desde Firestore (colección `frases`) para poder
/// agregar frases nuevas desde la consola de Firebase sin tener que
/// actualizar la aplicación. Si no hay frases en Firebase o falla la
/// conexión, usa las frases locales como respaldo.
///
/// Estructura esperada de cada documento:
///   {
///     "frase": "Texto de la frase",
///     "autor": "Nombre del autor" (opcional)
///   }
class PhraseService {
  PhraseService._();

  static final PhraseService _instance = PhraseService._();
  factory PhraseService() => _instance;

  static const String _collection = 'frases';

  List<String>? _cache;

  /// Devuelve la lista de frases disponibles.
  ///
  /// La primera llamada consulta Firestore y guarda el resultado en caché
  /// para el resto de la sesión.
  Future<List<String>> phrases() async {
    final cached = _cache;
    if (cached != null) return cached;

    var result = List.of(AppPhrases.phrases);

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(_collection)
          .get(const GetOptions(source: Source.server));

      final frases = <String>[];

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final texto = (data['frase'] ?? data['la frase'] ?? data['texto']);
        if (texto is! String) continue;

        final frase = texto.trim();
        if (frase.isEmpty) continue;

        final autor = data['autor'];
        final autorText =
            autor is String && autor.trim().isNotEmpty ? autor.trim() : null;

        frases.add(autorText != null ? '$frase  -$autorText' : frase);
      }

      if (frases.isNotEmpty) result = frases;
    } catch (_) {
      // Sin conexión o sin permisos: usamos las frases locales.
    }

    _cache = result;
    return result;
  }
}
