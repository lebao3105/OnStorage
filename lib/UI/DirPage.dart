import 'package:fluent_ui/fluent_ui.dart';
import 'package:onstorage/UI/Utilities.dart';
import 'package:path/path.dart';
import '../Utilities.dart';
import 'DirView.dart';

class DirPage extends StatefulWidget
{
	final String startDir;
	late final List<Tab> tabs = [];

	DirPage([String? startDir])
		: this.startDir = startDir ?? homePath() ?? '/';

	@override
  State<StatefulWidget> createState() => _DirPage();
}

class _DirPage extends State<DirPage>
{
	int currentIndex = 0;

	Tab newTab(String path)
	{
		late final Tab tab;
		// TODO: Change the tab name on navigation
		DirView tabBody = DirView(where: path);

		tab = Tab(
			text: createText(basename(tabBody.where)),
			body: tabBody,
			onClosed: () =>
				setState(() {
					widget.tabs.remove(tab);
				}),
		);
		return tab;
	}

	@override
  void initState() {
    super.initState();
		widget.tabs.add(newTab(widget.startDir));
  }

	@override
  Widget build(BuildContext context)
	{
    return TabView(
			currentIndex: currentIndex,
			tabs: widget.tabs,
			closeButtonVisibility: CloseButtonVisibilityMode.onHover,
			onNewPressed:
				() => setState(() => widget.tabs.add(newTab(homePath() ?? '/'))),
			onChanged:
				(idx) => setState(() => currentIndex = idx),
			onReorder: (from, to) {
				// from FluentUI examples
				setState(() {
					if (from < to) {
						to -= 1;
					}
					final item = widget.tabs.removeAt(from);
					widget.tabs.insert(to, item);

					if (currentIndex == to) {
						currentIndex = from;
					} else if (currentIndex == from) {
						currentIndex = to;
					}
				});
			},
		);
  }
}