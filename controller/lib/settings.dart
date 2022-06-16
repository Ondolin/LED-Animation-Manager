import 'package:controller/text_input_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
    Settings({Key? key, required this.prefs}) : super(key: key);

    SharedPreferences prefs;
    
    @override
    State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

    @override
    Widget build(BuildContext context) {
        return CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(
                automaticallyImplyLeading: true,
                middle: Text("Settings")
            ),
            child: Theme(
                data: CupertinoTheme.brightnessOf(context) == Brightness.dark ? ThemeData.dark() : ThemeData.light(),
                child: Material(
                    child: SettingsList(
                        sections: [
                            SettingsSection(
                                title: "Backend",
                                tiles: [
                                    SettingsTile(
                                        title: "Backend URL",
                                        leading: Icon(CupertinoIcons.link),
                                        onPressed: (context) {
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(builder: (context) {
                                                    return TextPage(
                                                        title: "Backend URL",
                                                        currentText: widget.prefs.getString("backend_url") ?? "",
                                                        gostText: "Enter backend URL",
                                                        onTextChanged: (text) {
                                                            widget.prefs.setString("backend_url", text);
                                                        }
                                                    );
                                                })
                                            );
                                        },
                                    ),
                                    SettingsTile(
                                        title: "API Key",
                                        leading: Icon(CupertinoIcons.lock_fill),
                                        onPressed: (context) {
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(builder: (context) {
                                                    return TextPage(
                                                        title: "API key",
                                                        currentText: widget.prefs.getString("api_key") ?? "",
                                                        gostText: "Enter API key",
                                                        onTextChanged: (text) {
                                                            widget.prefs.setString("api_key", text);
                                                        }
                                                    );
                                                })
                                            );
                                        },
                                    )
                                ],
                            )
                        ],
                    )
                )
            )
        );
    }
}
