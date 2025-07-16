import SwiftUI

struct RestaurantDetailView: View {
    @ObservedObject var presenter: RestaurantDetailPresenter
    @Environment(\.dismiss) var dismiss
    
    init(presenter: RestaurantDetailPresenter) {
        self.presenter = presenter
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero image with carousel dots
                ZStack(alignment: .bottom) {
                    // Restaurant image
                    AsyncImage(url: presenter.restaurant?.imageURL.flatMap(URL.init)) { image in
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
                            if presenter.restaurant?.isNew == true {
                                Text("★ New")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.eatClubRed)
                                    .cornerRadius(4)
                                    .padding()
                            }
                        }
                        Spacer()
                    }
                }
                
                VStack(spacing: 0) {
                    // Action buttons
                    HStack(spacing: 0) {
                        ActionButton(icon: "doc.text", text: "Menu") {
                            presenter.showMenu()
                        }
                        ActionButton(icon: "phone", text: "Call us") {
                            presenter.callRestaurant()
                        }
                        ActionButton(icon: "location", text: "Location") {
                            presenter.showLocation()
                        }
                        ActionButton(icon: "heart", text: "Favourite") {
                            presenter.toggleFavourite()
                        }
                    }
                    .padding(.vertical, 16)
                    .background(Color.white)
                    
                    Divider()
                    
                    // Restaurant info
                    VStack(alignment: .leading, spacing: 16) {
                        Text(presenter.restaurant?.name ?? "")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.primaryText)
                        
                        HStack(spacing: 16) {
                            Text(presenter.restaurant?.cuisines ?? "")
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
                            
                            Text(presenter.restaurant?.operatingHours ?? "")
                                .font(.system(size: 16))
                                .foregroundColor(.primaryText)
                        }
                        
                        // Address
                        HStack(spacing: 8) {
                            Image(systemName: "location")
                                .font(.system(size: 16))
                                .foregroundColor(.secondaryText)
                            
                            Text(presenter.restaurant?.address ?? "")
                                .font(.system(size: 16))
                                .foregroundColor(.primaryText)
                        }
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    
                    // Deals section
                    if let deals = presenter.restaurant?.deals, !deals.isEmpty {
                        VStack(spacing: 12) {
                            ForEach(deals) { deal in
                                DealCard(deal: deal) {
                                    presenter.redeemDeal(deal)
                                }
                            }
                        }
                        .padding(16)
                    }
                }
            }
        }
    }
}


struct ActionButton: View {
    let icon: String
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
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
}

struct DealCard: View {
    let deal: DealViewModel
    let onRedeem: () -> Void
    
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
                
                if !deal.availability.isEmpty {
                    Text("Between \(deal.availability)")
                        .font(.system(size: 14))
                        .foregroundColor(.secondaryText)
                }
                
                Text("\(deal.quantityLeft) Deals Left")
                    .font(.system(size: 14))
                    .foregroundColor(.tertiaryText)
            }
            
            Spacer()
            
            Button("Redeem", action: onRedeem)
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