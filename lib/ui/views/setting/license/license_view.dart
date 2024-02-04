import 'package:flutter/material.dart';
import 'package:qchat/common/global.dart';

class LicenseView extends StatelessWidget {
  const LicenseView({super.key});

  @override
  Widget build(BuildContext context) {
    return LicensePage(
      applicationName: 'QChat',
      applicationVersion: appVersion,
      applicationIcon: Container(
        width: 64,
        height: 64,
        margin: const EdgeInsets.only(bottom: 8, top: 8),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          image: DecorationImage(
            image: AssetImage('assets/logo.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      applicationLegalese: '© 2024 QChat by liuyuxin. All Rights Reserved.',
    );
  }
}
