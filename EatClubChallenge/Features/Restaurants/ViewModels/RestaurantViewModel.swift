import Foundation

struct RestaurantViewModel: Identifiable {
    let id: String
    let name: String
    let address: String
    let cuisines: String
    let imageURL: URL?
    let operatingHours: String
    let deals: [DealViewModel]
    
    init(from restaurant: Restaurant) {
        self.id = restaurant.objectId
        self.name = restaurant.name
        self.address = "\(restaurant.address1), \(restaurant.suburb)"
        self.cuisines = restaurant.cuisines.joined(separator: ", ")
        self.imageURL = URL(string: restaurant.imageLink)
        self.operatingHours = "\(restaurant.open) - \(restaurant.close)"
        self.deals = restaurant.deals.map { DealViewModel(from: $0) }
    }
}

struct DealViewModel: Identifiable {
    let id: String
    let discount: String
    let isDineIn: Bool
    let isLightning: Bool
    let quantityLeft: String
    let availability: String?
    
    init(from deal: Deal) {
        self.id = deal.objectId
        self.discount = deal.discount
        self.isDineIn = deal.dineIn
        self.isLightning = deal.lightning
        self.quantityLeft = deal.qtyLeft
        
        if let open = deal.open, let close = deal.close {
            self.availability = "\(open) - \(close)"
        } else {
            self.availability = nil
        }
    }
}