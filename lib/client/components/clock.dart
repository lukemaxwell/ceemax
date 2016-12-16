import 'dart:html';
import 'package:angular2/core.dart';

@Component(
    selector: 'clock',
    template: '''
        <h2>{{clockTime}}</h2>
          '''
)

class ClockComponent {
    String clockTime;

    ClockComponent() {
      /*  this._setTime(); */
        window.console.debug('ClockComponent loaded!');
    }

    /*
    _setTime() {
        this.clockTime = new DateTime.now().toString();
    }
    */
}
