import 'package:flutter/material.dart';
import 'package:pomar_app/model/arvore.dart';
import 'package:pomar_app/model/colheita.dart';
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

  Pomar getPomar(int pomarCodigo) {
    return _pomares.where((p) => pomarCodigo == p.codigo).first;
  }

  void addArvore(Arvore arvore) {
    Pomar pomar = pomares.where((p) => p.codigo == arvore.pomarCodigo).first;
    pomar.arvores.add(arvore);
    notifyListeners();
  }

  void replaceArvore(Arvore arvore) {
    Pomar pomar = pomares.where((p) => p.codigo == arvore.pomarCodigo).first;
    Arvore arvoreRemover =
        pomar.arvores.where((a) => a.codigo == arvore.codigo).first;
    pomar.arvores.remove(arvoreRemover);
    pomar.arvores.add(arvore);
    pomar.arvores.sort((a, b) => a.codigo!.compareTo(b.codigo!));
    notifyListeners();
  }

  Arvore? getArvore(int arvoreCodigo) {
    Arvore? arvore;
    for (Pomar pomar in pomares) {
      Iterable<Arvore> arvores =
          pomar.arvores.where((a) => a.codigo == arvoreCodigo);
      if (arvores.isNotEmpty) {
        arvore = arvores.where((a) => a.codigo == arvoreCodigo).first;
      }
    }
    return arvore;
  }

  void addColheita(Colheita colheita) {
    Arvore? arvore = getArvore(colheita.arvoreCodigo);
    if (arvore != null) {
      arvore.colheitas.add(colheita);
      notifyListeners();
    }
  }

  void replaceColheita(Colheita colheita) {
    Arvore? arvore = getArvore(colheita.arvoreCodigo);
    if (arvore != null) {
      Colheita colheitaRemover =
          arvore.colheitas.where((c) => c.codigo == colheita.codigo).first;
      arvore.colheitas.remove(colheitaRemover);
      arvore.colheitas.add(colheita);
      arvore.colheitas.sort((a, b) => a.codigo!.compareTo(b.codigo!));
      notifyListeners();
    }
  }
}
