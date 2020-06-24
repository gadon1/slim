## [4.1.9]

- Date extention method for DateTime.format([d,dd,m,mm,yy,yyyy,h,hh,mi,s,ss])

## [4.1.8]

- String extension method for levenshtein score
- Date extention method for DateTime.format([d,dd,m,mm,yy,yyyy])

## [4.1.7]

- String extension method String.format
- BuildContext translatef method that combine String.format method
- `SlimWidget` abstraction to speed `SlimBuilder` wrap

## [4.1.6]

Localization:

- add optional group parameter to enable 2-level json locale file in `SlimLocaleLoader` and `context.translate(String key, [String group])` extension method

## [4.1.5]

- update(readme)

## [4.1.4]

- update(example)

## [4.1.3]

breaking changes:

- `SlimObject` -> `SlimController`
- `SlimAppStateObject` -> `SlimAppStateController`

## [4.1.2]

- code polish

## [4.1.1]

- update(tests)

## [4.1.0]

- code polish

## [4.0.0]

breaking changes:

- `RestApi` -> `SlimApi`
- `RestApiMethod` -> `SlimApiMethod`
- `RestApiResponse` -> `SlimResponse`

## [3.3.7]

- update(documentaion)

## [3.3.6]

- update(documentaion)

## [3.3.5]

- introducing `SlimAppStateObject` to extend `SlimObject` and getting `AppLifecycleState` events

## [3.3.4]

- update(documentaion)

## [3.3.3]

- UI Messages: breaking change: typo dissmisable -> dissmisible, clearMessage -> clearOverlay, forceClearMessage -> forceClearOverlay
- new extension methods on int for duration and current date with round up minutes interval

## [3.3.2]

- UI Messages: add overlayColor & overlayOpacity options when showing overlay message / widget
- UI Messages: breaking change: messageBackgroundColor -> backgroundColor, messageTextStyle -> textStyle

## [3.3.1]

- publish on 1.17.2 stable channel

## [3.3.0]

- changed `SlimController` init & dispose methods to onInit & onDispose

## [3.2.9]

- clear snackbar message after displaying to avaoid showing it again on hot reload

## [3.2.8]

- adding to `SlimController` init & dispose methods to call in matching Slim state (can be overriden)

## [3.2.7]

- changing `Slim` to `StatefulWidget` to keep state during hot reload

## [3.2.6]

- add closeKeyboard() to `SlimController`

## [3.2.5]

- slim access of dependOnInheritedWidgetOfExactType fallbacks to findAncestorWidgetOfExactType to enable initState access

## [3.2.4]

- T slim<T>() for `SlimController`

## [3.2.3]

- forceClearMessage & clearMessage for `SlimController`

## [3.2.2]

- call UI messages directly from `SlimController` (no need to use context extensions)
- change slim access from dependOnInheritedWidgetOfExactType to findAncestorWidgetOfExactType to enable initState access

## [3.2.1]

documentation update

## [3.2.0]

build fix

## [3.1.9]

`SlimBuilder` can get instance to put above its child incase you dont want to preput it on the tree

## [3.1.8]

SlimMessage for static messages
closeKeyboard context extension

## [3.1.7]

slim app essentials
