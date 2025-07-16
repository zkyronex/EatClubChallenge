import SwiftUI

struct RestaurantListView<Presenter: RestaurantListPresenting>: View {
    @ObservedObject var presenter: Presenter
    var onRestaurantSelected: ((RestaurantViewModel) -> Void)?
    @State private var selectedTab: Int = 1 // Moon icon selected by default
    
    var body: some View {
        VStack(spacing: 0) {
            // Search bar
            SearchBarView(
                searchText: $presenter.searchText,
                placeholder: "e.g. chinese, pizza"
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.white)
            
            // Content
            content
        }
        .background(Color.backgroundGray)
        .onAppear {
            presenter.loadRestaurants()
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if presenter.isLoading && presenter.restaurants.isEmpty {
            ProgressView("Loading...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.backgroundGray)
        } else if let errorMessage = presenter.errorMessage {
            ErrorView(message: errorMessage) {
                presenter.refresh()
            }
            .background(Color.backgroundGray)
        } else {
            restaurantList
        }
    }
    
    private var restaurantList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(presenter.filteredRestaurants) { restaurant in
                    Button(action: { presenter.select(restaurant: restaurant) }) {
                        RestaurantCardView(restaurant: restaurant)
                    }
                }
            }
            .padding(16)
        }
        .refreshable {
            presenter.refresh()
        }
    }
}

struct ErrorView: View {
    let message: String
    let retry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.eatClubRed)
            
            Text("Error")
                .font(.headline)
            
            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondaryText)
            
            Button("Retry") {
                retry()
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .background(Color.eatClubOrange)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
