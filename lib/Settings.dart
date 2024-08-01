import 'package:flutter/material.dart' show Scaffold, AppBar, showLicensePage;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:onstorage/UI/Utilities.dart';
import 'package:settings_ui/settings_ui.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:onstorage/Utilities.dart';
import 'package:go_router/go_router.dart';


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
								onPressed: (ctxt) => ctxt.push('/settings/languages'),
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
								onPressed: (ctxt) => changes.navSelectedIdx = 6,
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
