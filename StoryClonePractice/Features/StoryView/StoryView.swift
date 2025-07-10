import SwiftUI

struct StoryView: View {
    @StateObject var viewModel: StoryViewModel
    @State private var messageText: String = ""

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                if viewModel.isLoading {
                    loadingView
                } else if let errorMessage = viewModel.errorMessage {
                    errorView(message: errorMessage)
                } else if let story = viewModel.currentStory {
                    storyContentView(story: story)
                } else {
                    EmptyView()
                }
            }
        }
        .onAppear {
            viewModel.loadStories()
        }
    }
}

private extension StoryView {
    @ViewBuilder
    var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
                .scaleEffect(1.5)
                .foregroundColor(.white)
            Text("Loading story...")
                .padding(.top, 16)
                .foregroundColor(.white)
            Spacer()
        }
    }

    @ViewBuilder
    func errorView(message: String) -> some View {
        VStack {
            Spacer()
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            Text(message)
                .padding()
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            Button("Try Again") {
                viewModel.loadStories()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            Spacer()
        }
        .padding()
    }

    @ViewBuilder
    func storyContentView(story: Story) -> some View {
        VStack(spacing: 0) {
            // Story image
            AsyncImage(url: story.url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .foregroundColor(.white)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure(_):
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()

            // Bottom controls
            VStack(spacing: 8) {
                // Favorite button
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.isFavorite ? viewModel.unfavoriteStory() : viewModel.favoriteStory()
                    }) {
                        Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                            .font(.title)
                            .foregroundColor(viewModel.isFavorite ? .red : .white)
                    }
                    .padding(.trailing)
                }

                // Message input
                HStack {
                    TextField("Send a message...", text: $messageText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(20)

                    Button(action: {
                        if !messageText.isEmpty {
                            viewModel.sendMessage(string: messageText)
                            messageText = ""
                        }
                    }) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.blue)
                    }
                    .disabled(messageText.isEmpty)
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
            .background(Color(.systemBackground))
        }
    }
}

#Preview {
    StoryView(
        viewModel: StoryViewModel(
            storyService: StoryService()
        )
    )
}
