

import 'package:isar_community/isar.dart';

part 'collection_model.g.dart';

@collection
class CollectionModel {
  Id id = Isar.autoIncrement;

  late String name;

  String? description;

  late DateTime createdAt;

  late DateTime updatedAt;

  String? color;

  String? icon;
}