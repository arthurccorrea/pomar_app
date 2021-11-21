import 'package:flutter/material.dart';
import 'package:pomar_app/model/especie.dart';

class EspecieListProvider with ChangeNotifier {
  List<Especie> especies = [];

  List<Especie> get pomares => especies;

  set pomares(List<Especie> especies) {
    if (especies != especies) {
      especies = especies;
      notifyListeners();
    }
  }

  void addPomar(Especie especie) {
    especies.add(especie);
    notifyListeners();
  }

  void replaceEspecie(Especie especie) {
    Especie pomarRemover =
        especies.where((p) => p.codigo == especie.codigo).first;
    pomares.remove(pomarRemover);
    pomares.add(especie);
    pomares.sort((a, b) => a.codigo!.compareTo(b.codigo!));
    notifyListeners();
  }
}
