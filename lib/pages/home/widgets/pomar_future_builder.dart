import 'package:flutter/cupertino.dart';
import 'package:pomar_app/core/widgets/loading_page.dart';
import 'package:pomar_app/dao/pomar_dao.dart';
import 'package:pomar_app/model/pomar.dart';
import 'package:pomar_app/pages/home/providers/pomar_list_provider.dart';
import 'package:pomar_app/pages/home/widgets/pomar_list.dart';
import 'package:provider/provider.dart';

class PomarFutureBuilder extends StatefulWidget {
  const PomarFutureBuilder({Key? key}) : super(key: key);

  @override
  _PomarFutureBuilderState createState() => _PomarFutureBuilderState();
}

class _PomarFutureBuilderState extends State<PomarFutureBuilder> {
  PomarDao pomarDao = PomarDao();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pomar>>(
      future: pomarDao.list(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.waiting) {
          return LoadingPage();
        }
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
            final _pomarListProvider =
                Provider.of<PomarListProvider>(context, listen: false);
            _pomarListProvider.pomares = snapshot.data!;
          });
          return PomarList();
        }
        return LoadingPage();
      },
    );
  }
}
