<img src="assets/Logo.png" alt="FwiCore" width="36" height="36"> FwiCore
========================================================================

![platforms](https://img.shields.io/badge/platforms-iOS-333333.svg) [![SPM compatible](https://img.shields.io/badge/SPM-compatible-orange.svg)](https://github.com/apple/swift-package-manager)

## About FwiCore
**:warning: This readme describes FwiCore 1.x.x version that requires Swift 3.0.0.**

The initial purpose of FwiCore is to reuse the code that had been written over and over again from one project to another. However, after a period of time, it becomes bigger and bigger and the original purpose was no longer valid. And today, the FwiCore's purpose is trying to become a single library to resolve most of daily tasks.

## Installation with Swift Package Manager
.Package(url: "https://github.com/phuc0302/swift-core.git", majorVersion: 1),

## Features
- [x] **extension:** _a set of extra functions to add to Apple Standard Frameworks._
- [x] **codec:** _a wrapper base64 encode/decode and hex encode/decode._
- [x] **i18n:** _custom localization implementation to support languages ISO3._
- [x] **json:** _inspire by [JSONModel](https://github.com/jsonmodel/jsonmodel), but written in pure swift._
- [x] **manager > network:** _lightweight network implementation base on `URLSession`. The implementation only supports data task and download task._
- [x] **manager > persistent:** _lightweight core data implementation base on `CoreData.framework`. The implementation has buildin lightweight migration schema and simple CRUD._
- [x] **manager > reachability:** _`Apple ObjC Reachability` implemented in pure swift._
- [x] **operation:** _basic concerrency operation implementation._
- [x] **view model:** _simplify the implementation for both `UICollectionView` and `UITableView` that require to interact with core data._

The unique feature of this library is the buildin `network layer` and the `operation`. Both share the same `OperationQueue` and the number of threads can be adjusted. Thus, no matter how many background tasks or HTTP requests there are, all will be handled by single queue. This approach is best suit for any application which focus on low memory and best performance.

## Requirements
- Swift 3
- iOS 8.0+

## Usage

### extension
#### _Data+FwiExtension_
```swift
/// Clear all bytes data.
func clearBytes()
/// Reverse the order of bytes.
func reverseBytes()
/// Convert data to string base on string encoding type.
func toString(stringEncoding:) -> String?


/// Read data from file.
static func readFromFile(atURL:, readingMode:) -> Data?
/// Write data to file.
func writeToFile(toUrl:, options:) -> Error?
```
#### _Dictionary+FwiExtension_
```swift
/// Load dictionary from plist.
let d = Dictionary<String, Any>.loadPlist(withPlistname: "sample")
```
#### _FileManager+FwiExtension_
```swift
/// Create directory for a given URL.
func createDirectory(atURL:, withIntermediateDirectories:, attributes:) -> Error?
/// Check if directory is available for a given URL.
func directoryExists(atURL:) -> Bool
/// Move directory from source's URL to destination's URL.
func moveDirectory(from:, to:) -> Error?
/// Remove directory for a given URL.
func removeDirectory(atURL url: URL?) -> Error?


/// Check if file is available for a given URL.
func fileExists(atURL:) -> Bool
/// Move file from source's URL to destination's URL.
func moveFile(from:, to:) -> Error?
/// Remove file for a given URL.
func removeFile(atURL:) -> Error?
```
#### _NSCoding+FwiExtension_
```swift
/// Unarchive from data.
static func unarchive(fromData d:) -> Self?
/// Archive to data.
func archive() -> Data


/// Unarchive from file.
static func unarchive(fromFile:) -> Self?
/// Archive to file.
func archive(toFile:) -> Error?


/// Unarchive from UserDefaults.
public static func unarchive(fromUserDefaults:) -> Self?
/// Archive to UserDefaults.
func archive(toUserDefaults:) -> Bool
```
#### _NSManagedObject+FwiExtension_
```swift
/// Remove self from database.
func remove()
```
#### _NSNumber+FwiExtension_
```swift
/// Display number to specific currency format.
let currency = NSNumber(value: 2000).currency(withISO3: "USD")  // $2,000.00
```
#### _String+FwiExtension_
```swift
/// Generate random identifier base on uuid.
static func randomIdentifier() -> String?
/// Generate timestamp string.
static func timestamp() -> String


/// Convert html string compatible to string.
func decodeHTML() -> String
/// Convert string to html string compatible.
func encodeHTML() -> String


/// Compare 2 string regardless case sensitive.
func isEqualToStringIgnoreCase(_:) -> Bool
/// Calculate string length.
func length() -> Int
/// Validate string.
func matchPattern(_:, expressionOption:) -> Bool
/// Split string into components.
func split(_:) -> [String]
/// Sub string to index.
func substring(endIndex:) -> String
/// Sub string from index to reverse index, reverseIndex must be negative.
func substring(startIndex:, reverseIndex:) -> String


/// Subscript get character at index.
let c = "Hello world"[0]    // 'H'
```
#### _URL+FwiExtension_
```swift
/// URL to main cache folder.
static func cacheDirectory() -> URL?
/// URL to main document folder.
static func documentDirectory() -> URL?


/// Append path component.
let url = URL(string: "https://google.com") + "/get"    // https://google.com/get


/// Add query params to current url.
let url = URL(string: "https://google.com") + ["string1":"value1", "string2":"value2"]    // https://google.com?string1=value1&string2=value2
let url = URL(string: "https://google.com") + ["#string1":"value1", "string2":"value2", "string3":"value3"]    // https://google.com#string1=value1?string2=value2&string3=value3
```
#### _URLRequest+FwiExtension_
```swift
/// Manual define body data.
func generateRawForm(_ rawParam:)
/// Generate multipart/form-data.
func generateMultipartForm(queryParams:, fileParams:, boundaryForm:)
/// Generate x-www-form-urlencoded.
func generateURLEncodedForm(queryParams:)
```
#### _UIApplication+FwiExtension_
```swift
/// Define whether the device is iPad or not.
class func isPad() -> Bool
/// Define whether the device is iPhone or not.
class func isPhone() -> Bool


/// Return iOS major version.
class func osMajor() -> Int
/// Return iOS minor version.
class func osMinor() -> Int


/// Enable remote notification.
class func enableRemoteNotification()
```
#### _UIButton+FwiExtension_
The image's name must follow these pattern, otherwise the function is not working correctly. However, the button's state will not be effected if the image is not available.
- Default: {imageName}_Default
- Highlighted: {imageName}_Highlighted
- Selected: {imageName}_Selected
- Disabled: {imageName}_Disabled
```swift
/// Apply background to button.
func applyBackgroundImage(_:, withEdgeInsets:)
/// Apply image to button.
func applyImage(_:)
```
#### _UIColor+FwiExtension_
```swift
/// Convert hex to color.
init(rgb:)
init(rgba:)
```
#### _UIView+FwiExtension_
```swift
/// Create image from current view.
func createImage(_:) -> UIImage?
/// Create image from region of interest.
func createImageWithROI(_:, scaleFactor:) -> UIImage?


/// Find first responder within tree views.
func findFirstResponder() -> UIView?
/// Find and resign first responder within tree views.
func findAndResignFirstResponder()
```
#### _UIViewController+FwiExtension_
```swift
/// Return view controller's identifier.
static var identifier: String

/// Add initial view controller from other storyboard into defined view. Default is view controller's view.
func addFlow(fromStoryboard:, intoView:, inBundle:) -> UIViewController?
```

### codec
Only available for Data & String
```swift
func isBase64() -> Bool

func decodeBase64Data() -> Data?
func decodeBase64String() -> String?

func encodeBase64Data() -> Data?
func encodeBase64String() -> String?
```
```swift
func isHex() -> Bool

func decodeHexData() -> Data?
func decodeHexString() -> String?

func encodeHexData() -> Data?
func encodeHexString() -> String?
```

### i18n
In order to use `FwiLocalization`, the precondition is:
1. The folder's name that contains the localized string must be either ISO2 or ISO3: ex. `en.lproj` or `eng.lproj`.
2. The file's name must be `Localizable` and the file's extension must be `strings`.
3. The file must be added to project.
```swift
let localize = FwiLocalization.instance
localize.locale = "eng"

let text = localize.localized(forString: "Hello world.")
```

### json
inspire by [JSONModel](https://github.com/jsonmodel/jsonmodel), this parser will have similar features like:
`keyMapper`, `ignoreProperties`, `optionalProperties` and so on. However, this implementation using protocol approach instead of abstract class, thus, it is more flexible. There is only one downside of the implementation is that it is required the model to be inherit from NSObject because this is heavily depends on KVO feature from ObjC and the primities value except String cannot be optional.

- Auto map
```swift
class TestJSON: NSObject {
    var a: Int = 0
    var b: String?
}

let d: [String : Any] = ["a":1, "b":"Hello world"]
let (model, err) = TestJSON.map(dictionary: d)
```

- Key mapper
```swift
class TestJSON: NSObject, FwiJSONModel {
    var a: Int = 0
    var b: String?
    
    var keyMapper: [String:String]? {
        return [
            "value1":"a",
            "value2":"b"
        ]
    }
}

let d: [String : Any] = ["value1":1, "value2":"Hello world"]
let (model, err) = TestJSON.map(dictionary: d)
```

#### _FwiJSONSerialization_
```swift
/// Convert model to dictionary.
func toDictionary() -> [String : Any]
/// Convert model to JSON as data.
func toJSONData() -> Data?
/// Convert model to JSON as string.
func toJSONString() -> String?
```
#### _FwiJSONConvert_
Class using for convert, because FwiJSONSerialization is dynamic protocol, using this for generic object.
```swift
/// Build a list from a list of models.
static func convert(array:) -> [Any]
```
#### _FwiJSONDeserialization_
```swift
/// Build a list of models from data.
static func map(arrayData:) -> ([Model]?, Error?)
/// Create model's instance and map dictionary to that instance from data.
static func map(dictionaryData:) -> (Model?, Error?)


/// Build a list of models.
static func map(array:) -> ([Model]?, Error?)
/// Create model's instance and map dictionary to that instance.
static func map(dictionary:) -> (Model?, Error?)

e.g.
class TestJSON: NSObject, FwiJSONModel {
    var a: Int = 0
    var b: String?
}

let (list, err) = TestJSON.map(arrayData: data)
let (model, err) = TestJSON.map(dictionaryData: data)

let (list, err) = TestJSON.map(array: array)
let (model, err) = TestJSON.map(dictionary: dictionary)
```
#### _FwiJSONMap_
```swift
/// Build a list of models.
class func map(array:) -> ([T]?, NSError?)
/// Create model's instance and map dictionary to that instance.
class func map(dictionary:) -> (T?, NSError?)
```

### manager > network
```swift
// Send a request to obtain data from server.
if let url = URL(string: "http://httpbin.org") + "/get" {
    let request = URLRequest(url: url)
    FwiNetwork.instance.send(request: request) { (data, error, statusCode, response) in
        ...
    }
}

// Download a resource from server.
if let url = URL(string: "http://httpbin.org") + "/get" {
    let request = URLRequest(url: url)
    FwiNetwork.instance.download(resource: request) { (location, error, statusCode, response) in
        ...
    }
}
```

### manager > persistent
```swift
let persistent = FwiPersistentManager(withModel: "Sample",
                                      fromBundle: Bundle(for: FwiPersistentManagerTest.self),
                                      storeType: .sqlite)
```

### operation
```swift
class SampleOperation : FwiOperation {
    override func businessLogic() {
        ...
    }
}

let o = SampleOperation()
o.executeWithCompletion { 
    ...            
}
```