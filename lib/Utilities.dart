import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'dart:io' show Directory, File, FileSystemEntity, Platform, Process;
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;
import 'package:path/path.dart' as p;

const ver = "0.1.0";

String? homePath() {
	if (Platform.isIOS) {
		return "/var/mobile"; // welp a year with jailbroken iOS lol
	} else if (Platform.isWindows) {
		return Platform.environment['USERPROFILE'];
	} else if (Platform.isAndroid) {
		return '/storage/emulated/0'; // FIXME
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

	ret.forEach((key, value) async {
		final check = await pathIsDir(key);
		if (!check) ret.remove(key);
	});

	return ret;
}

Future<bool> pathIsDir(String path) async { return await FileSystemEntity.isDirectory(path); }

final String helperPath = '${p.dirname(Platform.resolvedExecutable)}/data/flutter_assets/lib/helper/helper';

List<String> stdardout = [];

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

	String _currDir = homePath() ?? "/";
	String get currDir { return _currDir; }
	set currDir(String where) { _currDir = where; notifyListeners(); }
}

final Changes changes = Changes();

Future<List<String>> getDirContent(String path) async
{
	List<String> result = [];
	try {
		final process = await Process.start(helperPath, ['list', path]);
		await process.stdout.transform(utf8.decoder).forEach((i) {
			print(i.replaceAll(RegExp('"'), '').replaceAll(RegExp('\n'), '').replaceAll(RegExp('\n'), ''));
			print('sep');
			result.add(i);
		});
	}
	catch (e) {
		final dir = Directory(path);

		result.addAll(
			await dir.list().map((entity) {
				return entity.path;
			}).toList()
		);
	}
	return result;
}

void createNew(String path, bool isFile)
async {
	if (path.isEmpty) return;
	try {
		await Process.start(helperPath, [isFile ? 'c' : 'md', path]);
	} catch (e) {
		if (isFile) File(path).create(recursive: true);
		else Directory(path).create(recursive: true);
	}
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
