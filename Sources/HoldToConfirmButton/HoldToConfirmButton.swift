import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

/// A lightweight SwiftUI control that requires a continuous press before executing an action.
public struct HoldToConfirmButton: View {
    private let title: String
    private let systemImage: String?
    private let duration: TimeInterval
    private let tint: Color
    private let height: CGFloat
    private let action: () -> Void

    @Environment(\.isEnabled) private var isEnabled

    @State private var progress: CGFloat = 0
    @State private var isPressing = false
    @State private var hasConfirmed = false
    @State private var holdTask: Task<Void, Never>?

    public init(
        _ title: String,
        systemImage: String? = "checkmark.circle.fill",
        duration: TimeInterval = 1.5,
        tint: Color = .accentColor,
        height: CGFloat = 54,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.duration = HoldToConfirmConfiguration.normalizedDuration(duration)
        self.tint = tint
        self.height = max(height, 44)
        self.action = action
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule(style: .continuous)
                    .fill(Color.secondary.opacity(0.14))

                Capsule(style: .continuous)
                    .fill(tint.opacity(isEnabled ? 0.90 : 0.35))
                    .frame(width: geometry.size.width * progress)

                label
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundStyle(isEnabled ? Color.primary : Color.secondary)
            }
            .contentShape(Capsule(style: .continuous))
            .scaleEffect(isPressing ? 0.985 : 1)
            .animation(.easeOut(duration: 0.15), value: isPressing)
            .gesture(holdGesture)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(title)
            .accessibilityHint("Press and hold to confirm")
            .accessibilityAddTraits(.isButton)
            .onDisappear {
                cancelHold(animated: false)
            }
        }
        .frame(height: height)
    }

    @ViewBuilder
    private var label: some View {
        HStack(spacing: 8) {
            if let systemImage {
                Image(systemName: systemImage)
                    .imageScale(.medium)
            }

            Text(hasConfirmed ? "Confirmed" : title)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 16)
    }

    private var holdGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { _ in
                startHoldIfNeeded()
            }
            .onEnded { _ in
                if hasConfirmed {
                    resetAfterConfirmation()
                } else {
                    cancelHold(animated: true)
                }
            }
    }

    private func startHoldIfNeeded() {
        guard isEnabled, !isPressing, !hasConfirmed else { return }

        isPressing = true
        progress = 0

        withAnimation(.linear(duration: duration)) {
            progress = 1
        }

        holdTask?.cancel()
        holdTask = Task { @MainActor in
            let nanoseconds = UInt64(duration * 1_000_000_000)

            do {
                try await Task.sleep(nanoseconds: nanoseconds)
            } catch {
                return
            }

            guard !Task.isCancelled, isPressing else { return }

            hasConfirmed = true
            triggerSuccessFeedback()
            action()
        }
    }

    private func cancelHold(animated: Bool) {
        holdTask?.cancel()
        holdTask = nil
        isPressing = false
        hasConfirmed = false

        if animated {
            withAnimation(.easeOut(duration: 0.20)) {
                progress = 0
            }
        } else {
            progress = 0
        }
    }

    private func resetAfterConfirmation() {
        holdTask?.cancel()
        holdTask = nil
        isPressing = false

        withAnimation(.easeOut(duration: 0.20)) {
            progress = 0
        }

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 250_000_000)
            hasConfirmed = false
        }
    }

    private func triggerSuccessFeedback() {
        #if canImport(UIKit)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        #endif
    }
}

enum HoldToConfirmConfiguration {
    static let minimumDuration: TimeInterval = 0.1
    static let fallbackDuration: TimeInterval = 1.5

    static func normalizedDuration(_ duration: TimeInterval) -> TimeInterval {
        guard duration.isFinite else {
            return fallbackDuration
        }

        return max(duration, minimumDuration)
    }
}

#Preview {
    VStack(spacing: 20) {
        HoldToConfirmButton(
            "Hold to Delete",
            systemImage: "trash.fill",
            duration: 1.5,
            tint: .red
        ) {
            print("Delete confirmed")
        }

        HoldToConfirmButton(
            "Hold to Continue",
            systemImage: "arrow.right.circle.fill",
            duration: 1
        ) {
            print("Continue confirmed")
        }
    }
    .padding()
}
