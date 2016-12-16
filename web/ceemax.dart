// Copyright (c) 2012, 2015 the Dart project authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:html';

//import 'package:http/browser_client.dart';
import 'package:http/browser_client.dart';
import 'package:ceemax/client/ceemaxapi.dart';
import 'package:ceemax/common/messages.dart';
import 'package:ceemax/common/utils.dart';
import 'package:ceemax/client/components/clock.dart';




DivElement timeDiv;
DivElement dateDiv;
DateTime clientDateTime;
Stream<int> timeUpdaterStream;
StreamSubscription<int> timeUpdaterSubscription;

// By default the generated client code uses
// 'http://localhost:8080/'. Since our server is running on
// port 8088 we override the default url when instantiating
// the generated PiratesApi class.
final String _serverUrl = 'localhost:8088/';
final BrowserClient _client = new BrowserClient();
CeemaxApi _api;
PirateShanghaier _shanghaier;

Future main() async {
    // We need to determine if the client is using http or https
    // and use the same protocol for the client stub requests
    // (the protocol includes the ':').
    var protocol = window.location.protocol;
    if (!['http:', 'https:'].contains(protocol)) {
      // Default to http if unknown protocol.
      protocol = 'http:';
    }
    _api = new CeemaxApi(_client, rootUrl: '$protocol//$_serverUrl');
    _shanghaier = new PirateShanghaier();
    /*
    timeUpdaterStream = _timeUpdaterStream(const Duration(seconds: 1));
    timeUpdaterSubscription = timeUpdaterStream.listen((int counter) {});
    */
}

void setTime() {
    /*timeDiv.text = new DateTime.now().toString();*/
    /*dateDiv.innerHtml = new DateTime.now().toString();*/
    window.console.debug(timeDiv);
}

Stream<int> _timeUpdaterStream(Duration interval) {
    StreamController<int> controller;
    Timer timer;

    void load(_) {
        setTime();
    }

    void startTimer() {
        timer = new Timer.periodic(interval, load);
    }

    void stopTimer() {
        if (timer != null) {
            timer.cancel();
            timer = null;
        }
    }

    controller = new StreamController<int>(
    onListen: startTimer,
    onPause: stopTimer,
    onResume: startTimer,
    onCancel: stopTimer);

    return controller.stream;
}

