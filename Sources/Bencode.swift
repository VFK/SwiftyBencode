import Foundation

public class Bencode {

    static func decode(data: Data) throws -> Any {
        let decoder = Decoder(with: data)
        return try decoder.decode()
    }

}
