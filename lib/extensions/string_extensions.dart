extension StringExtension on String? {
  String? toCapitalizeWords() {
    if (this == null) return null;
    if (this!.isEmpty) {
      return ''; // Handle empty strings gracefully
    }
    return this!.split(' ').map((word) => word.toCapitalize()).join(' ');
  }

  String? toCapitalize() {
    if (this == null) return null;
    if (this!.isEmpty) {
      return ''; // Handle empty strings gracefully
    }
    return '${this![0].toUpperCase()}${this!.substring(1).toLowerCase()}';
  }
}
