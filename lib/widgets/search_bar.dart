// Import du package Flutter Material pour les widgets UI
import 'package:flutter/material.dart';

/// Widget de barre de recherche personnalisée
/// Fournit une interface de recherche moderne avec icônes et animations
class CustomSearchBar extends StatefulWidget {
  /// Texte d'indication affiché dans le champ de recherche
  final String hintText;

  /// Callback appelé quand le texte de recherche change
  final ValueChanged<String> onChanged;

  /// Callback optionnel appelé quand l'utilisateur efface la recherche
  final VoidCallback? onClear;

  /// Valeur initiale du champ de recherche
  final String? initialValue;

  const CustomSearchBar({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.onClear,
    this.initialValue,
  });

  @override
  State<CustomSearchBar> createState() => _SearchBarState();
}

/// État de la barre de recherche personnalisée
/// Gère le contrôleur de texte et les interactions utilisateur
class _SearchBarState extends State<CustomSearchBar> {
  // Contrôleur pour le champ de saisie de recherche
  late TextEditingController _controller;

  // Indique si l'utilisateur est en train de rechercher (champ non vide)
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Initialiser le contrôleur avec la valeur initiale
    _controller = TextEditingController(text: widget.initialValue ?? '');
    _isSearching = _controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    // Libérer les ressources du contrôleur
    _controller.dispose();
    super.dispose();
  }

  /// Gère les changements dans le champ de recherche
  /// Met à jour l'état de recherche et notifie le parent
  void _onTextChanged(String value) {
    setState(() {
      _isSearching = value.isNotEmpty;
    });
    widget.onChanged(value);
  }

  /// Efface le contenu de la barre de recherche
  /// Appelle le callback de nettoyage si fourni
  void _clearSearch() {
    _controller.clear();
    _onTextChanged('');
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        onChanged: _onTextChanged,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
          suffixIcon: _isSearching
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  onPressed: _clearSearch,
                  tooltip: 'Effacer la recherche',
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
