import Foundation

struct RestaurantViewModel: Identifiable {
    let id: String
    let name: String
    let address: String
    let shortAddress: String
    let cuisines: String
    let imageURL: URL?
    let operatingHours: String
    let deals: [DealViewModel]
    let hasDineIn: Bool = true
    let hasTakeaway: Bool = true
    let hasOrderOnline: Bool = true
    
    var bestDeal: DealViewModel? {
        // Sort deals by discount percentage (highest first) and return the best one
        deals.max { deal1, deal2 in
            let discount1 = Int(deal1.discount) ?? 0
            let discount2 = Int(deal2.discount) ?? 0
            return discount1 < discount2
        }
    }
    
    var maxDiscount: Int {
        let discounts = deals.compactMap { Int($0.discount) }
        return discounts.max() ?? 0
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
