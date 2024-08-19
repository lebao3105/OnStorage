import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show Scaffold, AppBar;
import 'package:flutter_acrylic/window_effect.dart';
import 'package:onstorage/UI/Settings.dart';
import 'package:onstorage/UI/Utilities.dart';
import 'package:onstorage/Utilities.dart';
import 'package:onstorage/l10n/app_localizations.dart';
import 'package:settings_ui/settings_ui.dart';

enum ColorSchemes {
	Light, Dark, System
}

class PersonalizationsPage extends StatefulWidget
{
	@override
  State<StatefulWidget> createState() => _PersonalizationsPage();
}

class _PersonalizationsPage extends State<PersonalizationsPage>
{
	@override
	Widget build(BuildContext context)
	{
		final loc = AppLocalizations.of(context)!;

		// TODO: Translations
		return Scaffold(
			appBar: AppBar(title: createBoldText(loc.settings_personalization)),
			body: SettingsList(
				sections: [
					SettingsSection(
						title: createText('Colors'),
						tiles: [
							SettingsTile(
								title: createText('Color scheme'),
								trailing: ComboBox<ColorSchemes>(
									items: [
										ComboBoxItem(child: createText('Dark'), value: ColorSchemes.Dark),
										ComboBoxItem(child: createText('Light'), value: ColorSchemes.Light),
										ComboBoxItem(child: createText('Follow system'), value: ColorSchemes.System)
									],
									onChanged: (item) {},
								)
							)
						]
					),

					SettingsSection(
						title: createText('More'),
						tiles: [
							SettingsTile(
								title: createText('Window effects'),
								trailing: ComboBox<WindowEffect>(
									items: () {
										final List<WindowEffect> allItems = List.from(WindowEffect.values);
										if (Platform.isLinux)
										{
											allItems.remove(WindowEffect.acrylic);
											allItems.remove(WindowEffect.mica);
											allItems.remove(WindowEffect.aero);
										}

										return allItems.map(
											(e) => ComboBoxItem(
												child: createText(e.name.toCapitalized()),
												value: e
											)
										).toList();
									}(),
									onChanged: (value) => windowEffect = value!.name,
									value: getFunctions.getByString(windowEffect)
								)
							)
						]
					)
				],
			),
		);
	}
}