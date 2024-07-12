import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show Scaffold, AppBar;
import 'package:onstorage/UI/Utilities.dart';
import 'package:onstorage/Utilities.dart';

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
									onSelectionChange: (_) async { await prefs.setInt('selectedLanguage', index); changes.notifyListeners(); }
								);
							}
						)
					)
				]
			)
		);
	}
}