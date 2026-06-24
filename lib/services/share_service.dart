import 'package:share_plus/share_plus.dart';
import '../models/task.dart';

class ShareService {
  static Future<void> shareTask(Task task) async {
    final text = '''
🌊 Tide Pro Shared Task

Title: ${task.title}
Category: ${task.category}
Priority: ${task.priority}

(Read Only)
''';

    await Share.share(text);
  }
}