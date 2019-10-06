import 'package:flutter/material.dart';
import 'package:voice_change/dao/choices_peoples.dart';
import 'package:voice_change/g/utils.dart';
import 'package:voice_change/model/peoples_model.dart';
import 'package:voice_change/widgets/loading_widget.dart';
import 'package:voice_change/widgets/peoples_widget.dart';
/*
选角色页面
 */

class IndexScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IndexScreenState();
  }
}

class _IndexScreenState extends State<IndexScreen> {
  ChoicesPeoples choicesPeoples;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      ChoicesPeoples _data = await ChoicesPeoplesDao.retrievePeoples();
      setState(() {
        choicesPeoples = _data;
      });
    } catch (e) {
      // todo 此处不处理....
    }
  }

  @override
  Widget build(BuildContext context) {
    if (choicesPeoples != null && choicesPeoples.errCode == 0) {
      final paddingScreen = MediaQuery.of(context).padding;
      final l = splitList(
          choicesPeoples.data.choicePeoples, choicesPeoples.data.lineCount);
      final children = List.generate(
          l.length,
          (int index) => PeoplesNav(
                lineChoicePeoples: l[index],
              ));
      return Scaffold(
        body: ListView(
          padding: EdgeInsets.fromLTRB(paddingScreen.left, paddingScreen.top,
              paddingScreen.right, paddingScreen.bottom),
          shrinkWrap: true,
          children: children,
        ),
      );
    } else {
      return Scaffold(
        // 显示空白页
        body: ProgressDialog.buildProgressDialog(),
      );
    }
  }
}
