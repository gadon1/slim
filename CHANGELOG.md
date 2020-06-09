## [3.3.5]

- introducing [SlimAppStateObject] to extend [SlimObject] and getting AppLifecycleState events

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

- changed [SlimObject] init & dispose methods to onInit & onDispose

## [3.2.9]

- clear snackbar message after displaying to avaoid showing it again on hot reload

## [3.2.8]

- adding to [SlimObject] init & dispose methods to call in matching Slim state (can be overriden)

## [3.2.7]

- changing [Slim] to [StatefulWidget] to keep state during hot reload

## [3.2.6]

- add closeKeyboard() to [SlimObject]

## [3.2.5]

- slim access of dependOnInheritedWidgetOfExactType fallbacks to findAncestorWidgetOfExactType to enable initState access

## [3.2.4]

- T slim<T>() for [SlimObject]

## [3.2.3]

- forceClearMessage & clearMessage for [SlimObject]

## [3.2.2]

- call UI messages directly from [SlimObject] (no need to use context extensions)
- change slim access from dependOnInheritedWidgetOfExactType to findAncestorWidgetOfExactType to enable initState access

## [3.2.1]

documentation update

## [3.2.0]

build fix

## [3.1.9]

[SlimBuilder] can get instance to put above its child incase you dont want to preput it on the tree

## [3.1.8]

SlimMessage for static messages
closeKeyboard context extension

## [3.1.7]

slim app essentials
