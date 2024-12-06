import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileSystemService {
  factory FileSystemService() {
    return _instance;
  }

  FileSystemService._();

  static final FileSystemService _instance = FileSystemService._();
  static FileSystemService get instance => _instance;

  Directory? _documentDirectory;
  Directory? _temporaryDirectory;
  Directory? _externalStorageDirectory;
  Directory? _cacheDirectory;

  // Initialize the directories
  Future<void> init() async {
    _documentDirectory ??= await getApplicationDocumentsDirectory();
    _temporaryDirectory ??= await getTemporaryDirectory();
    _externalStorageDirectory ??= await getExternalStorageDirectory();
    _cacheDirectory ??= await getApplicationSupportDirectory();
  }

  // Get the app's document directory (cached after init)
  Directory? get documentDirectory => _documentDirectory;

  // Get the app's temporary directory (cached after init)
  Directory? get temporaryDirectory => _temporaryDirectory;

  // Get the external storage directory (cached after init)
  Directory? get externalStorageDirectory => _externalStorageDirectory;

  // Get the app's cache directory (cached after init)
  Directory? get cacheDirectory => _cacheDirectory;

  // Check and request permission to access external storage (for Android)
  Future<bool> requestStoragePermission() async {
    final PermissionStatus status = await Permission.storage.request();
    return status.isGranted;
  }

  // Create a custom directory within the app's document directory
  Future<Directory> createDirectory(String dirName) async {
    final appDocDir = _documentDirectory;
    if (appDocDir == null) {
      throw Exception('Document directory is not initialized.');
    }
    final customDir = Directory('${appDocDir.path}/$dirName');

    if (!customDir.existsSync()) {
      await customDir.create();
    }

    return customDir;
  }

  // Check if a file exists in the document directory
  bool fileExists(String path) => File(path).existsSync();

  // Delete a file or directory in the document directory
  Future<void> deleteFile(String path) async {
    final dir = Directory(path);
    if (dir.existsSync()) {
      await dir.delete(recursive: true);
    }
  }

  // Move a file from source to destination
  Future<void> moveFile(
    String sourcePath,
    String destPath,
  ) async {
    final sourceFile = File(sourcePath);
    if (sourceFile.existsSync()) {
      await sourceFile.rename(destPath);
    } else {
      throw Exception('Source file does not exist.');
    }
  }

  // Copy a file from source to destination
  Future<void> copyFile(
    String sourcePath,
    String destPath,
  ) async {
    final sourceFile = File(sourcePath);
    if (sourceFile.existsSync()) {
      await sourceFile.copy(destPath);
    } else {
      throw Exception('Source file does not exist.');
    }
  }
}
