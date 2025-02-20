// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'chroma_counter_ui_state.dart';

class ChromaCounterUIStateMapper extends ClassMapperBase<ChromaCounterUIState> {
  ChromaCounterUIStateMapper._();

  static ChromaCounterUIStateMapper? _instance;
  static ChromaCounterUIStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChromaCounterUIStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ChromaCounterUIState';

  static Color _$backgroundColor(ChromaCounterUIState v) => v.backgroundColor;
  static const Field<ChromaCounterUIState, Color> _f$backgroundColor =
      Field('backgroundColor', _$backgroundColor, opt: true, def: Colors.blue);
  static BorderRadius _$borderRadius(ChromaCounterUIState v) => v.borderRadius;
  static const Field<ChromaCounterUIState, BorderRadius> _f$borderRadius =
      Field('borderRadius', _$borderRadius, opt: true, def: BorderRadius.zero);
  static int _$count(ChromaCounterUIState v) => v.count;
  static const Field<ChromaCounterUIState, int> _f$count =
      Field('count', _$count, opt: true, def: 0);
  static int _$milestone(ChromaCounterUIState v) => v.milestone;
  static const Field<ChromaCounterUIState, int> _f$milestone =
      Field('milestone', _$milestone, mode: FieldMode.member);

  @override
  final MappableFields<ChromaCounterUIState> fields = const {
    #backgroundColor: _f$backgroundColor,
    #borderRadius: _f$borderRadius,
    #count: _f$count,
    #milestone: _f$milestone,
  };

  static ChromaCounterUIState _instantiate(DecodingData data) {
    return ChromaCounterUIState(
        backgroundColor: data.dec(_f$backgroundColor),
        borderRadius: data.dec(_f$borderRadius),
        count: data.dec(_f$count));
  }

  @override
  final Function instantiate = _instantiate;

  static ChromaCounterUIState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChromaCounterUIState>(map);
  }

  static ChromaCounterUIState fromJson(String json) {
    return ensureInitialized().decodeJson<ChromaCounterUIState>(json);
  }
}

mixin ChromaCounterUIStateMappable {
  String toJson() {
    return ChromaCounterUIStateMapper.ensureInitialized()
        .encodeJson<ChromaCounterUIState>(this as ChromaCounterUIState);
  }

  Map<String, dynamic> toMap() {
    return ChromaCounterUIStateMapper.ensureInitialized()
        .encodeMap<ChromaCounterUIState>(this as ChromaCounterUIState);
  }

  ChromaCounterUIStateCopyWith<ChromaCounterUIState, ChromaCounterUIState,
          ChromaCounterUIState>
      get copyWith => _ChromaCounterUIStateCopyWithImpl(
          this as ChromaCounterUIState, $identity, $identity);
  @override
  String toString() {
    return ChromaCounterUIStateMapper.ensureInitialized()
        .stringifyValue(this as ChromaCounterUIState);
  }

  @override
  bool operator ==(Object other) {
    return ChromaCounterUIStateMapper.ensureInitialized()
        .equalsValue(this as ChromaCounterUIState, other);
  }

  @override
  int get hashCode {
    return ChromaCounterUIStateMapper.ensureInitialized()
        .hashValue(this as ChromaCounterUIState);
  }
}

extension ChromaCounterUIStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChromaCounterUIState, $Out> {
  ChromaCounterUIStateCopyWith<$R, ChromaCounterUIState, $Out>
      get $asChromaCounterUIState =>
          $base.as((v, t, t2) => _ChromaCounterUIStateCopyWithImpl(v, t, t2));
}

abstract class ChromaCounterUIStateCopyWith<
    $R,
    $In extends ChromaCounterUIState,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({Color? backgroundColor, BorderRadius? borderRadius, int? count});
  ChromaCounterUIStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _ChromaCounterUIStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChromaCounterUIState, $Out>
    implements ChromaCounterUIStateCopyWith<$R, ChromaCounterUIState, $Out> {
  _ChromaCounterUIStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChromaCounterUIState> $mapper =
      ChromaCounterUIStateMapper.ensureInitialized();
  @override
  $R call({Color? backgroundColor, BorderRadius? borderRadius, int? count}) =>
      $apply(FieldCopyWithData({
        if (backgroundColor != null) #backgroundColor: backgroundColor,
        if (borderRadius != null) #borderRadius: borderRadius,
        if (count != null) #count: count
      }));
  @override
  ChromaCounterUIState $make(CopyWithData data) => ChromaCounterUIState(
      backgroundColor: data.get(#backgroundColor, or: $value.backgroundColor),
      borderRadius: data.get(#borderRadius, or: $value.borderRadius),
      count: data.get(#count, or: $value.count));

  @override
  ChromaCounterUIStateCopyWith<$R2, ChromaCounterUIState, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _ChromaCounterUIStateCopyWithImpl($value, $cast, t);
}
