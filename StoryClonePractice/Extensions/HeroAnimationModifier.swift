import SwiftUI

extension View {
    func heroAnimation<ID: Hashable>(
        id: ID,
        namespace: Namespace.ID,
        isActive: Bool
    ) -> some View {
        self.modifier(HeroAnimationModifier(id: id, namespace: namespace, isActive: isActive))
    }
}

struct HeroAnimationModifier<ID: Hashable>: ViewModifier {
    let id: ID
    let namespace: Namespace.ID
    let isActive: Bool
    
    func body(content: Content) -> some View {
        content
            .matchedGeometryEffect(id: id, in: namespace, isSource: !isActive)
    }
}

struct HeroTransition: ViewModifier {
    let isPresented: Bool
    
    func body(content: Content) -> some View {
        content
            .opacity(isPresented ? 1 : 0)
            .scaleEffect(isPresented ? 1 : 0.3)
            .animation(.spring(response: 0.35, dampingFraction: 0.7), value: isPresented)
    }
} 
