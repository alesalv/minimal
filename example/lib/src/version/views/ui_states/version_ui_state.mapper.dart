// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'version_ui_state.dart';

class VersionUIStateMapper extends ClassMapperBase<VersionUIState> {
  VersionUIStateMapper._();

  static VersionUIStateMapper? _instance;
  static VersionUIStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VersionUIStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'VersionUIState';

  static String _$version(VersionUIState v) => v.version;
  static const Field<VersionUIState, String> _f$version =
      Field('version', _$version, opt: true, def: '');

  @override
  final MappableFields<VersionUIState> fields = const {
    #version: _f$version,
  };

  static VersionUIState _instantiate(DecodingData data) {
    return VersionUIState(version: data.dec(_f$version));
  }

  @override
  final Function instantiate = _instantiate;

  static VersionUIState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<VersionUIState>(map);
  }

  static VersionUIState fromJson(String json) {
    return ensureInitialized().decodeJson<VersionUIState>(json);
  }
}

mixin VersionUIStateMappable {
  String toJson() {
    return VersionUIStateMapper.ensureInitialized()
        .encodeJson<VersionUIState>(this as VersionUIState);
  }

  Map<String, dynamic> toMap() {
    return VersionUIStateMapper.ensureInitialized()
        .encodeMap<VersionUIState>(this as VersionUIState);
  }

  VersionUIStateCopyWith<VersionUIState, VersionUIState, VersionUIState>
      get copyWith => _VersionUIStateCopyWithImpl(
          this as VersionUIState, $identity, $identity);
  @override
  String toString() {
    return VersionUIStateMapper.ensureInitialized()
        .stringifyValue(this as VersionUIState);
  }

  @override
  bool operator ==(Object other) {
    return VersionUIStateMapper.ensureInitialized()
        .equalsValue(this as VersionUIState, other);
  }

  @override
  int get hashCode {
    return VersionUIStateMapper.ensureInitialized()
        .hashValue(this as VersionUIState);
  }
}

extension VersionUIStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, VersionUIState, $Out> {
  VersionUIStateCopyWith<$R, VersionUIState, $Out> get $asVersionUIState =>
      $base.as((v, t, t2) => _VersionUIStateCopyWithImpl(v, t, t2));
}

abstract class VersionUIStateCopyWith<$R, $In extends VersionUIState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? version});
  VersionUIStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _VersionUIStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, VersionUIState, $Out>
    implements VersionUIStateCopyWith<$R, VersionUIState, $Out> {
  _VersionUIStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<VersionUIState> $mapper =
      VersionUIStateMapper.ensureInitialized();
  @override
  $R call({String? version}) =>
      $apply(FieldCopyWithData({if (version != null) #version: version}));
  @override
  VersionUIState $make(CopyWithData data) =>
      VersionUIState(version: data.get(#version, or: $value.version));

  @override
  VersionUIStateCopyWith<$R2, VersionUIState, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _VersionUIStateCopyWithImpl($value, $cast, t);
}
