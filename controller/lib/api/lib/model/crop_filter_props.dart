//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CropFilterProps {
  /// Returns a new [CropFilterProps] instance.
  CropFilterProps({
    required this.right,
    required this.left,
  });

  int right;

  int left;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CropFilterProps &&
     other.right == right &&
     other.left == left;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (right.hashCode) +
    (left.hashCode);

  @override
  String toString() => 'CropFilterProps[right=$right, left=$left]';

  Map<String, dynamic> toJson() {
    final _json = <String, dynamic>{};
      _json[r'right'] = right;
      _json[r'left'] = left;
    return _json;
  }

  /// Returns a new [CropFilterProps] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CropFilterProps? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CropFilterProps[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CropFilterProps[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CropFilterProps(
        right: mapValueOfType<int>(json, r'right')!,
        left: mapValueOfType<int>(json, r'left')!,
      );
    }
    return null;
  }

  static List<CropFilterProps>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CropFilterProps>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CropFilterProps.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CropFilterProps> mapFromJson(dynamic json) {
    final map = <String, CropFilterProps>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CropFilterProps.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CropFilterProps-objects as value to a dart map
  static Map<String, List<CropFilterProps>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CropFilterProps>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CropFilterProps.listFromJson(entry.value, growable: growable,);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'right',
    'left',
  };
}

