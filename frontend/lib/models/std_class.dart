import 'package:flutter/material.dart';

class STD {
  final String _id;

  final String _name;

  final String _profilepic;

  final String _linkedin;

  final String _position;

  STD(this._id, this._name, this._profilepic, this._linkedin, this._position);

  String get id => _id;

  String get name => _name;

  String get position => _position;

  String get linkedin => _linkedin;

  String get profilepic => _profilepic;
}
