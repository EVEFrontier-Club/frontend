import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

@client
class Health extends StatelessComponent {
  const Health({super.key});

  @override
  Component build(BuildContext context) {
    return div([.text('OK')]);
  }
}
