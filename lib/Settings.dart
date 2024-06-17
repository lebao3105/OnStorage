import 'package:flutter/material.dart' show Scaffold, AppBar, showLicensePage;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:settings_ui/settings_ui.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swifile/Utilities.dart';
import 'package:go_router/go_router.dart';

class LanguagesPage extends StatelessWidget
{

	/* Supported translations.
	   New translators: please update these until I found a better way
	   Update the language code in lang_codes to MATCH WITH the corresponding
	   language in langs. */
	
	static const langs = [ "English", "Vietnamese" ];
	static const lang_codes = [ "en", "vi" ];
	final selectedIdx = selectedLanguage;

	@override
	Widget build(BuildContext context) {
		if (langs.length != lang_codes.length)
		{
			showDialog(
				context: context,
				builder: (ctx) => const ContentDialog(
					title: Text('Please report this!'),
					content: Text(
						'The language and language code lists don\'t have the same number of items!\n'
						'Report this in the project\'s source code page'
					),
					actions: [
						FilledButton(onPressed: null, child: Text('Report'))
					]
				)
			);
		}

		return ScaffoldPage.scrollable(
			header: AppBar(title: createText('Languages')),
			children: [
				AutoSuggestBox<String>(
					items: List.generate(lang_codes.length, (i) {
						return AutoSuggestBoxItem(
							value: lang_codes[i], label: langs[i]
						);
					})
				),

				Expanded(
					child: ListView.builder(
						shrinkWrap: true,
						itemCount: langs.length,
						itemBuilder: (context, index) {
							return ListTile.selectable(
								title: Text(langs[index]),
								selected: selectedIdx == index,
								selectionMode: ListTileSelectionMode.single,
								onSelectionChange: (_) async { await prefs.setInt('selectedLanguage', index); }
							);
						}
					)
				)
			]
		);
	}
}

class SettingsPage extends StatelessWidget
{
	const SettingsPage({super.key});

	@override
	Widget build(BuildContext context)
	{
		return Scaffold(
			appBar: AppBar(title: const Text('Settings')),
			body: SettingsList(
				platform: DevicePlatform.device,
				sections: [
					SettingsSection(
						title: const Text('General'),
						tiles: <SettingsTile>[
							SettingsTile.navigation(
								title: const Text('Languages'),
								leading: const Icon(FluentIcons.globe),
								onPressed: (ctxt) {
									ctxt.push('/settings/languages');
								},
								trailing: const Icon(FluentIcons.arrow_up_right)
							)
						]
					),
					SettingsSection(
						title: const Text('About'),
						tiles: <SettingsTile>[
							SettingsTile.navigation(
								title: const Text('About this app'),
								leading: const Icon(FluentIcons.info),
								trailing: const Icon(FluentIcons.arrow_up_right),
								onPressed: (ctxt) {
									showDialog(
										context: ctxt,
										builder: (ctxt) => ContentDialog(
											title: const Text('About this app'),
											content: const Column(
												mainAxisSize: MainAxisSize.min,
												children: [
													Text('Swifile'),
													Text('Version $ver'),
													Text('Build date: ')
												]
											),
											actions: [
												Button(
													child: const Text('Licenses'),
													onPressed: () => showLicensePage(context: ctxt, useRootNavigator: true)
												),
												Button(child: const Text('Soruce code'), onPressed: () {}),
												FilledButton(child: const Text('Close'), onPressed: () => Navigator.pop(ctxt))
											]
										)
									);
								},
							)
						]
					)
				]
			),
		);
	}
}
