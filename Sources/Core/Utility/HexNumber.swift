//
// Created by Dan Capecci CTR on 11/6/22.
//

import Foundation
import Foundation
import BigInt

enum HexNumberError: Error {
    case invalidHexString
}

public struct HexNumber: Codable, Hashable {
    public var bigInt: BigInt { BigInt(rawValue.drop0x, radix: 16)! }
    public var bigUInt: BigUInt { BigUInt(rawValue.drop0x, radix: 16)! }
    public var intValue: Int { Int(rawValue.drop0x, radix: 16)! }
    public var hexValue: String { rawValue }
    private var rawValue: String

    public init(_ string: String) { rawValue = string.add0x }

    public init?(_ double: Double) {
        let b = BigInt(double)
        self.init(b)
    }

    public init?(_ bigUInt: BigUInt?) {
        guard let i = bigUInt else { return nil }
        rawValue = String(i, radix: 16).add0x
    }

    public init?(_ bigInt: BigInt?) {
        guard let i = bigInt else { return nil }
        rawValue = String(i, radix: 16).add0x
    }

}

extension HexNumber: Comparable {
    public static func <(lhs: HexNumber, rhs: HexNumber) -> Bool { lhs.bigInt < rhs.bigInt }
}

extension String {
    public var hexNumber: HexNumber { HexNumber(self) }
}

//extension BigUInt {

//    func * (lhs: Double, rhs: BigUInt) -> Double {
//

//}
//}
