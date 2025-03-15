// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'task.dart';

class TaskMapper extends ClassMapperBase<Task> {
  TaskMapper._();

  static TaskMapper? _instance;
  static TaskMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TaskMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Task';

  static String _$id(Task v) => v.id;
  static const Field<Task, String> _f$id = Field('id', _$id);
  static String _$label(Task v) => v.label;
  static const Field<Task, String> _f$label = Field('label', _$label);
  static bool _$isDone(Task v) => v.isDone;
  static const Field<Task, bool> _f$isDone =
      Field('isDone', _$isDone, opt: true, def: false);

  @override
  final MappableFields<Task> fields = const {
    #id: _f$id,
    #label: _f$label,
    #isDone: _f$isDone,
  };

  static Task _instantiate(DecodingData data) {
    return Task(
        id: data.dec(_f$id),
        label: data.dec(_f$label),
        isDone: data.dec(_f$isDone));
  }

  @override
  final Function instantiate = _instantiate;

  static Task fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Task>(map);
  }

  static Task fromJson(String json) {
    return ensureInitialized().decodeJson<Task>(json);
  }
}

mixin TaskMappable {
  String toJson() {
    return TaskMapper.ensureInitialized().encodeJson<Task>(this as Task);
  }

  Map<String, dynamic> toMap() {
    return TaskMapper.ensureInitialized().encodeMap<Task>(this as Task);
  }

  TaskCopyWith<Task, Task, Task> get copyWith =>
      _TaskCopyWithImpl<Task, Task>(this as Task, $identity, $identity);
  @override
  String toString() {
    return TaskMapper.ensureInitialized().stringifyValue(this as Task);
  }

  @override
  bool operator ==(Object other) {
    return TaskMapper.ensureInitialized().equalsValue(this as Task, other);
  }

  @override
  int get hashCode {
    return TaskMapper.ensureInitialized().hashValue(this as Task);
  }
}

extension TaskValueCopy<$R, $Out> on ObjectCopyWith<$R, Task, $Out> {
  TaskCopyWith<$R, Task, $Out> get $asTask =>
      $base.as((v, t, t2) => _TaskCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TaskCopyWith<$R, $In extends Task, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? label, bool? isDone});
  TaskCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TaskCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Task, $Out>
    implements TaskCopyWith<$R, Task, $Out> {
  _TaskCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Task> $mapper = TaskMapper.ensureInitialized();
  @override
  $R call({String? id, String? label, bool? isDone}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (label != null) #label: label,
        if (isDone != null) #isDone: isDone
      }));
  @override
  Task $make(CopyWithData data) => Task(
      id: data.get(#id, or: $value.id),
      label: data.get(#label, or: $value.label),
      isDone: data.get(#isDone, or: $value.isDone));

  @override
  TaskCopyWith<$R2, Task, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _TaskCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
