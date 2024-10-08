import 'package:flutter/material.dart' show Scaffold, AppBar, showLicensePage;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart' as foundation;

import 'package:onstorage/UI/SettingPages/LanguagesView.dart';
import 'package:onstorage/UI/Utilities.dart';
import 'package:settings_ui/settings_ui.dart';

import '../l10n/app_localizations.dart';
import 'package:onstorage/Utilities.dart';
import 'package:go_router/go_router.dart';

enum ViewSizes
{
	KBs, MBs, GBs
}

enum ViewListingType
{
	List, Grid, Tree
}

class SettingsPage extends StatelessWidget
{

	@override
	Widget build(BuildContext context)
	{
		final loc = AppLocalizations.of(context)!;

		return Scaffold(
			appBar:
				AppBar(title: createBoldText(loc.settings)),
			body:
				SettingsList(
					sections: [

						// BEGIN GENERAL SECTION
						SettingsSection(
							title: Text(loc.settings_general),
							tiles: [
								// BEGIN LANGUAGES PAGE
								SettingsTile.navigation(
									title: Text(loc.langs),
									leading: const Icon(FluentIcons.globe),
									onPressed: (ctxt) => ctxt.push('/settings/languages'),
									trailing: const Icon(FluentIcons.arrow_up_right)
								),
								// END LANGUAGES PAGE

								// BEGIN PERSONALIZATION PAGE
								SettingsTile.navigation(
									title: createText(loc.settings_personalization),
									leading: const Icon(FluentIcons.personalize),
									trailing: const Icon(FluentIcons.arrow_up_right),
									onPressed: (ctxt) => ctxt.push('/settings/personalizations'),
								)
								// END PERSONALIZATION PAGE
							]
						),
						// END GENERAL SECTION

						SettingsSection(
							title: createText(loc.settings_view),
							tiles: [
								SettingsTile(
									title: createText(loc.item_size),
									trailing: ComboBox<ViewSizes>(
										items: ViewSizes.values.map(
											(e) => ComboBoxItem(
												child: createText(e.name),
												value: e
											)
										).toList(),
										onChanged: (which) {},
									),
								),

								SettingsTile(
									title: createText('Default directory listing type'),
									trailing: ComboBox<ViewListingType>(
										items: [
											ComboBoxItem(
												child: Text("List"),
												value: ViewListingType.List
											),
											ComboBoxItem(
												child: Text("Grid"),
												value: ViewListingType.List
											),
											ComboBoxItem(
												child: Text("Tree"),
												value: ViewListingType.List
											),
										],
										onChanged: (which) {},
									)
								)
							]
						),

						// BEGIN ABOUT SECTION
						SettingsSection(
							title: createText(loc.settings_about),
							tiles: [
								// ABOUT
								SettingsTile.navigation(
									title: createText(loc.about_title),
									leading: const Icon(FluentIcons.info),
									trailing: const Icon(FluentIcons.arrow_up_right),
									onPressed: (ctxt) => ctxt.push('/about'),
								),

								// LICENSES
								SettingsTile.navigation(
									title: createText(loc.licenses),
									leading: const Icon(FluentIcons.bookmarks),
									trailing: const Icon(FluentIcons.arrow_up_right),
									onPressed: (ctxt) => showLicensePage(context: ctxt, useRootNavigator: true)
								)
							]
						)
						// END ABOUT SECTION
					]
				),
		);
	}
}
