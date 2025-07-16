import SwiftUI

struct ImagePlaceholderView: View {
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2)
            Image(systemName: "fork.knife.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(Color.gray)
        }
    }
}
