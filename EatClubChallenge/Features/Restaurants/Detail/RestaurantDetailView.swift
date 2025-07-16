import SwiftUI

struct RestaurantDetailView: View {
    let restaurant: RestaurantViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom navigation bar
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.primaryText)
                }
                
                Spacer()
                
                Text("Restaurant Details")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primaryText)
                
                Spacer()
                
                Image(systemName: "heart")
                    .font(.system(size: 20))
                    .foregroundColor(.heartIcon)
            }
            .padding(.horizontal)
            .padding(.vertical, 16)
            .background(Color.white)
            
            ScrollView {
                VStack(spacing: 0) {
                    // Hero image with carousel dots
                    ZStack(alignment: .bottom) {
                        // Restaurant image
                        AsyncImage(url: restaurant.imageURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ImagePlaceholderView()
                        }
                        .frame(height: 250)
                        .clipped()
                        
                        // Carousel dots
                        HStack(spacing: 8) {
                            ForEach(0..<5) { index in
                                Circle()
                                    .fill(index == 0 ? Color.white : Color.white.opacity(0.5))
                                    .frame(width: 8, height: 8)
                            }
                        }
                        .padding(.bottom, 16)
                        
                        // New tag
                        VStack {
                            HStack {
                                Spacer()
                                Text("★ New")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.eatClubRed)
                                    .cornerRadius(4)
                                    .padding()
                            }
                            Spacer()
                        }
                    }
                    
                    VStack(spacing: 0) {
                        // Action buttons
                        HStack(spacing: 0) {
                            ActionButton(icon: "doc.text", text: "Menu")
                            ActionButton(icon: "phone", text: "Call us")
                            ActionButton(icon: "location", text: "Location")
                            ActionButton(icon: "heart", text: "Favourite")
                        }
                        .padding(.vertical, 16)
                        .background(Color.white)
                        
                        Divider()
                        
                        // Restaurant info
                        VStack(alignment: .leading, spacing: 16) {
                            Text(restaurant.name)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.primaryText)
                            
                            HStack(spacing: 16) {
                                Text(restaurant.cuisines)
                                    .font(.system(size: 16))
                                    .foregroundColor(.secondaryText)
                                
                                Text("$")
                                    .font(.system(size: 16))
                                    .foregroundColor(.secondaryText)
                            }
                            
                            // Hours
                            HStack(spacing: 8) {
                                Image(systemName: "clock")
                                    .font(.system(size: 16))
                                    .foregroundColor(.secondaryText)
                                
                                Text("Hours: \(restaurant.operatingHours)")
                                    .font(.system(size: 16))
                                    .foregroundColor(.primaryText)
                            }
                            
                            // Address
                            HStack(spacing: 8) {
                                Image(systemName: "location")
                                    .font(.system(size: 16))
                                    .foregroundColor(.secondaryText)
                                
                                Text(restaurant.address)
                                    .font(.system(size: 16))
                                    .foregroundColor(.primaryText)
                            }
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        
                        // Deals section
                        if !restaurant.deals.isEmpty {
                            VStack(spacing: 12) {
                                ForEach(restaurant.deals) { deal in
                                    DealCard(deal: deal)
                                }
                            }
                            .padding(16)
                        }
                    }
                }
            }
            .background(Color.backgroundGray)
        }
        .navigationBarHidden(true)
    }
}

struct ActionButton: View {
    let icon: String
    let text: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.secondaryText)
            
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(.secondaryText)
        }
        .frame(maxWidth: .infinity)
    }
}

struct DealCard: View {
    let deal: DealViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    if deal.isLightning {
                        Image(systemName: "bolt.fill")
                            .foregroundColor(.lightningYellow)
                            .font(.system(size: 16))
                    }
                    
                    Text("\(deal.discount)% Off")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.eatClubRed)
                }
                
                if let availability = deal.availability {
                    Text("Between \(availability)")
                        .font(.system(size: 14))
                        .foregroundColor(.secondaryText)
                }
                
                Text("\(deal.quantityLeft) Deals Left")
                    .font(.system(size: 14))
                    .foregroundColor(.tertiaryText)
            }
            
            Spacer()
            
            Button("Redeem") {
                // Handle redeem action
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.eatClubRed, lineWidth: 2)
            )
            .foregroundColor(.eatClubRed)
            .font(.system(size: 16, weight: .medium))
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(8)
    }
}
