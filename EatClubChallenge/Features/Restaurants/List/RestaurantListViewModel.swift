import Foundation

struct RestaurantListViewModel: Identifiable, Equatable {
    let id: String
    let name: String
    let shortAddress: String
    let cuisines: String
    let imageURL: String?
    let maxDiscount: Int
    let hasDineIn: Bool
    let hasTakeaway: Bool
    let hasOrderOnline: Bool
    
    init(from restaurant: Restaurant) {
        self.id = restaurant.objectId
        self.name = restaurant.name
        self.shortAddress = "0.5km Away, \(restaurant.suburb)"
        self.cuisines = restaurant.cuisines.joined(separator: ", ")
        self.imageURL = restaurant.imageLink
        
        self.maxDiscount = restaurant.deals.compactMap { Int($0.discount) }.max() ?? 0
        
        self.hasDineIn = true
        self.hasTakeaway = true
        self.hasOrderOnline = true
    }
}