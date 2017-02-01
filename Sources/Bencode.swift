import Foundation

public final class Bencode {
    
    public static func decode(data: Data) throws -> Any {
        let decoder = Decoder(with: data)
        return try decoder.decode()
    }
    
}
