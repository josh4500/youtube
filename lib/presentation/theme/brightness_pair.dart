/// A generic class representing a pair of values for different brightness modes.
///
/// This class is designed to hold two values, one for light mode and one for dark mode.
/// The values are represented by a generic type 'T', making the class flexible to
/// accommodate various numeric types (e.g., int, double) or any other custom type.
///
/// Example Usage:
/// ```dart
/// // Creating a BrightnessPair with color values for light and dark modes.
/// var colorPair = BrightnessPair<Color>(
///   light: Colors.white,
///   dark: Colors.black,
/// );
///
/// // Creating a BrightnessPair with font sizes for light and dark modes.
/// var fontSizePair = BrightnessPair<double>(
///   light: 16.0,
///   dark: 18.0,
/// );
/// ```
class BrightnessPair<T> {
  /// Value for light mode.
  final T light;

  /// Value for dark mode.
  final T dark;

  /// Constructs a BrightnessPair with values for light and dark modes.
  ///
  /// Parameters:
  /// - [light]: The value for light mode.
  /// - [dark]: The value for dark mode.
  const BrightnessPair({
    required this.light,
    required this.dark,
  });
}
