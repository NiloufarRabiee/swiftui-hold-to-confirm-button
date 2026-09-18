import SwiftUI
import HoldToConfirmButton

struct BasicUsage: View {
    @State private var status = "Waiting for confirmation"

    var body: some View {
        VStack(spacing: 24) {
            Text(status)

            HoldToConfirmButton(
                "Hold to Delete",
                systemImage: "trash.fill",
                duration: 1.5,
                tint: .red
            ) {
                status = "Confirmed"
            }
        }
        .padding()
    }
}
