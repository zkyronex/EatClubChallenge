import SwiftUI

struct RestaurantCardView: View {
    let restaurant: RestaurantListViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image with deal overlay
            ZStack(alignment: .topLeading) {
                // Restaurant image
                AsyncImage(url: restaurant.imageURL.flatMap(URL.init)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ImagePlaceholderView()
                }
                .frame(height: 180)
                .clipped()
                
                // Deal tag overlay
                if restaurant.maxDiscount > 0 {
                    HStack(spacing: 4) {
                        Text("\(restaurant.maxDiscount)% off")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.dealTagBackground)
                    .cornerRadius(4)
                    .padding(12)
                }
            }
            
            // Restaurant info
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(restaurant.name)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primaryText)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    // Heart icon
                    Image(systemName: "heart")
                        .foregroundColor(.heartIcon)
                        .font(.system(size: 20))
                }
                
                Text(restaurant.shortAddress)
                    .font(.system(size: 14))
                    .foregroundColor(.secondaryText)
                    .lineLimit(1)
                
                Text(restaurant.cuisines)
                    .font(.system(size: 14))
                    .foregroundColor(.tertiaryText)
                    .lineLimit(1)
                
                // Service options
                if restaurant.hasDineIn || restaurant.hasTakeaway || restaurant.hasOrderOnline {
                    HStack(spacing: 8) {
                        if restaurant.hasDineIn {
                            ServiceTag(text: "Dine In")
                        }
                        if restaurant.hasTakeaway {
                            ServiceTag(text: "Takeaway")
                        }
                        if restaurant.hasOrderOnline {
                            ServiceTag(text: "Order Online")
                        }
                    }
                    .padding(.top, 4)
                }
            }
            .padding(16)
        }
        .background(Color.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
    }
}

struct ServiceTag: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: 12))
            .foregroundColor(.secondaryText)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.secondaryText.opacity(0.3), lineWidth: 1)
            )
    }
}
