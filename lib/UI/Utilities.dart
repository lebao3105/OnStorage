import 'package:fluent_ui/fluent_ui.dart';

/*
 * Create Text() with Ubuntu fonts
 */

Text createText(String text, [double? size])
=> Text(text, style: TextStyle(fontFamily: 'Ubuntu', fontSize: size));

Text createBoldText(String text, [double? size])
=> Text(text, style: TextStyle(fontFamily: 'Ubuntu', fontWeight: FontWeight.bold, fontSize: size));

Text createMonoText(String text, [double? size])
=> Text(text, style: TextStyle(fontFamily: 'UbuntuMono', fontSize: size));

Text createBoldMonoText(String text, [double? size])
=> Text(text, style: TextStyle(fontFamily: 'UbuntuMono', fontWeight: FontWeight.bold, fontSize: size));


Widget emptyList() =>
	Center(
		child: Column(
			mainAxisAlignment: MainAxisAlignment.center,
			children: [
				const Icon(FluentIcons.inbox, size: 25),
				createBoldMonoText('It\'s empty here.', 25)
			]
		)
	);

/*
 * Creates a content dialog
 */
void createDialog(BuildContext context, String title, Widget? content, List<Widget>? actions)
async {
	await showDialog(
		context: context,
		builder: (ctxt) => ContentDialog(
			title: createBoldText(title),
			content: content,
			actions: actions
		)
	);
}