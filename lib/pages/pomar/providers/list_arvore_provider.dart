import 'package:flutter/cupertino.dart';
import 'package:pomar_app/model/arvore.dart';

class ListArvoreProvider with ChangeNotifier {
  List<Arvore> _arvores = [];

  List<Arvore> get arvores => _arvores;

  set arvores(List<Arvore> arvores) {
    if (_arvores != arvores) {
      _arvores = arvores;
      notifyListeners();
    }
  }

  void addArvore(Arvore arvore) {
    _arvores.add(arvore);
    notifyListeners();
  }

  void replaceArvore(Arvore arvore) {
    Arvore arvoreRemover = _arvores.where((p) => p.codigo == arvore.codigo).first;
    _arvores.remove(arvoreRemover);
    _arvores.add(arvore);
    _arvores.sort((a, b) => a.codigo!.compareTo(b.codigo!));
    notifyListeners();
  }
}