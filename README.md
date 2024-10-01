# ACPresentationController
A common pesentation controller lib

![preview](https://raw.githubusercontent.com/albertgh/ACPresentationController/main/Resources/IMB_5Sw480.GIF)


## Installing

Xcode > File > Swift Packages > Add Package Dependency

`https://github.com/albertgh/ACPresentationController.git`


## Usage

```swift
import ACPresentationController
```

Conforms to `ACPresentationControllerProtocol` , note that `acpc_dismissClosure` and `acpc_controllerHeight` **must be conformed**.

```swift
class YourViewController: UIViewController, ACPresentationControllerProtocol {
    
    // will call no matter drag dismiss or tap dimming to dismiss
    var acpc_dismissClosure: (() -> Void)?
    
    // defines the height of presented view controller
    var acpc_controllerHeight: CGFloat = 280.0
    
    
    // ...
}
```

Additional customization

```swift
// radius of top corner (default: 8.0)
var acpc_viewCornerRadius: CGFloat {
    return 8.0
}

// if allows dimming view tap to dismiss
// (default: true)
var acpc_tapDimmingToDismiss: Bool {
    return true
}

// alpha of dimming view
// (default: 0.3)
var acpc_dimmingAlpha: CGFloat {
    return 0.3
}

// defines to drag how much percentage of presented view should trigger dismiss action when drag dismiss interactive finger up
// (default: 0.5)
var acpc_panToDismissPercent: CGFloat {
    return 0.5
}

// defines the color of drag dismiss grabber
// (default: .systemGray)
var acpc_grabberColor: UIColor {
    return .systemGray
}

// defines grabber height for drag dismiss interactive
// (default: 34.0)
var acpc_topGrabberHeight: CGFloat {
    return 34.0
}

// if allows full top area responds to drag dismiss interactive
// (default: false)
var acpc_needFullTopGrabber: Bool {
    return false
}

// send drag dismiss grabber down to the back
// (default: false)
var acpc_topGrabberSendToBack: Bool {
    return false
}

```


# Example Project

There's an example project available to try. Simply open the `ACPresentationControllerExample-iOS.xcodeproj` from within the `Example` directory.


## Requirements

- iOS 12.0+
- Swift 5.0 or higher


## License
[**MIT**](https://github.com/albertgh/ACPresentationController/blob/main/LICENSE)
