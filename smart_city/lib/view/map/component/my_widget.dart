import 'package:flutter/cupertino.dart';

import '../../../controller/node/get_node_api.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  Future<void>? _future; // Initialize with null

  @override
  void initState() {
    super.initState();
    _future = _getNode(); // Update _future here
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future, // Use _future here
      builder: (context, snapshot) {
        return SizedBox();
      },
    );
  }

  Future<bool> _getNode() async {
    GetNodeApi getNodeApi = GetNodeApi(nodeId: 758);
    try {
      await getNodeApi.call();
      return true;
    } catch (e) {
      return false;
    }
  }
}
