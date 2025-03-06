//
//  Collection+Ex.swift
//  BaseIOS
//
//  Created by Hoàn Nguyễn on 3/7/25.
//

public extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

public extension Array {
    subscript(safe range: Range<Index>) -> ArraySlice<Element>? {
        if range.endIndex > endIndex {
            if range.startIndex >= endIndex { return nil }
            else { return self[range.startIndex..<endIndex] }
        }
        else {
            return self[range]
        }
    }
}
