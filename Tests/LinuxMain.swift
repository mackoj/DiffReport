import XCTest

import testReportDiffTests

var tests = [XCTestCaseEntry]()
tests += testReportDiffTests.allTests()
XCTMain(tests)
