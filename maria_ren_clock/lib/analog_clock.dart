// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

import 'drawn_hand.dart';

/// Total distance traveled by a second or a minute hand, each second or minute,
/// respectively.
final radiansPerTick = radians(360 / 60);

/// Total distance traveled by an hour hand, each hour, in radians.
final radiansPerHour = radians(360 / 12);

/// A basic analog clock.
class AnalogClock extends StatefulWidget {
  const AnalogClock(this.model);

  final ClockModel model;

  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  var _now = DateTime.now();
  var _temperature = '';
  var _temperatureRange = '';
  var _condition = '';
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    // Set the initial values.
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(AnalogClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
      _temperatureRange = '(${widget.model.low} - ${widget.model.highString})';
      _condition = widget.model.weatherString;
    });
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      // Update once per second. Make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
            // Hour hand.
            primaryColor: Colors.black,
            // Minute hand.
            highlightColor: Colors.black,
            // Second hand.
            accentColor: Colors.black,
            backgroundColor: Colors.lightBlue[200].withOpacity(0.5),
          )
        : Theme.of(context).copyWith(
            primaryColor: Color(0xFFD2E3FC),
            highlightColor: Color(0xFFD2E3FC),
            accentColor: Color(0xFFD2E3FC),
            backgroundColor: Color(0xFF3C4043),
          );

    final timeVoiceOver = DateFormat.jm().format(DateTime.now());
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    /// As mentioned in the contest rules: "The clock design should use
    /// landscape mode, with a 5:3 aspect ratio." The following makes the clock
    /// in landscape mode.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    /// Adjust according to different screen sizes.
    var sideComponentsLeft;
    var swingGirlLeft;
    var swingGirlTop;
    var fontSize;
    var analogClockLeft;
    var analogClockRight;
    var analogClockTop;
    var analogClockBottom;
    var digitalClockHeight;
    var leavesLeft;
    var leavesBottom;
    var leavesRight;

    /// screenWidth 568
    void iPhone5Sizing() {
      sideComponentsLeft = screenWidth / 1.63;
      swingGirlLeft = screenWidth / 6;
      swingGirlTop = screenHeight / 2.5;
      fontSize = screenWidth / 6.5;
      analogClockLeft = screenWidth / 7;
      analogClockTop = screenHeight / 15;
      analogClockRight = screenWidth / 3;
      analogClockBottom = screenHeight / 5;
      digitalClockHeight = screenHeight / 7;
      leavesLeft = screenWidth / 8;
      leavesBottom = screenHeight / 1.65;
      leavesRight = screenWidth / 3.1;
    }

    /// screenWidth 667
    void iPhone6sSizing() {
      sideComponentsLeft = screenWidth / 1.5;
      swingGirlLeft = screenWidth / 5.1;
      swingGirlTop = screenHeight / 2.5;
      fontSize = screenWidth / 7.5;
      analogClockLeft = screenWidth / 6;
      analogClockTop = screenHeight / 17;
      analogClockRight = screenWidth / 3.5;
      analogClockBottom = screenHeight / 5;
      digitalClockHeight = screenHeight / 9.5;
      leavesLeft = screenWidth / 8;
      leavesBottom = screenHeight / 1.65;
      leavesRight = screenWidth / 4;
    }

    /// screenWidth 736
    void iPhone8Sizing() {
      sideComponentsLeft = screenWidth / 1.5;
      swingGirlLeft = screenWidth / 5.1;
      swingGirlTop = screenHeight / 2.5;
      fontSize = screenWidth / 7.25;
      analogClockLeft = screenWidth / 6;
      analogClockTop = screenHeight / 17;
      analogClockRight = screenWidth / 3.5;
      analogClockBottom = screenHeight / 5;
      digitalClockHeight = screenHeight / 9.5;
      leavesLeft = screenWidth / 8;
      leavesBottom = screenHeight / 1.65;
      leavesRight = screenWidth / 4;
    }

    /// screenWidth 812
    void iPhone11ProSizing() {
      sideComponentsLeft = screenWidth / 2.1;
      swingGirlLeft = screenWidth / 7.8;
      swingGirlTop = screenHeight / 2.5;
      fontSize = screenWidth / 7.8;
      analogClockLeft = screenWidth / 8;
      analogClockTop = screenHeight / 15;
      analogClockRight = screenWidth / 3.5;
      analogClockBottom = screenHeight / 5;
      digitalClockHeight = screenHeight / 8;
      leavesLeft = screenWidth / 8;
      leavesBottom = screenHeight / 1.65;
      leavesRight = screenWidth / 4;
    }

    /// screenWidth 896
    void iPhone11Sizing() {
      sideComponentsLeft = screenWidth / 2.1;
      swingGirlLeft = screenWidth / 7.8;
      swingGirlTop = screenHeight / 2.5;
      fontSize = screenWidth / 7.5;
      analogClockLeft = screenWidth / 8;
      analogClockTop = screenHeight / 15;
      analogClockRight = screenWidth / 3.5;
      analogClockBottom = screenHeight / 5;
      digitalClockHeight = screenHeight / 9.5;
      leavesLeft = screenWidth / 8;
      leavesBottom = screenHeight / 1.65;
      leavesRight = screenWidth / 4;
    }

    /// screenWidth 1024, 1080, 1366
    void iPadProSizing() {
      sideComponentsLeft = screenWidth / 1.5;
      swingGirlLeft = screenWidth / 5.25;
      swingGirlTop = screenHeight / 3.25;
      analogClockLeft = screenWidth / 6;
      analogClockTop = screenHeight / 9;
      analogClockRight = screenWidth / 3;
      analogClockBottom = screenHeight / 4;
      digitalClockHeight = screenHeight / 9.5;
      fontSize = screenWidth / 5.7;
      leavesLeft = screenWidth / 6.5;
      leavesBottom = screenHeight / 2;
      leavesRight = screenWidth / 3;
    }

    /// screenWidth 1194
    void iPadPro11Sizing() {
      sideComponentsLeft = screenWidth / 1.5;
      swingGirlLeft = screenWidth / 5.25;
      swingGirlTop = screenHeight / 3;
      analogClockLeft = screenWidth / 6;
      analogClockTop = screenHeight / 9;
      analogClockRight = screenWidth / 3;
      analogClockBottom = screenHeight / 4;
      digitalClockHeight = screenHeight / 9.5;
      fontSize = screenWidth / 6;
      leavesLeft = screenWidth / 7;
      leavesBottom = screenHeight / 1.9;
      leavesRight = screenWidth / 3;
    }

    /// screenWidth 1112
    void iPadAirSizing() {
      sideComponentsLeft = screenWidth / 1.5;
      swingGirlLeft = screenWidth / 5.25;
      swingGirlTop = screenHeight / 3.25;
      analogClockLeft = screenWidth / 6;
      analogClockTop = screenHeight / 9;
      analogClockRight = screenWidth / 3;
      analogClockBottom = screenHeight / 4;
      digitalClockHeight = screenHeight / 9.5;
      fontSize = screenWidth / 6;
      leavesLeft = screenWidth / 7;
      leavesBottom = screenHeight / 1.9;
      leavesRight = screenWidth / 3;
    }

    /// Make sure to adjust sizing of elements based on screen sizes of
    /// different iPhones.
    if (screenWidth <= 568.0) {
      iPhone5Sizing();
    } else if (screenWidth > 568.0 && screenWidth <= 667.0) {
      iPhone6sSizing();
    } else if (screenWidth > 667.0 && screenWidth <= 736.0) {
      iPhone8Sizing();
    } else if (screenWidth > 736.0 && screenWidth <= 812.0) {
      iPhone11ProSizing();
    } else if (screenWidth > 812.0 && screenWidth <= 896.0) {
      iPhone11Sizing();
    } else if (screenWidth > 896.0 && screenWidth <= 1024.0) {
      iPadProSizing();
    } else if (screenWidth > 1024.0 && screenWidth <= 1112.0) {
      iPadAirSizing();
    } else if (screenWidth > 1112.0 && screenWidth <= 1194.0) {
      iPadPro11Sizing();
    } else if (screenWidth > 1194.0 && screenWidth <= 1366.0) {
      iPadProSizing();
    } else {
      iPhone11Sizing();
    }

    /// Swing girl animation.
    final swingGirl = Container(
      child: FlareActor(
        'animations/swingGirlAnimation.flr',
        alignment: Alignment.bottomLeft,
        fit: BoxFit.scaleDown,
        animation: 'swingGirl',
      ),
    );

    /// Analog clock.
    final analogClock = Container(
      padding: EdgeInsetsDirectional.only(start: 0, top: 0),
      child: Stack(
        children: [
          /// minute hand
          DrawnHand(
            color: customTheme.highlightColor,
            thickness: 10,
            size: 0.6,
            angleRadians: _now.minute * radiansPerTick,
          ),

          /// hour hand
          DrawnHand(
            color: customTheme.primaryColor,
            thickness: 8,
            size: 0.4,
            angleRadians: _now.hour * radiansPerHour +
                (_now.minute / 60) * radiansPerHour,
          ),
        ],
      ),
    );

    /// Components on the right side of the clock:
    /// Digital time value
    final digitalTime = Text(
      DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_now) +
          ':' +
          DateFormat('mm').format(_now) +
          ':' +
          DateFormat('ss').format(_now),
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );

    /// Digital Time Widget
    final digitalTimeWidget = ExcludeSemantics(
      child: Container(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
        width: screenWidth - sideComponentsLeft,
        height: digitalClockHeight,
        child: FittedBox(
          fit: BoxFit.contain,
          child: digitalTime,
        ),
      ),
    );

    /// Weekday
    final weekday = Text(
      DateFormat.EEEE().format(_now),
      style: TextStyle(
        fontSize: fontSize / 4,
        color: Colors.black,
      ),
    );

    /// Date
    final date = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        weekday,
        Text(
          DateFormat.yMMMMd('en_US').format(_now),
          style: TextStyle(
            fontSize: fontSize / 7,
            color: Colors.black,
          ),
        ),
      ],
    );

    /// Temperature range : lowest to highest.
    final temperatureRange = Text(
      _temperatureRange,
      style: TextStyle(
        fontSize: fontSize / 8,
        color: Colors.black,
      ),
    );

    /// Temperature - temperature and temperature range combined.
    final temperature = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          _temperature,
          style: TextStyle(
            fontSize: fontSize / 5,
            color: Colors.black,
          ),
        ),
        temperatureRange,
      ],
    );

    /// Weather condition icons.
    final cloudy = AssetImage('assets/cloudy.png');
    final foggy = AssetImage('assets/foggy.png');
    final rainy = AssetImage('assets/rainy.png');
    final snowy = AssetImage('assets/snowy.png');
    final snowyLight = AssetImage('assets/snowyLight.png');
    final sunny = AssetImage('assets/sunny.png');
    final thunderstorm = AssetImage('assets/thunderstorm.png');
    final windy = AssetImage('assets/windy.png');

    var conditionIcon;

    switch (_condition) {
      case 'cloudy':
        {
          conditionIcon = cloudy;
        }
        break;
      case 'foggy':
        {
          conditionIcon = foggy;
        }
        break;
      case 'rainy':
        {
          conditionIcon = rainy;
        }
        break;
      case 'snowy':
        {
          conditionIcon = Theme.of(context).brightness == Brightness.light
              ? snowyLight
              : snowy;
        }
        break;
      case 'sunny':
        {
          conditionIcon = sunny;
        }
        break;
      case 'thunderstorm':
        {
          conditionIcon = thunderstorm;
        }
        break;
      case 'windy':
        {
          conditionIcon = windy;
        }
        break;
    }

    final weatherIcon = Image(
        image: conditionIcon,
        width: screenWidth / 10,
        height: screenWidth / 10);

    final horizontalDivider = Container(
      height: 1.5,
      width: screenWidth / 3.5,
      color: Colors.black,
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
    );

    final temperatureUnit = widget.model.unit == TemperatureUnit.celsius
        ? 'degrees celsius'
        : 'degrees fahrenheit';

    /// Combination of all the components for the right side of the clock.
    final sideComponents = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Digital time
        digitalTimeWidget,

        /// Horizontal divider
        horizontalDivider,

        /// Date section
        Semantics(
          label: ' Today is ',
          child: date,
        ),

        /// Horizontal divider
        horizontalDivider,

        /// Weather section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ExcludeSemantics(
              child: weatherIcon,
            ),
            Semantics(
              label: ' The weather today is $_condition, '
                  ' and current temperature is ${widget.model.temperature}, '
                  ' $temperatureUnit, '
                  ' temperature today will range from '
                  ' ${widget.model.low} to ${widget.model.high}, '
                  ' $temperatureUnit, '
                  ' Enjoy your day! ',
              child: ExcludeSemantics(
                child: temperature,
              ),
            ),
          ],
        ),
      ],
    );

    /// gradient for background.
    final transformColor = Theme.of(context).brightness == Brightness.light
        ? Colors.white
        : Colors.blue;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.45, 0.8],
            colors: [customTheme.backgroundColor, transformColor]),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: ExcludeSemantics(
              child: Image(
                image: AssetImage('assets/tree.png'),
                height: screenHeight,
              ),
            ),
          ),
          Positioned(
            left: leavesLeft,
            top: 0,
            bottom: leavesBottom,
            right: leavesRight,
            child: ExcludeSemantics(
              child: Image(
                image: AssetImage('assets/leaves.png'),
                height: screenHeight / 2.6,
              ),
            ),
          ),
          Positioned(
            left: swingGirlLeft,
            top: swingGirlTop,
            right: 0,
            bottom: 0,
            child: ExcludeSemantics(
              child: swingGirl,
            ),
          ),
          Positioned(
            left: sideComponentsLeft,
            top: 0,
            right: 0,
            bottom: 0,
            child: Semantics(
              label: 'Welcome to Maria Ren\'s clock! Current time is '
                  ' $timeVoiceOver , ',
              child: Container(
                padding: const EdgeInsets.all(8.0),
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : Colors.lightBlue,
                child: sideComponents,
              ),
            ),
          ),
          Positioned.fill(
            left: analogClockLeft,
            top: analogClockTop,
            right: analogClockRight,
            bottom: analogClockBottom,
            child: ExcludeSemantics(
              child: analogClock,
            ),
          ),
        ],
      ),
    );
  }
}
