// Import du package Flutter Material pour les widgets UI
import 'package:flutter/material.dart';

/// Énumération des types de filtres disponibles pour les notes
enum NoteFilter {
  all, // Toutes les notes
  recent, // Notes récentes (7 derniers jours)
  old, // Notes anciennes (plus de 7 jours)
  withTitle, // Notes avec titre
  withoutTitle, // Notes sans titre
}

/// Widget de puces de filtrage pour les notes
/// Permet à l'utilisateur de filtrer les notes selon différents critères
class FilterChips extends StatelessWidget {
  /// Filtre actuellement sélectionné
  final NoteFilter selectedFilter;

  /// Callback appelé quand l'utilisateur change de filtre
  final ValueChanged<NoteFilter> onFilterChanged;

  const FilterChips({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: NoteFilter.values.map((filter) {
          final isSelected = selectedFilter == filter;
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onFilterChanged(filter);
                }
              },
              label: Text(_getFilterLabel(filter)),
              avatar: Icon(
                _getFilterIcon(filter),
                size: 18,
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              selectedColor: theme.colorScheme.primary,
              checkmarkColor: theme.colorScheme.onPrimary,
              labelStyle: TextStyle(
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withOpacity(0.5),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Retourne le libellé textuel pour un filtre donné
  /// Utilisé pour afficher le nom du filtre sur la puce
  String _getFilterLabel(NoteFilter filter) {
    switch (filter) {
      case NoteFilter.all:
        return 'Toutes';
      case NoteFilter.recent:
        return 'Récentes';
      case NoteFilter.old:
        return 'Anciennes';
      case NoteFilter.withTitle:
        return 'Avec titre';
      case NoteFilter.withoutTitle:
        return 'Sans titre';
    }
  }

  /// Retourne l'icône correspondant à un filtre donné
  /// Utilisée pour l'affichage visuel sur la puce de filtre
  IconData _getFilterIcon(NoteFilter filter) {
    switch (filter) {
      case NoteFilter.all:
        return Icons.list; // Icône de liste pour toutes les notes
      case NoteFilter.recent:
        return Icons.schedule; // Icône d'horloge pour les notes récentes
      case NoteFilter.old:
        return Icons.history; // Icône d'historique pour les notes anciennes
      case NoteFilter.withTitle:
        return Icons.title; // Icône de titre pour les notes avec titre
      case NoteFilter.withoutTitle:
        return Icons.text_fields; // Icône de texte pour les notes sans titre
    }
  }
}
