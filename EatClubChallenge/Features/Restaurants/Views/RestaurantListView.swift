import SwiftUI

struct RestaurantListView<Presenter: RestaurantListPresenting>: View {
    @ObservedObject var presenter: Presenter
    var onRestaurantSelected: ((RestaurantViewModel) -> Void)?
    
    var body: some View {
        NavigationView {
            content
                .navigationTitle("Restaurants")
        }
        .onAppear {
            presenter.loadRestaurants()
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if presenter.isLoading && presenter.restaurants.isEmpty {
            ProgressView("Loading...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let errorMessage = presenter.errorMessage {
            ErrorView(message: errorMessage) {
                presenter.refresh()
            }
        } else {
            restaurantList
        }
    }
    
    private var restaurantList: some View {
        List(presenter.restaurants) { restaurant in
            RestaurantRowView(restaurant: restaurant)
                .contentShape(Rectangle())
                .onTapGesture {
                    onRestaurantSelected?(restaurant)
                }
        }
        .refreshable {
            presenter.refresh()
        }
    }
}

struct RestaurantRowView: View {
    let restaurant: RestaurantViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(restaurant.name)
                .font(.headline)
            
            Text(restaurant.address)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(restaurant.cuisines)
                .font(.caption)
                .foregroundColor(.secondary)
            
            if !restaurant.deals.isEmpty {
                HStack {
                    Image(systemName: "tag.fill")
                        .foregroundColor(.orange)
                        .font(.caption)
                    
                    Text("\(restaurant.deals.count) deals available")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct ErrorView: View {
    let message: String
    let retry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.red)
            
            Text("Error")
                .font(.headline)
            
            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Button("Retry") {
                retry()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}