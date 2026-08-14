import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_text_styles.dart';
import '../services/phrase_service.dart';

class VerseCard extends StatefulWidget {
  const VerseCard({super.key});

  @override
  State<VerseCard> createState() => _VerseCardState();
}

class _VerseCardState extends State<VerseCard> {
  late Future<List<String>> _phrasesFuture;

  @override
  void initState() {
    super.initState();
    _phrasesFuture = PhraseService().phrases();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _phrasesFuture,
      builder: (context, snapshot) {
        final frases = snapshot.data ?? const <String>[''];
        if (frases.isEmpty) return const SizedBox.shrink();

        final dayNumber =
            DateTime.now().millisecondsSinceEpoch ~/
            Duration.millisecondsPerDay;

        final frase = frases[dayNumber % frases.length];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            frase,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              fontSize: 20,
              height: 1.5,
              color: AppColors.text,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
    );
  }
}
