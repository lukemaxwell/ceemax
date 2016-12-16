import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

@Component(
    selector: 'ceemax-home',
    templateUrl: 'templates/home.html',
    directives: const [ROUTER_DIRECTIVES])
class HomeComponent {
    var name = 'Home';
}
