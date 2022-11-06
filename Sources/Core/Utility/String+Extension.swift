//
//  Created by Alex Vlasov.
//  Copyright © 2018 Alex Vlasov. All rights reserved.
//

import Foundation

extension Character {
    public var toString: String { String(self) }
}

extension String {
    public static func ^(lhs: String, rhs: String) -> String {
        String(format: "%02x", Int(lhs.drop0x, radix: 16)! ^ Int(rhs.drop0x, radix: 16)!)
    }
}

public extension String {

    internal var fullRange: Range<Index> { startIndex..<endIndex }
    var fullNSRange: NSRange { NSRange(fullRange, in: self) }

    internal func index(of char: Character) -> Index? {
        guard let range = range(of: String(char)) else {
            return nil
        }
        return range.lowerBound
    }

    internal func split(intoChunksOf chunkSize: Int) -> [String] {
        var output = [String]()
        let splittedString = map { $0 }
        .split(intoChunksOf: chunkSize)
        splittedString.forEach {
            output.append($0.map { String($0) }.joined(separator: ""))
        }
        return output
    }

    subscript(bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }

    subscript(bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }

    subscript(bounds: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = endIndex
        return String(self[start..<end])
    }

    func leftPadding(toLength: Int, withPad character: Character) -> String {
        let stringLength = count
        if stringLength < toLength {
            return String(repeatElement(character, count: toLength - stringLength)) + self
        } else {
            return String(suffix(toLength))
        }
    }

    func interpretAsBinaryData() -> Data? {
        let padded = padding(toLength: ((count + 7) / 8) * 8, withPad: "0", startingAt: 0)
        let byteArray = padded.split(intoChunksOf: 8).map { UInt8(strtoul($0, nil, 2)) }
        return Data(byteArray)
    }

    var hex: String {
        guard let data = data(using: .utf8) else {
            return String()
        }

        return data.map {
                       String(format: "%02x", $0)
                   }
                   .joined()
    }

    var hexEncoded: String {
        guard let data = data(using: .utf8) else {
            return String()
        }
        return data.toHexString()
    }

    var isHexEncoded: Bool {
        guard starts(with: "0x") else {
            return false
        }
        let regex = try! NSRegularExpression(pattern: "^0x[0-9A-Fa-f]*$")
        if regex.matches(in: self, range: NSRange(startIndex..., in: self)).isEmpty {
            return false
        }
        return true
    }

    var hasHexPrefix: Bool { hasPrefix("0x") }
    var has0xPrefix: Bool { hasPrefix("0x") }

    var drop0x: String {
        if count > 2 && hasHexPrefix {
            return String(dropFirst(2))
        }
        return self
    }

    var add0x: String {
        if hasPrefix("0x") {
            return self
        } else {
            return "0x\(self)"
        }
    }

    var dropParenthesis: String {
        if hasSuffix("()") {
            return String(dropLast(2))
        } else {
            return self
        }
    }

    func isNumeric() -> Bool {
        let numberCharacters = CharacterSet.decimalDigits.inverted
        return !isEmpty && rangeOfCharacter(from: numberCharacters) == nil
    }

    func isNotNumeric() -> Bool { !isNumeric() }

    func index(from: Int) -> Index { index(startIndex, offsetBy: from) }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    /// Strips leading zeroes from a HEX string.
    /// ONLY HEX string format is supported.
    /// - Returns: string with stripped leading zeroes (and 0x prefix) or unchaged string.
    internal func stripLeadingZeroes() -> String {
        let hex = add0x
        guard let matcher = try? NSRegularExpression(pattern: "^(?<prefix>0x)(?<leadingZeroes>0+)(?<end>[0-9a-fA-F]*)$",
            options: .dotMatchesLineSeparators)
        else {
            NSLog("stripLeadingZeroes(): failed to parse regex pattern.")
            return self
        }
        let match = matcher.captureGroups(string: hex, options: .anchored)
        guard match["leadingZeroes"] != nil,
              let prefix = match["prefix"],
              let end = match["end"]
        else { return self }
        return end != "" ? prefix + end : "0x0"
    }

    internal func matchingStrings(regex: String) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
        let nsString = self as NSString
        let results = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
        return results.map { result in
            (0..<result.numberOfRanges).map {
                result.range(at: $0).location != NSNotFound
                    ? nsString.substring(with: result.range(at: $0))
                    : ""
            }
        }
    }

    internal func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location + nsRange.length, limitedBy: utf16.endIndex),
            let from = from16.samePosition(in: self),
            let to = to16.samePosition(in: self)
        else { return nil }
        return from..<to
    }

    internal var asciiValue: Int {
        let s = unicodeScalars
        return Int(s[s.startIndex].value)
    }
}

extension Character {
    var asciiValue: Int {
        let s = String(self).unicodeScalars
        return Int(s[s.startIndex].value)
    }
}
