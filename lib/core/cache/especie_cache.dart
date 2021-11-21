import 'package:pomar_app/dao/especie_dao.dart';
import 'package:pomar_app/model/especie.dart';

class EspecieCache {
  static List<Especie>? _especies;

  static Future<List<Especie>> getEspecies() async {
    if (_especies == null) {
      EspecieDao especieDao = EspecieDao();
      _especies = await especieDao.list();
    }

    return _especies!;
  }

  static void resetCache() {
    _especies = null;
  }
}
