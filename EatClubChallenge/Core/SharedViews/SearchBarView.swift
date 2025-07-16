import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    let placeholder: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondaryText)
                .font(.system(size: 16))
            
            TextField(placeholder, text: $searchText)
                .font(.system(size: 16))
                .foregroundColor(.primaryText)
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondaryText)
                        .font(.system(size: 16))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.searchBarBackground)
        .cornerRadius(8)
    }
}