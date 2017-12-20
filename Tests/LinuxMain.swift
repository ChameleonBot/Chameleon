import XCTest
@testable import Common

XCTMain([
    //Common
    testCase(CollectionTests.allTests),
    testCase(DictionaryTests.allTests),
    testCase(KeyPathAccessibleTests.allTests),
    testCase(NeighborSequenceTests.allTests),
    testCase(ResultTests.allTests),
    testCase(StringTests.allTests),
    testCase(TimeIntervalTests.allTests),
])
