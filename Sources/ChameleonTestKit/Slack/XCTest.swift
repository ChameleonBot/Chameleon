import Foundation

// Borrowed from: https://github.com/pointfreeco/swift-composable-architecture/blob/master/Sources/ComposableArchitecture/TestSupport/TestStore.swift
//
// NB: Dynamically load XCTest to prevent leaking its symbols into library code.
func _XCTFail(_ message: String = "", file: StaticString = #file, line: UInt = #line) {
    guard
        let _XCTFailureHandler = _XCTFailureHandler,
        let _XCTCurrentTestCase = _XCTCurrentTestCase
        else { return assertionFailure("Couldn't load XCTest", file: file, line: line) }

    _XCTFailureHandler(_XCTCurrentTestCase(), true, "\(file)", line, message, nil)
}

private typealias XCTCurrentTestCase = @convention(c) () -> AnyObject
private typealias XCTFailureHandler = @convention(c) (AnyObject, Bool, UnsafePointer<CChar>, UInt, String, String?) -> Void

private let _XCTest = NSClassFromString("XCTest")
    .flatMap(Bundle.init(for:))
    .flatMap({ $0.executablePath })
    .flatMap({ dlopen($0, RTLD_NOW) })

private let _XCTFailureHandler =
    _XCTest
        .flatMap { dlsym($0, "_XCTFailureHandler") }
        .map({ unsafeBitCast($0, to: XCTFailureHandler.self) })

private let _XCTCurrentTestCase =
    _XCTest
        .flatMap { dlsym($0, "_XCTCurrentTestCase") }
        .map({ unsafeBitCast($0, to: XCTCurrentTestCase.self) })
