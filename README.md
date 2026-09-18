# HoldToConfirmButton

A lightweight, reusable **SwiftUI hold-to-confirm button** with animated progress and optional haptic feedback.

Useful for actions that should not happen with a single accidental tap, such as:

- Deleting content
- Resetting data
- Confirming sensitive actions
- Starting destructive operations
- Requiring deliberate user confirmation

## Features

- Native SwiftUI
- No third-party dependencies
- Smooth hold-progress animation
- Cancels when the user releases early
- Optional SF Symbol
- Configurable hold duration
- Configurable tint color
- Configurable height
- Success haptic feedback on iOS
- Swift Package Manager support
- Accessibility label and hint included

## Requirements

- iOS 16+
- macOS 13+
- Swift 5.9+

## Installation

### Swift Package Manager

In Xcode:

1. Open your project.
2. Go to **File > Add Package Dependencies...**
3. Enter:

```
https://github.com/NiloufarRabiee/swiftui-hold-to-confirm-button
```

4. Add the `HoldToConfirmButton` package to your app target.

Then import it:

```swift
import HoldToConfirmButton
```

## Basic Usage

```swift
import SwiftUI
import HoldToConfirmButton

struct ContentView: View {
    var body: some View {
        HoldToConfirmButton(
            "Hold to Delete",
            systemImage: "trash.fill",
            duration: 1.5,
            tint: .red
        ) {
            print("Confirmed")
        }
        .padding()
    }
}
```

## Minimal Usage

```swift
HoldToConfirmButton("Hold to Confirm") {
    print("Action confirmed")
}
```

## Customization

```swift
HoldToConfirmButton(
    "Hold to Continue",
    systemImage: "arrow.right.circle.fill",
    duration: 2.0,
    tint: .blue,
    height: 60
) {
    continueFlow()
}
```

Available parameters:

| Parameter | Description | Default |
|---|---|---|
| `title` | Text displayed inside the button | Required |
| `systemImage` | Optional SF Symbol | `checkmark.circle.fill` |
| `duration` | Required hold time in seconds | `1.5` |
| `tint` | Progress fill color | `.accentColor` |
| `height` | Button height | `54` |
| `action` | Closure executed after confirmation | Required |

## How It Works

When the user presses and holds:

1. The progress fill starts moving across the button.
2. If the user releases before the duration finishes, the interaction is cancelled.
3. If the hold completes, the action runs.
4. On iOS, a success haptic is triggered.

This makes destructive or important actions more intentional than a normal tap.

## Example

An example implementation is available in:

```
Examples/BasicUsage.swift
```

## Testing

Run:

```bash
swift test
```

The repository also includes GitHub Actions CI.

## Contributing

Contributions and improvements are welcome.

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

This project is available under the MIT License.

See [LICENSE](LICENSE).

---

Created by **Niloufar Rabiee**
