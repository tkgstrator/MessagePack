import Foundation
import XCTest
@testable import NSMessagePack

class IntegerTests: XCTestCase {
    static var allTests = {
        return [
            ("testPosLiteralConversion", testPosLiteralConversion),
            ("testNegLiteralConversion", testNegLiteralConversion),
            ("testPackNegFixint", testPackNegFixint),
            ("testUnpackNegFixint", testUnpackNegFixint),
            ("testPackPosFixintSigned", testPackPosFixintSigned),
            ("testUnpackPosFixintSigned", testUnpackPosFixintSigned),
            ("testPackPosFixintUnsigned", testPackPosFixintUnsigned),
            ("testUnpackPosFixintUnsigned", testUnpackPosFixintUnsigned),
            ("testPackUInt8", testPackUInt8),
            ("testUnpackUInt8", testUnpackUInt8),
            ("testPackUInt16", testPackUInt16),
            ("testUnpackUInt16", testUnpackUInt16),
            ("testPackUInt32", testPackUInt32),
            ("testUnpackUInt32", testUnpackUInt32),
            ("testPackUInt64", testPackUInt64),
            ("testUnpackUInt64", testUnpackUInt64),
            ("testPackInt8", testPackInt8),
            ("testUnpackInt8", testUnpackInt8),
            ("testPackInt16", testPackInt16),
            ("testUnpackInt16", testUnpackInt16),
            ("testPackInt32", testPackInt32),
            ("testUnpackInt32", testUnpackInt32),
            ("testPackInt64", testPackInt64),
            ("testUnpackInt64", testUnpackInt64),
            ("testUnpackInsufficientData", testUnpackInsufficientData),
        ]
    }()

    func testPosLiteralConversion() {
        let implicitValue: MessagePackValue = -1
        XCTAssertEqual(implicitValue, MessagePackValue.int64(-1))
    }

    func testNegLiteralConversion() {
        let implicitValue: MessagePackValue = 42
        XCTAssertEqual(implicitValue, MessagePackValue.uint64(42))
    }

    func testPackNegFixint() {
        XCTAssertEqual(pack(.int64(-1)), Data([0xff]))
    }

    func testNSFixint() {
        let unpacked1: MessagePackValue = MessagePackValue.array([.int64(25030), .int64(25030), .int64(25030), .int64(25030)])
        let packed1: Data = pack(unpacked1)
        let unpacked2: MessagePackValue = try! unpackFirst(packed1)
        let packed2: Data = pack(unpacked2)

        print("Hex:", packed1.toHexString)
        print("Hex:", packed2.toHexString)
        print(unpacked1)
        print(unpacked2)
        print(unpacked1 == unpacked2)
        XCTAssertEqual(unpacked1, unpacked2)
        XCTAssertEqual(packed1, packed2)
    }

    func testUnpackNegFixint() {
        let unpacked1 = try? unpack(Data([0xff]))
        XCTAssertEqual(unpacked1?.value, .int64(-1))
        XCTAssertEqual(unpacked1?.remainder.count, 0)

        let unpacked2 = try? unpack(Data([0xe0]))
        XCTAssertEqual(unpacked2?.value, .int64(-32))
        XCTAssertEqual(unpacked2?.remainder.count, 0)
    }

    func testPackPosFixintSigned() {
        XCTAssertEqual(pack(.int64(1)), Data([0x01]))
    }

    func testUnpackPosFixintSigned() {
        let unpacked = try? unpack(Data([0x01]))
        XCTAssertEqual(unpacked?.value, .int64(1))
        XCTAssertEqual(unpacked?.remainder.count, 0)
    }

    func testPackPosFixintUnsigned() {
        XCTAssertEqual(pack(.uint64(42)), Data([0x2a]))
    }

    func testUnpackPosFixintUnsigned() {
        let unpacked = try? unpack(Data([0x2a]))
        XCTAssertEqual(unpacked?.value, .uint64(42))
        XCTAssertEqual(unpacked?.remainder.count, 0)
    }

    func testPackUInt8() {
        XCTAssertEqual(pack(.uint64(0xff)), Data([0xcc, 0xff]))
    }

    func testUnpackUInt8() {
        let unpacked = try? unpack(Data([0xcc, 0xff]))
        XCTAssertEqual(unpacked?.value, .uint64(0xff))
        XCTAssertEqual(unpacked?.remainder.count, 0)
    }

    func testPackUInt16() {
        XCTAssertEqual(pack(.uint64(0xffff)), Data([0xcd, 0xff, 0xff]))
    }

    func testUnpackUInt16() {
        let unpacked = try? unpack(Data([0xcd, 0xff, 0xff]))
        XCTAssertEqual(unpacked?.value, .uint64(0xffff))
        XCTAssertEqual(unpacked?.remainder.count, 0)
    }

    func testPackUInt32() {
        XCTAssertEqual(pack(.uint64(0xffff_ffff)), Data([0xce, 0xff, 0xff, 0xff, 0xff]))
    }

    func testUnpackUInt32() {
        let unpacked = try? unpack(Data([0xce, 0xff, 0xff, 0xff, 0xff]))
        XCTAssertEqual(unpacked?.value, .uint64(0xffff_ffff))
        XCTAssertEqual(unpacked?.remainder.count, 0)
    }

    func testPackUInt64() {
        XCTAssertEqual(pack(.uint64(0xffff_ffff_ffff_ffff)), Data([0xcf, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff]))
    }

    func testUnpackUInt64() {
        let unpacked = try? unpack(Data([0xcf, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff]))
        XCTAssertEqual(unpacked?.value, .uint64(0xffff_ffff_ffff_ffff))
        XCTAssertEqual(unpacked?.remainder.count, 0)
    }

    func testPackInt8() {
        XCTAssertEqual(pack(.int64(-0x7f)), Data([0xd0, 0x81]))
    }

    func testUnpackInt8() {
        let unpacked = try? unpack(Data([0xd0, 0x81]))
        XCTAssertEqual(unpacked?.value, .int64(-0x7f))
        XCTAssertEqual(unpacked?.remainder.count, 0)
    }

    func testPackInt16() {
        XCTAssertEqual(pack(.int64(-0x7fff)), Data([0xd1, 0x80, 0x01]))
    }

    func testUnpackInt16() {
        let unpacked = try? unpack(Data([0xd1, 0x80, 0x01]))
        XCTAssertEqual(unpacked?.value, .int64(-0x7fff))
        XCTAssertEqual(unpacked?.remainder.count, 0)
    }

    func testPackInt32() {
        XCTAssertEqual(pack(.int64(-0x1_0000)), Data([0xd2, 0xff, 0xff, 0x00, 0x00]))
    }

    func testUnpackInt32() {
        let unpacked = try? unpack(Data([0xd2, 0xff, 0xff, 0x00, 0x00]))
        XCTAssertEqual(unpacked?.value, .int64(-0x1_0000))
        XCTAssertEqual(unpacked?.remainder.count, 0)
    }

    func testPackInt64() {
        XCTAssertEqual(pack(.int64(-0x1_0000_0000)), Data([0xd3, 0xff, 0xff, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00]))
    }

    func testUnpackInt64() {
        let unpacked = try? unpack(Data([0xd3, 0xff, 0xff, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00]))
        XCTAssertEqual(unpacked?.value, .int64(-0x1_0000_0000))
        XCTAssertEqual(unpacked?.remainder.count, 0)
    }

    func testUnpackInsufficientData() {
        let dataArray: [Data] = [Data([0xd0]), Data([0xd1]), Data([0xd2]), Data([0xd3]), Data([0xd4])]
        for data in dataArray {
            do {
                _ = try unpack(data)
                XCTFail("Expected unpack to throw")
            } catch {
                XCTAssertEqual(error as? MessagePackError, .insufficientData)
            }
        }
    }
}

extension Data {
    var toHexString: String {
        let buffer: [UInt8] = self.withUnsafeBytes({ (pointer: UnsafeRawBufferPointer) -> [UInt8] in
            let unsafeBufferPointer = pointer.bindMemory(to: UInt8.self)
            let unsafePointer = unsafeBufferPointer.baseAddress!
            return [UInt8](UnsafeBufferPointer(start: unsafePointer, count: self.count))
        })
        return buffer.map({ String(format: "%02X", $0) }).joined(separator: " ")
    }
}
