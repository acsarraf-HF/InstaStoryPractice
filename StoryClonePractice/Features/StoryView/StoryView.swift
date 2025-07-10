import SwiftUI

struct StoryView: View {
    @StateObject var viewModel: StoryViewModel
    @State private var messageText: String = ""
    let namespace: Namespace.ID
    let userId: Int
    let onDismiss: () -> Void
    @State private var isAnimationComplete = false

    var body: some View {
        ZStack {
            if let story = viewModel.currentStory {
                AsyncImage(url: story.url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .blur(radius: 30)
                            .brightness(-0.2)
                            .saturation(0.8)
                    default:
                        Color.black
                    }
                }
                .ignoresSafeArea()
                
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
            } else {
                Color.gray.opacity(0.6).ignoresSafeArea()
            }

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            onDismiss()
                        }
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 16)
                    .padding(.top, 8)
                }
                
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
            .padding(32)
            .heroAnimation(id: userId, namespace: namespace, isActive: true)
            .modifier(HeroTransition(isPresented: isAnimationComplete))
        }
        .onAppear {
            viewModel.loadStories()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    isAnimationComplete = true
                }
            }
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
            // Main story image (no background blur here since it's applied to whole view)
            AsyncImage(url: story.url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .foregroundColor(.white)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure(_):
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .padding(.vertical)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.2))
            .cornerRadius(12)

            // Bottom controls with improved layout
            VStack(spacing: 12) {
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
                    .padding(.trailing, 8)
                }

                // Message input and send button in HStack
                HStack(spacing: 12) {
                    TextField("Send a message...", text: $messageText)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(20)
                        .frame(maxWidth: .infinity)

                    Button(action: {
                        if !messageText.isEmpty {
                            viewModel.sendMessage(string: messageText)
                            messageText = ""
                        }
                    }) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                            .frame(width: 44, height: 44)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
                    .disabled(messageText.isEmpty)
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
            }
            .padding(.top, 8)
            .background(.ultraThinMaterial)
            .cornerRadius(16)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @Namespace var previewNamespace
        
        var body: some View {
            StoryView(
                viewModel: StoryViewModel(
                    storyService: StoryService()
                ),
                namespace: previewNamespace,
                userId: 1,
                onDismiss: {}
            )
        }
    }
    
    return PreviewWrapper()
}
