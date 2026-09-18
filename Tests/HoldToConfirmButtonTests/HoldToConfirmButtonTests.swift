import XCTest
@testable import HoldToConfirmButton

final class HoldToConfirmButtonTests: XCTestCase {
    func testDurationAboveMinimumIsPreserved() {
        XCTAssertEqual(
            HoldToConfirmConfiguration.normalizedDuration(1.5),
            1.5,
            accuracy: 0.0001
        )
    }

    func testDurationBelowMinimumIsClamped() {
        XCTAssertEqual(
            HoldToConfirmConfiguration.normalizedDuration(0),
            HoldToConfirmConfiguration.minimumDuration,
            accuracy: 0.0001
        )
    }

    func testNegativeDurationIsClamped() {
        XCTAssertEqual(
            HoldToConfirmConfiguration.normalizedDuration(-2),
            HoldToConfirmConfiguration.minimumDuration,
            accuracy: 0.0001
        )
    }

    func testInfiniteDurationUsesFallback() {
        XCTAssertEqual(
            HoldToConfirmConfiguration.normalizedDuration(.infinity),
            HoldToConfirmConfiguration.fallbackDuration,
            accuracy: 0.0001
        )
    }

    func testNaNDurationUsesFallback() {
        XCTAssertEqual(
            HoldToConfirmConfiguration.normalizedDuration(.nan),
            HoldToConfirmConfiguration.fallbackDuration,
            accuracy: 0.0001
        )
    }
}
