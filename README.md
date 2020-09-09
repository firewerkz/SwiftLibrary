# MyLibrary

PickerView File Picker (PDF))
````
PickerView(url: self.$uploadFile)
````
PDFKitView PDF Viewer
````
PDFKitView(url: URL(string: "File.pdf")
````
ProgressBar (value 0.0 - 1.0)
````
ProgressBar(value: $file.progress)
.frame(height: 20)
````
Display() WebView
````
struct WebView4_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Display(site: "https://www.apple.com/")
        }
    }
}
````

.previewAsComponent()
````
struct PickerView_Preview: PreviewProvider {
    static var previews: some View {
        return PickerView(url: .constant(URL(string: "www.apple.com")))
            .aspectRatio(3/2, contentMode: .fit)
        .previewAsComponent()
    }
}
````
.previewAsScreen
````
struct PickerView_Preview: PreviewProvider {
    static var previews: some View {
        return PickerView(url: .constant(URL(string: "www.apple.com")))
            .aspectRatio(3/2, contentMode: .fit)
        .previewAsScreen()
    }
}
````
.mock extension

