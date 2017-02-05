import Foundation

public struct BencodeResult {
    enum BencodeType {
        case integer
        case list
        case dictionary
        case buffer
    }
    
    let rawData: Any
    let type: BencodeType
    
    var integer: Int? {
        get {
            if let stringified = self.string {
                return Int(stringified)
            }
            
            return nil
        }
    }
    
    var string: String? {
        get {
            if let data = rawData as? Data {
                return String(data: data, encoding: .utf8)
            }
            
            return nil
        }
    }
    
    var list: [BencodeResult]? {
        get {
            return rawData as? [BencodeResult]
        }
    }
    
    var dictionary: [String: BencodeResult]? {
        get {
            return rawData as? [String: BencodeResult]
        }
    }
    
    var hexString: String? {
        get {
            guard let data = rawData as? Data else {
                return nil
            }
            
            return data.map { String(format: "%02hhx", $0) }.joined()
        }
    }
}
