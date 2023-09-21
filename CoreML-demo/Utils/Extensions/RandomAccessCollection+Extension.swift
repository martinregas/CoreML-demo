//
//  RandomAccessCollection+Extension.swift
//  CoreML-demo
//
//  Created by Martin Regas on 15/09/2023.
//

import Foundation

extension RandomAccessCollection {
    subscript(index: Index) -> Element? {
        self.indices.contains(index) ? (self[index] as Element) : nil
    }
}
