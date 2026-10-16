#if canImport(Testing)
import Testing
import NativeTls

@Suite("NativeTls Swift Export Tests")
struct NativeTlsExportTests {
    @Test("NativeTls swift module imported cleanly")
    func testSwiftModuleLoads() throws {
        #expect(Bool(true), "NativeTls swift module imported cleanly")
    }
}
#elseif canImport(XCTest)
import XCTest
import NativeTls

final class NativeTlsExportTests: XCTestCase {
    func testSwiftModuleLoads() throws {
        XCTAssertTrue(true, "NativeTls swift module imported cleanly")
    }
}
#endif
