import Foundation

struct RestaurantDetailViewModel: Equatable {
    let id: String
    let name: String
    let address: String
    let cuisines: String
    let imageURL: String?
    let operatingHours: String
    let deals: [DealViewModel]
    let isNew: Bool
    
    var hasDineIn: Bool {
        deals.contains { $0.isDineIn }
    }
    
    var hasTakeaway: Bool {
        true
    }
    
    var hasOrderOnline: Bool {
        true
    }
    
    init(from restaurant: Restaurant) {
        self.id = restaurant.objectId
        self.name = restaurant.name
        self.address = "\(restaurant.address1) \(restaurant.suburb) • 0.5km Away"
        self.cuisines = restaurant.cuisines.joined(separator: " • ")
        self.imageURL = restaurant.imageLink
        self.operatingHours = "Hours: \(restaurant.open) - \(restaurant.close)"
        self.deals = restaurant.deals
            .map(DealViewModel.init)
            .sorted { $0.discount > $1.discount }
        self.isNew = true
    }
}

struct DealViewModel: Identifiable, Equatable {
    let id: String
    let discount: Int
    let isDineIn: Bool
    let isLightning: Bool
    let quantityLeft: Int
    let availability: String
    
    init(from deal: Deal) {
        self.id = deal.objectId
        self.discount = Int(deal.discount) ?? 0
        self.isDineIn = deal.dineIn
        self.isLightning = deal.lightning
        self.quantityLeft = Int(deal.qtyLeft) ?? 5
        
        if let open = deal.open, let close = deal.close {
            self.availability = "\(open) - \(close)"
        } else {
            self.availability = ""
        }
    }
}