import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DevicePlanCard extends StatelessWidget {
  const DevicePlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.deviceAndPlanDetails,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),

          const SizedBox(height: 20),

          // Nomad package section
          Text(
            l10n.nomadPackageIncludes,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),

          const SizedBox(height: 12),

          _buildFeatureItem(
            context,
            l10n.oneHub,
            theme.colorScheme.onPrimary,
          ),

          const SizedBox(height: 8),

          _buildFeatureItem(
            context,
            l10n.onePlug,
            theme.colorScheme.onPrimary,
          ),

          const SizedBox(height: 8),

          _buildFeatureItem(
            context,
            l10n.instructionManual,
            theme.colorScheme.onPrimary,
          ),

          const SizedBox(height: 20),

          // Pro plan section
          Text(
            l10n.proPlanIncludes,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),

          const SizedBox(height: 12),

          _buildFeatureItem(
            context,
            l10n.firstFeature,
            theme.colorScheme.onPrimary,
          ),

          const SizedBox(height: 8),

          _buildFeatureItem(
            context,
            l10n.secondFeature,
            theme.colorScheme.onPrimary,
          ),

          const SizedBox(height: 8),

          _buildFeatureItem(
            context,
            l10n.thirdFeature,
            theme.colorScheme.onPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, String text, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check,
            color: Theme.of(context).colorScheme.primary,
            size: 12,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color,
                ),
          ),
        ),
      ],
    );
  }
}
