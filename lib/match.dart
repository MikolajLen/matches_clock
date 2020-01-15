import 'dart:math';

import 'package:flutter/material.dart';

const matchAsset = 'images/b_p.png';
const matchRatio = 0.126;
const multiplier = 8;
const maxHeight = 200.0;

class Match {
  const Match({this.paddingTop, this.paddingLeft, this.rotation = 0});

  factory Match.copyWith(Match oldMatch, double offset) => Match(
      paddingTop: oldMatch.paddingTop,
      paddingLeft: oldMatch.paddingLeft + offset,
      rotation: oldMatch.rotation);

  final double paddingTop;
  final double paddingLeft;
  final double rotation;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Match &&
          runtimeType == other.runtimeType &&
          paddingTop == other.paddingTop &&
          paddingLeft == other.paddingLeft &&
          rotation == other.rotation;

  @override
  int get hashCode =>
      paddingTop.hashCode ^ paddingLeft.hashCode ^ rotation.hashCode;
}

class MatchesCreator {
  double matchWidth;
  double matchHeight;
  double _topPadding;
  double _leftPadding;
  double center;
  double bottom;
  List<Match> matches;

  void calculateMatchesSize(Size screenSize) {
    const divider = (5 * multiplier) + 14;
    var supposedWidth = screenSize.width / divider;
    if ((supposedWidth * (5 + 2 * multiplier)) > screenSize.height) {
      supposedWidth = screenSize.height / (5 + (2 * multiplier));
      _topPadding = supposedWidth;
      _leftPadding =
          (screenSize.width - (supposedWidth * ((5 * multiplier) + 14))) / 2;
      matchWidth = supposedWidth;
      matchHeight = multiplier * supposedWidth;
    } else if ((multiplier * supposedWidth) > maxHeight) {
      matchHeight = maxHeight;
      matchWidth = maxHeight / multiplier;
      _topPadding =
          (screenSize.height - (matchWidth * (5 + 2 * multiplier))) / 2;
      _leftPadding =
          (screenSize.width - (matchWidth * ((5 * multiplier) + 14))) / 2;
    } else {
      _topPadding =
          (screenSize.height - (supposedWidth * (5 + 2 * multiplier))) / 2;
      _leftPadding = supposedWidth;
      matchWidth = supposedWidth;
      matchHeight = multiplier * supposedWidth;
    }
    center = screenSize.width / 2;
    bottom = screenSize.height;
    _initMatches();
  }

  void _initMatches() {
    matches = [
      Match(
          paddingTop: _topPadding,
          paddingLeft: _leftPadding + matchWidth,
          rotation: 90),
      Match(
          paddingTop: _topPadding + matchWidth,
          paddingLeft: _leftPadding,
          rotation: 0),
      Match(
          paddingTop: _topPadding + matchWidth,
          paddingLeft: _leftPadding + matchHeight + matchWidth,
          rotation: 0),
      Match(
          paddingTop: _topPadding + matchWidth + matchHeight,
          paddingLeft: _leftPadding + matchWidth,
          rotation: 90),
      Match(
          paddingTop: _topPadding + matchHeight + 2 * matchWidth,
          paddingLeft: _leftPadding,
          rotation: 0),
      Match(
          paddingTop: _topPadding + matchHeight + 2 * matchWidth,
          paddingLeft: _leftPadding + matchHeight + matchWidth,
          rotation: 0),
      Match(
          paddingTop: _topPadding + 2 * matchHeight + 2 * matchWidth,
          paddingLeft: _leftPadding + matchWidth,
          rotation: 90),
    ];
  }

  Widget buildMatchImage(Match match) {
    final matchImage = Image.asset(
      matchAsset,
      height: matchHeight,
      width: matchWidth,
    );
    final transform = Matrix4.identity()
      ..translate(0.0, matchWidth, 0.0)
      ..rotateZ(-toRadians(match.rotation));

    return Positioned(
      top: match.paddingTop,
      left: match.paddingLeft,
      child: match.rotation != 0
          ? Transform(
              transform: transform,
              child: matchImage,
            )
          : matchImage,
    );
  }

  List<Match> getFirstDigitMatches(List<int> indexes) =>
      indexes.map((index) => matches[index]).toList();

  List<Match> getSecondDigitMatches(List<int> indexes) {
    final secondDigitOffset = matchHeight + (3 * matchWidth);
    return indexes
        .map((index) => matches[index])
        .map((match) => Match.copyWith(match, secondDigitOffset))
        .toList();
  }

  List<Match> getThirdDigitMatches(List<int> indexes) {
    final secondDigitOffset = (3 * matchHeight) + (7 * matchWidth);
    return indexes
        .map((index) => matches[index])
        .map((match) => Match.copyWith(match, secondDigitOffset))
        .toList();
  }

  List<Match> getFourthDigitMatches(List<int> indexes) {
    final secondDigitOffset = (4 * matchHeight) + (10 * matchWidth);
    return indexes
        .map((index) => matches[index])
        .map((match) => Match.copyWith(match, secondDigitOffset))
        .toList();
  }

  Widget buildDivider() {
    final dividerVerticalOffset =
        (3 * matchHeight) + (5 * matchWidth) + _leftPadding;
    final topPadding = _topPadding + matchWidth + (matchHeight / 2);
    return buildMatchImage(Match(
        paddingTop: topPadding,
        paddingLeft: dividerVerticalOffset,
        rotation: -45));
  }

  List<int> getMatchesForDigit(int digit) {
    switch (digit) {
      case 0:
        return [0, 1, 2, 4, 5, 6];
      case 1:
        return [2, 5];
      case 2:
        return [0, 2, 3, 4, 6];
      case 3:
        return [0, 2, 3, 5, 6];
      case 4:
        return [1, 2, 3, 5];
      case 5:
        return [0, 1, 3, 5, 6];
      case 6:
        return [0, 1, 3, 4, 5, 6];
      case 7:
        return [0, 2, 5];
      case 8:
        return [0, 1, 2, 3, 4, 5, 6];
      case 9:
        return [0, 1, 2, 3, 5, 6];
      default:
        throw Exception('unsupported digit');
    }
  }
}

double toRadians(double degrees) => degrees * pi / 180;
