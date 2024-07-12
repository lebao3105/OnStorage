import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Scaffold, AppBar;
import 'package:onstorage/UI/Utilities.dart';
import 'package:onstorage/Utilities.dart';
import 'package:onstorage/l10n/app_localizations.dart';
import 'package:settings_ui/settings_ui.dart';

class AboutPage extends StatelessWidget
{
	@override
  Widget build(BuildContext context) {
		
    return Scaffold(
			appBar: AppBar(
				title: createBoldText(AppLocalizations.of(context)!.about_title)
			),
			body: SettingsList(
				sections: [
					SettingsSection(
						title: createText('BUILD'),
						tiles: [
							SettingsTile(
								title: createText('Version'),
								value: createText(ver),
							),
							SettingsTile(
								title: createText('Type'),
								value:
									createText(
										kDebugMode ? 'Debug' :
										kProfileMode ? 'Profile' : 'Release'
									)
							)
						]
					),

					SettingsSection(
						title: createText('HELPER'),
						tiles: [
							SettingsTile(
								title: createText('About'),
								value: createText(stdardout.join()),
								description: createText('The text above can be got by adding about / a argument')
							)
						]
					)
				])
		);
  }
}