# MyLibrary

ImagePicker 
```swift
struct ImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        ImagePicker(image: .mock(nil))
    }
}
```

PickerView File Picker (PDF))
```swift
PickerView(url: self.$uploadFile)
```
PDFKitView PDF Viewer
```swift
PDFKitView(url: URL(string: "File.pdf")
```
ProgressBar (value 0.0 - 1.0)
```swift
ProgressBar(value: $file.progress)
.frame(height: 20)
```
Display() WebView
```swift
struct WebView4_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Display(site: "https://www.apple.com/")
        }
    }
}
```

AdaptiveStack<Content: View>:
```swift
var body: some View {
AdaptiveStack {
Form {
```

.previewAsComponent()
```swift
struct PickerView_Preview: PreviewProvider {
    static var previews: some View {
        return PickerView(url: .constant(URL(string: "www.apple.com")))
            .aspectRatio(3/2, contentMode: .fit)
        .previewAsComponent()
    }
}
```
.previewAsScreen
```swift
struct PickerView_Preview: PreviewProvider {
    static var previews: some View {
        return PickerView(url: .constant(URL(string: "www.apple.com")))
            .aspectRatio(3/2, contentMode: .fit)
        .previewAsScreen()
    }
}
```
.mock extension, read/write equivalent of .constant() in previews.

