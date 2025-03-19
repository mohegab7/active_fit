import 'package:active_fit/generated/l10n.dart';
import 'package:flutter/material.dart';


class OffDisclaimer extends StatelessWidget {
  const OffDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(S.of(context).offDisclaimer,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            fontStyle: FontStyle.italic));
  }
}
