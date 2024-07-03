import 'package:fluent_ui/fluent_ui.dart';
import 'dart:io' show FileSystemEntity, Platform;
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;

const ver = 1.0;

Text createText(String text, double? size)
{
	return Text(text, style: TextStyle(fontFamily: 'Ubuntu', fontSize: size));
}

Text createBoldText(String text, double? size)
{
	return Text(text, style: TextStyle(fontFamily: 'Ubuntu', fontWeight: FontWeight.bold, fontSize: size));
}

Text createMonoText(String text, double? size)
{
	return Text(text, style: TextStyle(fontFamily: 'UbuntuMono', fontSize: size));
}

Text createBoldMonoText(String text, double? size)
{
	return Text(text, style: TextStyle(fontFamily: 'UbuntuMono', fontWeight: FontWeight.bold, fontSize: size));
}

Widget emptyList()
{
	return Center(
		child: Column(
			mainAxisAlignment: MainAxisAlignment.center,
			children: [
				const Icon(FluentIcons.field_empty),
				createBoldMonoText('It\'s empty here.', 25)
			],
		)
	);
}

String? homePath() {
	if (Platform.isIOS) {
		return "/var/mobile"; // welp a year with jailbroken iOS lol
	} else if (Platform.isWindows) {
		return Platform.environment['USERPROFILE'];
	}
	return Platform.environment['HOME'];
}

Future<bool> pathIsDir(String path) async { return await FileSystemEntity.isDirectory(path); }

bool showDirBar = false;
late String currDir;

Map<String, String> availableHomeDirs() {
	final home = homePath() ?? '/home';
	var ret = {
		"$home/Documents": "document",
		"$home/Music": "music_note",
		"$home/Pictures": "picture",
		"$home/Videos": "video",
		"$home/Desktop": "t_v_monitor",
		"$home/Public": "people",
		"$home/Templates": "file_template"
	};

	ret.forEach((key, value) async {
		final check = await pathIsDir(key);
		if (!check) ret.remove(key);
	});

	return ret;
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
