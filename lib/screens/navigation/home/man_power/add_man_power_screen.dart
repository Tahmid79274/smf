

import 'package:flutter/material.dart';
import 'package:smf/utils/extension/theme.dart';
import 'package:smf/utils/values/app_constant.dart';

class AddManpowerScreen extends StatefulWidget {
  const AddManpowerScreen({super.key});

  @override
  State<AddManpowerScreen> createState() => _AddManpowerScreenState();
}

class _AddManpowerScreenState extends State<AddManpowerScreen> {
  @override
  Widget build(BuildContext context) {
    return BasicAquaHazeBGUi(appBarTitle: AppConstant.addManpowerPlainText, child: Column());
  }
}
