import SwiftUI

// Probably could improve how there are a bunch of constant multipliers across the file 
struct UserAvatarView: View {
    let viewData: UserAvatarViewData
    var size: CGFloat = 80 // Ideally sizing would be abstracted to some design system
    @Binding var hasBeenSelected: Bool

    init(viewData: UserAvatarViewData, size: CGFloat, hasBeenSelected: Binding<Bool>) {
        self.viewData = viewData
        self.size = size
        self._hasBeenSelected = hasBeenSelected
    }

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            AsyncImage(url: viewData.imageUrl) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: size, height: size)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size, height: size)
                        .clipShape(.circle)
                case .failure(_):
                    emptyView
                @unknown default:
                    emptyView
                }
            }
            .overlay(
                Circle()
                    .strokeBorder(
                        borderGradient(selected: hasBeenSelected),
                        lineWidth: size * 0.03
                    )
                    .padding(-size * 0.06)
            )


            Text(viewData.name)
                .font(.system(size: 12))
        }
    }
}

private extension UserAvatarView {
    @ViewBuilder
    var emptyView: some View {
        Image(systemName: "person.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .foregroundStyle(.gray)
            .clipShape(.circle)
    }

    @ViewBuilder
    private func borderGradient(selected: Bool) -> LinearGradient {
        hasBeenSelected ?
            LinearGradient(
                gradient: Gradient(colors: [.gray.opacity(0.5), .gray]),
                startPoint: .top,
                endPoint: .bottom
            ) :
            LinearGradient(
                gradient: Gradient(colors: [.pink, .orange]),
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
    }
}

#Preview {
    // Sample data for preview
    let user = User(
        id: 1,
        name: "Neo",
        profilePictureUrl: URL(string: "https://i.pravatar.cc/300?u=1")!
    )
    let viewData = UserAvatarViewData(user: user)
    HStack(spacing: 20) {
        UserAvatarView(viewData: viewData, size: 100, hasBeenSelected: .constant(true))
        UserAvatarView(viewData: viewData, size: 100, hasBeenSelected: .constant(false))
    }
}
