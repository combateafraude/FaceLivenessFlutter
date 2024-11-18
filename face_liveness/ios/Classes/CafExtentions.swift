extension UIApplication {
    var currentKeyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
                .filter { $0.activationState == .foregroundActive }
                .last?.windows
                .last(where: \.isKeyWindow) ?? UIApplication.shared.windows.last
        } else {
            return UIApplication.shared.windows.last
        }
    }
}
