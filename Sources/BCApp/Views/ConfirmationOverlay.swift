import SwiftUI

struct ConfirmationOverlay: View {
    let image: Image
    let title: String
    let message: String?

    init(image: Image, title: String, message: String? = nil) {
        self.image = image
        self.title = title
        self.message = message
    }

    var body: some View {
        VStack(spacing: 10) {
            Group {
                image
                Text(title)
            }
            .font(Font.system(.title).bold())
            if let message = message {
                Text(message)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .aspectRatio(1, contentMode: .fill)
        .frame(width: 200, height: 200)
        .background(BlurView(style: .systemChromeMaterial))
        .cornerRadius(20)
    }
}

#if DEBUG

struct ConfirmationOverlay_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
        Text("""
            Morbi leo risus, porta ac consectetur ac, vestibulum at eros. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor.
            """)
            .foregroundColor(Color.red)
            ConfirmationOverlay(image: Image.confirmCopy, title: "Copied!", message: "The clipboard will be erased in 30 seconds.")
        }
        .darkMode()
    }
}

#endif
