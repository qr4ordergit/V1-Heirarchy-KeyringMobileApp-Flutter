abstract class FileException implements Exception {
  const FileException();
}

class FileTooLargeException extends FileException {
  final String fileName;
  final int actualSize;
  final int maxSize;

  const FileTooLargeException({
    required this.fileName,
    required this.actualSize,
    required this.maxSize,
  });

  @override
  String toString() =>
      '$fileName is too large (${(actualSize / (1024 * 1024)).toStringAsFixed(1)} MB, '
          'max ${(maxSize / (1024 * 1024)).toStringAsFixed(1)} MB)';
}

class TooManyFilesException extends FileException {
  final int selected;
  final int max;

  const TooManyFilesException({
    required this.selected,
    required this.max,
  });

  @override
  String toString() => 'Selected $selected files, maximum allowed is $max';
}

class TotalSizeTooLargeException extends FileException {
  final int actualSize;
  final int maxSize;

  const TotalSizeTooLargeException({
    required this.actualSize,
    required this.maxSize,
  });

  @override
  String toString() =>
      'Total size ${(actualSize / (1024 * 1024)).toStringAsFixed(1)} MB exceeds '
          'limit of ${(maxSize / (1024 * 1024)).toStringAsFixed(1)} MB';
}