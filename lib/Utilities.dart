import 'package:fluent_ui/fluent_ui.dart';
import 'dart:io' show Directory, File, FileSystemEntity, Platform;
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;
import 'package:path/path.dart' as p;

const ver = "0.1.0";

String? homePath() {
	if (Platform.isIOS) {
		return "/var/mobile"; // welp a year with jailbroken iOS lol
	} else if (Platform.isWindows) {
		return Platform.environment['USERPROFILE'];
	} else if (Platform.isAndroid) {
		return '/storage/emulated/0';
	}
	return Platform.environment['HOME'];
}

Map<String, String> availableHomeDirs() {
	final home = homePath() ?? '/home';
	var ret = {
		"$home/Documents": "document",
		"$home/Music": "music_note",
		"$home/Pictures": "picture",
		"$home/Videos": "video",
		"$home/Desktop": "t_v_monitor",
		"$home/Public": "people",
		"$home/Templates": "file_template",
		"$home/Downloads": "download"
	};

	ret.removeWhere((key, value) => !pathIsDir(key));

	return ret;
}

/// Checks if a path points to a directory.
bool pathIsDir(String path) => FileSystemEntity.isDirectorySync(path);

class Changes with ChangeNotifier
{
	bool _showDirBar = false;
	bool get showDirBar { return _showDirBar; }
	set showDirBar(bool value) { _showDirBar = value; notifyListeners(); }

	bool _isUsingTree = false;
	bool get isUsingTree { return _isUsingTree; }
	set isUsingTree(bool value) { _isUsingTree = value; notifyListeners(); }

	int _navSelectedIdx = 0;
	int get navSelectedIdx { return _navSelectedIdx; }
	set navSelectedIdx(int index) { _navSelectedIdx = index; notifyListeners(); }

	String _currDir = 'C:\\Windows\\System32';
	String get currDir { return _currDir; }
	set currDir(String where) { _currDir = where; notifyListeners(); }
}

final Changes changes = Changes();

List<String> getDirContent(String path)
{
	List<String> result = [];
	final dir = Directory(path);

	result.addAll(
		dir.listSync().map((entity) => p.basename(entity.path)).toList()
	);
	return result;
}

void createNew(String path, bool isFile)
{
	if (path.isEmpty) return;
	if (isFile) File(path).createSync(recursive: true);
	else Directory(path).createSync(recursive: true);
}

/*
 *
 * Preferences functions, variables
 * 
 */

late final SharedPreferences prefs;
late final int selectedLanguage;

/*
 *
 * Queue lists
 * 
 */

List<String> copyQueue = [];
List<String> moveQueue = [];
List<String> delQueue = [];

/*
 * Pinned/favourites
 */

late List<String> pinned;
late List<String> favourites;
