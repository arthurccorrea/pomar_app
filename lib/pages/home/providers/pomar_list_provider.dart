import 'package:flutter/material.dart';
import 'package:pomar_app/model/pomar.dart';

class PomarListProvider with ChangeNotifier {
  List<Pomar> _pomares = [];

  List<Pomar> get pomares => _pomares;

  set pomares(List<Pomar> pomares) {
    if (_pomares != pomares) {
      _pomares = pomares;
      notifyListeners();
    }
  }

  void addPomar(Pomar pomar) {
    _pomares.add(pomar);
    notifyListeners();
  }

  void replacePomar(Pomar pomar) {
    Pomar pomarRemover = pomares.where((p) => p.codigo == pomar.codigo).first;
    pomares.remove(pomarRemover);
    pomares.add(pomar);
    pomares.sort((a, b) => a.codigo!.compareTo(b.codigo!));
    notifyListeners();
  }
}
