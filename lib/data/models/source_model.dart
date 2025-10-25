import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'source_model.g.dart';

@HiveType(typeId: 1)
class SourceModel extends Equatable {
// region properties
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String name;
// endregion

// region constructor
  const SourceModel({this.id, required this.name});
// endregion

// region factory
  factory SourceModel.fromJson(Map<String, dynamic> json) {
    return SourceModel(
      id: json['id'],
      name: json['name'] ?? 'Unknown Source',
    );
  }
// endregion

  @override
  List<Object?> get props => [id, name];
}