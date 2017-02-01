# SwiftyBencode

> A general purpose [bencode](https://en.wikipedia.org/wiki/Bencode) decoder written in Swift 3

## Usage
```swift
Bencode.decode(data: Data) throws -> Any
```

Strings returned as `Data` according to [bencode specification](https://wiki.theory.org/BitTorrentSpecification#Bencoding). 
You need to explicitly convert it to String if this is what you expect:

```swift
let result = try! Bencode.decode(data: bencodedData) as! Data
let decodedString = String(data: result, encoding: .utf8)
```

> ⚠️ Be careful with force unwrapping, everything on this page provided just  as an example!

#### Example of decoding torrent file
```swift
import Bencode

let url: URL = <path to torrent file>
let data = try! Data(contentsOf: url!)

do {
    let result = try Bencode.decode(data: data) as! [String: Any]
    
    guard let announceData = result["announce"] as? Data else {
        // Torrent file doesen't have "announce" field hence invalid.
    }
    
    if let announce = String(data: announceData, encoding: .utf8) {
        print(announce)
    }
    
} catch BencodeDecodeError.invalidFormat {}
```

## Installation
## Swift Package Manager

```swift
import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/VFK/SwiftyBencode.git", majorVersion: 0, minor: 1),
    ]
)
```
