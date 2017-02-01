import Foundation

enum BencodeDecodeError: Error {
    case invalidFormat
}

final class Decoder {
    private let bencodedData: Data
    private var position = 0
    
    private enum ByteTypes: UInt8 {
        case integerType = 0x69
        case dictionaryType = 0x64
        case listType = 0x6C
        case separatorType = 0x3A
        case endType = 0x65
    }
    
    init(with data: Data) {
        bencodedData = data
    }
    
    public func decode() throws -> Any {
        let type = bencodedData[position]
        print(position)
        switch type {
        case ByteTypes.dictionaryType.rawValue:
            return try decodeDictionary()
        case ByteTypes.listType.rawValue:
            return try decodeList()
        case ByteTypes.integerType.rawValue:
            return try decodeInteger()
        default:
            return try decodeBuffer()
        }
    }
    
    private func readRange(from: Int, lenght: Int) -> Data {
        let range = Range(from..<(from + lenght))
        return bencodedData.subdata(in: range)
    }
    
    private func readInteger(from: Int, lenght: Int) throws -> Int {
        let data = readRange(from: from, lenght: lenght)
        let strResult = String(data: data, encoding: .utf8)!
        
        guard let result = Int(strResult) else {
            throw BencodeDecodeError.invalidFormat
        }
        
        return result
    }
    
    private func findPosition(of byte: UInt8, from offset: Int) throws -> Int {
        for (index, currentByte) in bencodedData[offset..<bencodedData.count].enumerated() {
            if currentByte == byte {
                return index
            }
        }
        
        throw BencodeDecodeError.invalidFormat
    }
    
    private func decodeInteger() throws -> Int {
        position += 1
        
        let endPosition = try findPosition(of: ByteTypes.endType.rawValue, from: position)
        let result = try readInteger(from: position, lenght: endPosition)
        
        position = endPosition + position + 1
        
        return result
    }
    
    private func decodeBuffer() throws -> Data {
        let separatorIndex = try findPosition(of: ByteTypes.separatorType.rawValue, from: position)
        let length = try readInteger(from: position, lenght: separatorIndex)
        let result = readRange(from: position + separatorIndex + 1, lenght: length)
        
        position = position + separatorIndex + length + 1
        
        return result
    }
    
    private func decodeList() throws -> [Any] {
        position += 1
        
        var result = [Any]()
        
        while bencodedData[position] != ByteTypes.endType.rawValue {
            let decoded = try decode()
            result.append(decoded)
        }
        
        position += 1
        
        return result
    }
    
    private func decodeDictionary() throws -> [String: Any] {
        position += 1
        
        var result = [String: Any]()
        
        while bencodedData[position] != ByteTypes.endType.rawValue {
            let buffer = try decodeBuffer()
            
            guard let key = String(data: buffer, encoding: .utf8) else {
                throw BencodeDecodeError.invalidFormat
            }
            
            let value = try decode()
            
            result[key] = value
        }
        
        position += 1
        
        return result
    }
}
