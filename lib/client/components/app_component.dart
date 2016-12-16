import 'dart:html';
import 'dart:async';

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:intl/intl.dart';

import 'package:ceemax/client/components/home_component.dart';
import 'package:ceemax/client/components/news_component.dart';
import 'package:ceemax/client/components/fixtures_component.dart';
import 'package:ceemax/common/services/fixture_service.dart';

@Component(
    selector: 'ceemax-app',
    templateUrl: 'templates/app.html',
    directives: const [ROUTER_DIRECTIVES],
    providers: const [ROUTER_PROVIDERS, FixtureService],
    )
@RouteConfig(const [
    const Route(
        path: '/news',
        name: 'News',
        component: NewsComponent),
    const Route(
        path: '/fixtures',
        name: 'Fixtures',
        component: FixturesComponent),
    const Route(
        path: '/',
        name: 'Home',
        useAsDefault: true,
        component: HomeComponent),
    ])
class AppComponent implements OnInit {
    AnchorElement menuAnchor;
    DateTime currentDt;
    final FixtureService _fixtureService;
    Stream timeUpdaterStream;
    String dateString;
    String hour;
    String minute;
    String second;
    String title = 'Ceemax';

    AppComponent(this._fixtureService);
    Future<Null> ngOnInit() async {
        this.menuAnchor = querySelector('#menu-toggle');
        var menuLinkSubscription = menuAnchor.onClick.listen(_onClickMenu);
        this._setTime();
        this.timeUpdaterStream = this._timeUpdaterStream(
                const Duration(seconds: 1));
        var timeUpdaterSubscription = timeUpdaterStream.listen(
                (int counter) {});
    }

    /// Menu anchor onClick handler.
    void _onClickMenu(Event e) {
        e.preventDefault();
        DivElement wrapperDiv = querySelector('#wrapper');
        wrapperDiv.classes.toggle('toggled');
    }

    /// Set DateTime currentDt.
    void _setTime() {
        this.currentDt = new DateTime.now();
        this.dateString = new DateFormat("EEE MMM d")
            .format(this.currentDt);
        this.hour = this.currentDt.hour.toString().padLeft(2, '0');
        this.minute = this.currentDt.minute.toString().padLeft(2, '0');
        this.second = this.currentDt.second.toString().padLeft(2, '0');
    }

    /// Time updater
    Stream<int> _timeUpdaterStream(Duration interval) {
        StreamController<int> controller;
        Timer timer;

        void load(_) {
            this._setTime();
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
}
