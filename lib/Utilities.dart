import 'package:fluent_ui/fluent_ui.dart';
import 'dart:io' show FileSystemEntity, Platform;
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;

const ver = 1.0;

Text createText(String text)
{
	return Text(text, style: const TextStyle(fontFamily: 'Ubuntu'));
}

Text createBoldText(String text)
{
	return Text(text, style: const TextStyle(fontFamily: 'Ubuntu', fontWeight: FontWeight.bold));
}

Text createMonoText(String text)
{
	return Text(text, style: const TextStyle(fontFamily: 'UbuntuMono'));
}

Text createBoldMonoText(String text)
{
	return Text(text, style: const TextStyle(fontFamily: 'UbuntuMono', fontWeight: FontWeight.bold));
}

Widget emptyList()
{
	return Center(
		child: Column(
			mainAxisAlignment: MainAxisAlignment.end,
			children: [
				const Icon(FluentIcons.field_empty),
				createBoldMonoText('It\'s empty here.')
			],
		)
	);
}

String? homePath() {
	if (Platform.isLinux || Platform.isMacOS) {
		return Platform.environment['HOME'];
	} else if (Platform.isIOS) {
		return "/var/mobile"; // welp a year with jailbroken iOS lol
	} else if (Platform.isWindows) {
		return Platform.environment['USERPROFILE'];
	}
	return null; // TODO
}

Future<bool> pathIsDir(String path) async { return ! await FileSystemEntity.isFile(path); }

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


