import 'dart:io';

import 'package:flutter/material.dart' show Scaffold, AppBar, showLicensePage;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:settings_ui/settings_ui.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:onstorage/Utilities.dart';
import 'package:go_router/go_router.dart';
import 'package:system_theme/system_theme.dart';
import 'package:url_launcher/link.dart';

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

		return Scaffold(
			appBar: AppBar(title: createBoldText('Languages')),
			body: Column(
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
							itemBuilder: (ctxt, index) {
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
			)
		);
	}
}

class SettingsPage extends StatelessWidget
{

	@override
	Widget build(BuildContext context)
	{
		return Scaffold(
			appBar: AppBar(title: createBoldText('Settings', null)),
			body: SettingsList(
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
							),
							SettingsTile.navigation(
								title: createText('Personalization'),
								leading: const Icon(FluentIcons.personalize),
								trailing: const Icon(FluentIcons.arrow_up_right)
							)
						]
					),

					SettingsSection(
						title: createText('About'),
						tiles: <SettingsTile>[
							SettingsTile.navigation(
								title: createText('About this app'),
								leading: const Icon(FluentIcons.info),
								trailing: const Icon(FluentIcons.arrow_up_right),
								onPressed: (ctxt) {
									showDialog(
										context: ctxt,
										builder: (ctxt2) => ContentDialog(
											title: createBoldText('About this app'),
											content: Column(
												mainAxisSize: MainAxisSize.min,
												children: [
													Text(
													'''
													OnStorage version $ver\n
													C++ helper: ${stdardout.join('\n')}
													'''),
												]
											),
											actions: [
												Link(
													uri: Uri.parse('https://github.com/lebao3105/onstorage'),
													builder: (ctxt, open) { return HyperlinkButton(child: createText('Source code'), onPressed: open); }
												),
												FilledButton(child: const Text('Close'), onPressed: () => context.pop())
											]
										)
									);
								},
							),
							SettingsTile.navigation(
								title: createText('Licenses'),
								leading: const Icon(FluentIcons.bookmarks),
								trailing: const Icon(FluentIcons.arrow_up_right),
								onPressed: (ctxt) => showLicensePage(context: ctxt, useRootNavigator: true)
							)
						]
					)
				]
			),
		);
	}
}
