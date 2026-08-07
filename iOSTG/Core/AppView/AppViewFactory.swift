struct AppViewFactory<TabbarView: View, OnboardingView: View>: View {
    var showTabbar: Bool = false
    @ViewBuilder var tabbarView: () -> TabbarView
    @ViewBuilder var onboardingView: () -> OnboardingView
    var body: some View {
        ZStack {
            if showTabbar {
                tabbarView()
                    .transition(.move(edge: .trailing))
            } else {
                onboardingView()
                    .transition(.move(edge: .leading))
            }
        }
        .animation(.smooth, value: showTabbar)
    }
}