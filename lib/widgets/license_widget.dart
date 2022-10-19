import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pomodoro_app/assets/custom_theme.dart';

class LicensesWidget extends StatefulWidget {
  const LicensesWidget({Key? key}) : super(key: key);

  @override
  _LicensesWidgetState createState() => _LicensesWidgetState();
}

class _LicensesWidgetState extends State<LicensesWidget> {
  final List<Widget> _licenses = <Widget>[];
  final Map<String, List<Widget>> _licenseContent = {};
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _initLicenses();
  }

  Future<void> _initLicenses() async {
    await for (final LicenseEntry license in LicenseRegistry.licenses) {
      List<Widget>? tempSubWidget = [];
      final List<LicenseParagraph> paragraphs =
          await SchedulerBinding.instance.scheduleTask<List<LicenseParagraph>>(
        license.paragraphs.toList,
        Priority.animation,
        debugLabel: 'License',
      );
      if (_licenseContent.containsKey(license.packages.join(', '))) {
        tempSubWidget =
            _licenseContent[license.packages.join(', ')];
      }
      for (final LicenseParagraph paragraph in paragraphs) {
        if (paragraph.indent == LicenseParagraph.centeredIndent) {
          tempSubWidget?.add(Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              paragraph.text,
              style: const TextStyle(),
            ),
          ));
        } else {
          tempSubWidget?.add(Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              paragraph.text,
            ),
          ));
        }
      }
      tempSubWidget?.add(const Divider());
      _licenseContent[license.packages.join(', ')] = tempSubWidget!;
    }

    _licenseContent.forEach((String key, List<Widget> value) {
      int count = 0;
      for (final Widget element in value) {
        if (element.runtimeType == Divider) {
          count += 1;
        }
      }
      _licenses.add(ExpansionTile(
        title: Text(
          key,
          style: PomodoroValues.customTextTheme.bodyText1,
        ),
        subtitle: Text(
          '$count Lizenzen',
        ),
        children: <Widget>[...value],
      ));
    });

    setState(() {
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: !_loaded
          ? Center(
              child: CircularProgressIndicator(
              color: PomodoroValues.mainColor,
            ))
          : ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: _licenses.length,
              separatorBuilder: (BuildContext context, int index) => const Divider(),
              itemBuilder: (BuildContext context, int index) {
                return _licenses.elementAt(index);
              },
            ),
    );
  }
}
