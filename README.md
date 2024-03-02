# Example of SyncState from [AppState](https://github.com/0xLeif/AppState)

## Data Model

Assume we have a struct named Settings that conforms to Codable.

```swift
struct Settings: Codable {
    var text: String
    var isShowingSheet: Bool
    var isDarkMode: Bool
}

```

We can create a SyncState value for this.

```swift
extension Application {
    var settings: SyncState<Settings> {
        syncState(
            initial: Settings(
                text: "Hello, World!",
                isShowingSheet: false,
                isDarkMode: false
            ),
            id: "settings"
        )
    }
}

```

To update with external changes, we need to create a custom application and override the didChangeExternally function.

```swift
class CustomApplication: Application {
    override func didChangeExternally(notification: Notification) {
        super.didChangeExternally(notification: notification)

        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
}

```

Next, we will create two views. The first one, named BasicAppState, will have a text field to modify the string sync state. BasicAppState view will also present a sheet that displays BasicAppStateInnerView. BasicAppStateInnerView will show the same string value. Both views' states will match each other.

```swift
struct ContentView: View {
    @SyncState(\.settings) private var settings: Settings

    var body: some View {
        VStack {
            TextField("", text: $settings.text)

            Button(settings.isDarkMode ? "Light" : "Dark") {
                settings.isDarkMode.toggle()
            }

            Button("Show") { settings.isShowingSheet = true }
        }
        .preferredColorScheme(settings.isDarkMode ? .dark : .light)
        .sheet(isPresented: $settings.isShowingSheet, content: ContentViewInnerView.init)
    }
}

struct ContentViewInnerView: View {
    @Slice(\.settings, \.text) private var text: String

    var body: some View {
        Text("\(text)")
            .onTapGesture {
                text = Date().formatted()
            }
    }
}
```

Lastly, we need to create the App and present the view! In the App init, we will promote the app, enable logging for debugging purposes, and then load the icloudStore dependency.

```swift
@main
struct SyncStateExampleApp: App {
    init() {
        Application
            .promote(to: CustomApplication.self)
            .logging(isEnabled: true)
            .load(dependency: \.icloudStore)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```
