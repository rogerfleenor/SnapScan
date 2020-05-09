import 'dart:collection';
import 'package:snap_scan/api_services.dart';
import 'package:snap_scan/json_post.dart';

PartCollection partCollection;

void createCollection() {
  partCollection = new PartCollection();
}

class PartCollection {
  ListQueue<PostPart> _localParts;

  PartCollection() {
    _localParts = new ListQueue<PostPart>();
  }

  void addPart(PostPart p) {
    _localParts.addFirst(p);
    if (_localParts.length >= 15) {
      _localParts.removeLast();
    }
  }
  bool hasPart(int i) {
    return _localParts.any((part) => part.id == i);
  }

  PostPart partById(int i) {
    PostPart part = _localParts.firstWhere((part) => part.id == i,
        orElse: () => globalPart);
        if (part.id == globalPart.id) {
          part.serverImages = globalPart.serverImages;
        }
        return part;
  }

  PostPart partByIndex(int index) {
    return _localParts.elementAt(index);
  }

  get getSize {
    return _localParts.length;
  }

  ListQueue<PostPart> getCollection() {
    return _localParts;
  }
}
