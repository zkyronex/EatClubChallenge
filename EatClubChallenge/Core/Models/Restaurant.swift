import Foundation

struct RestaurantResponse: Decodable {
    let restaurants: [Restaurant]
}

struct Restaurant: Decodable, Identifiable {
    let objectId: String
    let name: String
    let address1: String
    let suburb: String
    let cuisines: [String]
    let imageLink: String
    let open: String
    let close: String
    let deals: [Deal]
    
    var id: String { objectId }
}

struct Deal: Decodable, Identifiable {
    let objectId: String
    let discount: String
    let dineIn: Bool
    let lightning: Bool
    let qtyLeft: String
    let open: String?
    let close: String?
    let start: String?
    let end: String?
    
    var id: String { objectId }
    
    enum CodingKeys: String, CodingKey {
        case objectId
        case discount
        case dineIn
        case lightning
        case qtyLeft
        case open
        case close
        case start
        case end
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        objectId = try container.decode(String.self, forKey: .objectId)
        discount = try container.decode(String.self, forKey: .discount)
        qtyLeft = try container.decode(String.self, forKey: .qtyLeft)
        open = try container.decodeIfPresent(String.self, forKey: .open)
        close = try container.decodeIfPresent(String.self, forKey: .close)
        start = try container.decodeIfPresent(String.self, forKey: .start)
        end = try container.decodeIfPresent(String.self, forKey: .end)
        
        // Handle dineIn as either Bool or String
        if let boolValue = try? container.decode(Bool.self, forKey: .dineIn) {
            dineIn = boolValue
        } else if let stringValue = try? container.decode(String.self, forKey: .dineIn) {
            dineIn = stringValue.lowercased() == "true"
        } else {
            dineIn = false
        }
        
        // Handle lightning as either Bool or String
        if let boolValue = try? container.decode(Bool.self, forKey: .lightning) {
            lightning = boolValue
        } else if let stringValue = try? container.decode(String.self, forKey: .lightning) {
            lightning = stringValue.lowercased() == "true"
        } else {
            lightning = false
        }
    }
}