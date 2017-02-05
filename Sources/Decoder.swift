import Foundation

public enum BencodeDecodeError: Error {
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
    
    public func decode() throws -> BencodeResult {
        let type = bencodedData[position]
        
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
    
    private func findPosition(of byte: UInt8, from offset: Int) throws -> Int {
        for (index, currentByte) in bencodedData[offset..<bencodedData.count].enumerated() {
            if currentByte == byte {
                return index
            }
        }
        
        throw BencodeDecodeError.invalidFormat
    }
    
    private func decodeInteger() throws -> BencodeResult {
        position += 1
        
        let endPosition = try findPosition(of: ByteTypes.endType.rawValue, from: position)
        let result = readRange(from: position, lenght: endPosition)
        
        if result.isEmpty {
            throw BencodeDecodeError.invalidFormat
        }
        
        position = endPosition + position + 1
        
        return BencodeResult(rawData: result, type: .integer)
    }
    
    private func decodeBuffer() throws -> BencodeResult {
        let separatorIndex = try findPosition(of: ByteTypes.separatorType.rawValue, from: position)
        
        let lengthData = readRange(from: position, lenght: separatorIndex)
        let lengthResult = BencodeResult(rawData: lengthData, type: .integer)
        
        guard let length = lengthResult.integer else {
            throw BencodeDecodeError.invalidFormat
        }
        
        let result = readRange(from: position + separatorIndex + 1, lenght: length)
        
        position = position + separatorIndex + length + 1
        
        return BencodeResult(rawData: result, type: .buffer)
    }
    
    private func decodeList() throws -> BencodeResult {
        position += 1
        
        var result = [BencodeResult]()
        
        while bencodedData[position] != ByteTypes.endType.rawValue {
            let decoded = try decode()
            result.append(decoded)
        }
        
        position += 1
        
        return BencodeResult(rawData: result, type: .list)
    }
    
    private func decodeDictionary() throws -> BencodeResult {
        position += 1
        
        var result = [String: Any]()
        
        while bencodedData[position] != ByteTypes.endType.rawValue {
            let buffer = try decodeBuffer()
            
            guard let key = buffer.string else {
                throw BencodeDecodeError.invalidFormat
            }
            
            let value = try decode()
            
            result[key] = value
        }
        
        position += 1
        
        return BencodeResult(rawData: result, type: .dictionary)
    }
}
