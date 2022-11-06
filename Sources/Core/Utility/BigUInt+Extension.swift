//
//  RIPEMD160_SO.swift
//
//  Created by Alexander Vlasov on 10.01.2018.
//

import struct BigInt.BigUInt
import Foundation

public extension BigUInt {
    init?(_ naturalUnits: String, _ ethereumUnits: Utilities.Units) {
        guard let value = Utilities.parseToBigUInt(naturalUnits, units: ethereumUnits) else { return nil }
        self = value
    }
}
