// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'tasks_ui_state.dart';

class TasksUIStateMapper extends ClassMapperBase<TasksUIState> {
  TasksUIStateMapper._();

  static TasksUIStateMapper? _instance;
  static TasksUIStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TasksUIStateMapper._());
      TaskMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'TasksUIState';

  static List<Task> _$tasks(TasksUIState v) => v.tasks;
  static const Field<TasksUIState, List<Task>> _f$tasks =
      Field('tasks', _$tasks, opt: true, def: const []);

  @override
  final MappableFields<TasksUIState> fields = const {
    #tasks: _f$tasks,
  };

  static TasksUIState _instantiate(DecodingData data) {
    return TasksUIState(tasks: data.dec(_f$tasks));
  }

  @override
  final Function instantiate = _instantiate;

  static TasksUIState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TasksUIState>(map);
  }

  static TasksUIState fromJson(String json) {
    return ensureInitialized().decodeJson<TasksUIState>(json);
  }
}

mixin TasksUIStateMappable {
  String toJson() {
    return TasksUIStateMapper.ensureInitialized()
        .encodeJson<TasksUIState>(this as TasksUIState);
  }

  Map<String, dynamic> toMap() {
    return TasksUIStateMapper.ensureInitialized()
        .encodeMap<TasksUIState>(this as TasksUIState);
  }

  TasksUIStateCopyWith<TasksUIState, TasksUIState, TasksUIState> get copyWith =>
      _TasksUIStateCopyWithImpl<TasksUIState, TasksUIState>(
          this as TasksUIState, $identity, $identity);
  @override
  String toString() {
    return TasksUIStateMapper.ensureInitialized()
        .stringifyValue(this as TasksUIState);
  }

  @override
  bool operator ==(Object other) {
    return TasksUIStateMapper.ensureInitialized()
        .equalsValue(this as TasksUIState, other);
  }

  @override
  int get hashCode {
    return TasksUIStateMapper.ensureInitialized()
        .hashValue(this as TasksUIState);
  }
}

extension TasksUIStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TasksUIState, $Out> {
  TasksUIStateCopyWith<$R, TasksUIState, $Out> get $asTasksUIState =>
      $base.as((v, t, t2) => _TasksUIStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TasksUIStateCopyWith<$R, $In extends TasksUIState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Task, TaskCopyWith<$R, Task, Task>> get tasks;
  $R call({List<Task>? tasks});
  TasksUIStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TasksUIStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TasksUIState, $Out>
    implements TasksUIStateCopyWith<$R, TasksUIState, $Out> {
  _TasksUIStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TasksUIState> $mapper =
      TasksUIStateMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Task, TaskCopyWith<$R, Task, Task>> get tasks =>
      ListCopyWith(
          $value.tasks, (v, t) => v.copyWith.$chain(t), (v) => call(tasks: v));
  @override
  $R call({List<Task>? tasks}) =>
      $apply(FieldCopyWithData({if (tasks != null) #tasks: tasks}));
  @override
  TasksUIState $make(CopyWithData data) =>
      TasksUIState(tasks: data.get(#tasks, or: $value.tasks));

  @override
  TasksUIStateCopyWith<$R2, TasksUIState, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _TasksUIStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
