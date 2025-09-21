// Import du package SharedPreferences pour la persistance des préférences
import 'package:shared_preferences/shared_preferences.dart';

/// Service de gestion des thèmes de l'application
/// Permet de sauvegarder et récupérer les préférences de thème de l'utilisateur
class ThemeService {
  /// Clé utilisée pour stocker la préférence de thème dans SharedPreferences
  static const String _themeKey = 'isDarkMode';

  /// Vérifie si le thème sombre est activé
  /// Retourne false par défaut si aucune préférence n'est sauvegardée
  ///
  /// Retourne true si le thème sombre est activé, false sinon
  Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false; // false par défaut
  }

  /// Définit le mode de thème de l'application
  /// Sauvegarde la préférence dans SharedPreferences
  ///
  /// [isDark] - true pour activer le thème sombre, false pour le thème clair
  Future<void> setDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }
}
