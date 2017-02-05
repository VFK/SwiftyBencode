# SwiftyBencode [![GitHub release](https://img.shields.io/github/release/VFK/SwiftyBencode.svg)](https://github.com/VFK/SwiftyBencode/releases) [![Build Status](https://travis-ci.org/VFK/SwiftyBencode.svg?branch=master)](https://travis-ci.org/VFK/SwiftyBencode)

> A general purpose [bencode](https://en.wikipedia.org/wiki/Bencode) decoder written in Swift 3

## Usage
```swift
Bencode.decode(data: Data) throws -> BencodeResult
```
### BencodeResult
```swift
BencodeResult.integer -> Int?
BencodeResult.string -> String?
BencodeResult.list -> [BencodeResult]?
BencodeResult.dictionary -> [String: BencodeResult]?

// hexadecimal representation of swift Data.
BencodeResult.hexString -> String? // Data(bytes: [0, 1, 127, 128, 255]) -> 00017f80ff
```

### Decoding torrent file
```swift
import Bencode

let url: URL = <path to torrent file>
let data = try! Data(contentsOf: url!)

do {
  let result = try Bencode.decode(data: data)

  if let announce = result.dictionary?["announce"]?.string {
    print(announce)
  }

  if let announceList = result.dictionary?["announce"]?.list {
    // announceList is [BencodeResult]
    for item in announceList {
      print(item.string!)
    }
  }

  if let creationDate = result.dictionary?["creation date"]?.integer {
    print(creationDate)
  }

} catch BencodeDecodeError.invalidFormat {

} catch {

}
```

## Installation
### Swift Package Manager

```swift
import PackageDescription

let package = Package(
  <...>
  dependencies: [
    .Package(url: "https://github.com/VFK/SwiftyBencode.git", majorVersion: 0, minor: 2)
  ]
  <...>
)
```
