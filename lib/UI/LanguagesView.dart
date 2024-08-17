import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show Scaffold, AppBar;
import 'package:onstorage/UI/Settings.dart';
import 'package:onstorage/UI/Utilities.dart';
import 'package:onstorage/Utilities.dart';
import 'package:onstorage/l10n/app_localizations.dart';
import 'package:settings_ui/settings_ui.dart';

class LanguagesPage extends StatefulWidget
{
	@override
  State<StatefulWidget> createState() => _LanguagesPage();
}

class _LanguagesPage extends State<LanguagesPage>
{
	@override
	Widget build(BuildContext context)
	{
		/// Supported languages in OnStorage.
		/// Please keep this sorted alphabetically,
		/// and up-to-date with the current translations.
		final
		Map<String, List<List<String>>>
		supported_languages = {
			'e': [
				['English', 'en']
			],
			'v': [
				['Vietnamese', 'vi']
			]
		};

		final loc = AppLocalizations.of(context)!;

		return Scaffold(
			appBar: AppBar(title: createBoldText(loc.langs)),
			body: SettingsList(
				sections: supported_languages.keys.map(
					(key) => SettingsSection(
						title: createText(key.toUpperCase()),
						tiles: supported_languages[key]!.map(
							(language) => SettingsTile(
								title: createText(language.first),
								trailing: Checkbox(
									checked: (selectedLanguage == language.last),
									onChanged: null,
								),
								onPressed: (_) => setState(() => selectedLanguage = language.last),
							)
						).toList(),
					)
				).toList()
			)
		);
	}
}