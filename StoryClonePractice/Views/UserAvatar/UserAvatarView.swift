import SwiftUI

struct UserAvatarView: View {
    let viewData: UserAvatarViewData
    var size: CGFloat = 64 // Ideally sizing would be abstracted to some design system

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

            Text(viewData.name)
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
}

#Preview {
    // Sample data for preview
    let user = User(
        id: 1,
        name: "Neo",
        profilePictureUrl: URL(string: "https://i.pravatar.cc/300?u=1")!
    )
    let viewData = UserAvatarViewData(user: user)
    UserAvatarView(viewData: viewData, size: 100)
}
