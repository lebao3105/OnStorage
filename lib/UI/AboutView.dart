import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show Scaffold, AppBar;
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Utilities.dart';
import '../l10n/app_localizations.dart';
import '../Utilities.dart';
import '../Infos.dart';

class AboutPage extends StatelessWidget
{
	@override
  Widget build(BuildContext context)
	{
		final loc = AppLocalizations.of(context)!;
	
    return Scaffold(
			appBar: AppBar(
				title: createBoldText(loc.about_title)
			),
			body: SettingsList(
				sections: [
					SettingsSection(
						title: createText('BUILD'),
						tiles: [
							SettingsTile(
								title: createText('Version'),
								value: createText(APPVER),
							),
							SettingsTile(
								title: createText('Type'),
								value:
									createText(
										kDebugMode ? 'Debug' :
										kProfileMode ? 'Profile' : 'Release'
									)
							),
							SettingsTile(
								title: createText('Website'),
								value: Text('Open link in browser'),
								onPressed: (ctxt) => launchUrl(Uri.parse(HOMEPAGE)),
							)
						]
					),

					SettingsSection(
						title: createText('CREDIT'),
						tiles: [
							SettingsTile(
								title: createText('Le Bao Nguyen'),
								value: createText('Main developer'),
								onPressed: (ctxt) => launchUrl(Uri.parse('https://github.com/lebao3105')),
							)
						]
					)
				])
		);
  }
}