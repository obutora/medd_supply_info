import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LicenseScreen extends StatelessWidget {
  const LicenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // PackageInfo packageInfo = await PackageInfo.fromPlatform();

// String appName = packageInfo.appName;
// String packageName = packageInfo.packageName;
// String version = packageInfo.version;
    return MaterialApp(
      home: FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done ||
                snapshot.hasError ||
                snapshot.data == null) {
              return SizedBox();
            }

            final packageInfo = snapshot.data!;

            return LicensePage(
              applicationName: 'Reimei', // アプリの名前
              applicationVersion: packageInfo.version, // バージョン
              // TODO: 後で設定
              // applicationIcon: Icon(Icons.car_repair), // アプリのアイコン
              applicationLegalese: '©2023 Kunihiko Haga.', // 著作権表示
            );
          }),
    );
  }
}
