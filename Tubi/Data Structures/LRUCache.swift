//
//  LRUCache.swift
//  Tubi
//
//  Created by Matthew Dyson on 3/25/19.
//  Copyright © 2019 Matthew Dyson. All rights reserved.
//

import Foundation

public struct LRUCache<Key, Value> where Key: Hashable {
    private class Entry<Key, Value> : Equatable where Key: Equatable {
        let key: Key
        var value: Value
        var previous: Entry<Key, Value>?
        weak var next: Entry<Key, Value>?
        
        init(key: Key, value: Value, previous: Entry<Key, Value>? = nil, next: Entry<Key, Value>? = nil) {
            self.key = key
            self.value = value
            self.previous = previous
            self.next = next
        }
        
        static func == (lhs: Entry<Key, Value>, rhs: Entry<Key, Value>) -> Bool {
            return lhs.key == rhs.key
        }
    }
    
    private var lookup = [Key:Entry<Key, Value>]()
    private var head: Entry<Key, Value>?
    private var tail: Entry<Key, Value>?
    private let size: Int
    
    init(size: Int) {
        self.size = size
    }
    
    public mutating func add(key: Key, value: Value) {
        if let entry = lookup[key] {
            entry.value = value
            moveToTop(entry: entry)
        } else {
            let entry = Entry(key: key, value: value)
            if lookup.count >= size {
                evictTail()
            }
            addToTop(entry: entry)
            lookup[key] = entry
        }
    }
    
    public mutating func get(key: Key) -> Value? {
        if let entry = lookup[key] {
            moveToTop(entry: entry)
            return entry.value
        }
        return nil
    }
    
    public func isValid(key: Key) -> Bool {
        return lookup.keys.contains(key)
    }
    
    private mutating func moveToTop(entry: Entry<Key, Value>) {
        if entry == head {
            return // entry is already at top
        }
        remove(entry: entry)
        addToTop(entry: entry)
    }
    
    private mutating func addToTop(entry: Entry<Key, Value>) {
        entry.next = head
        entry.previous = nil
        
        if let head = head {
            head.previous = entry
        }
        head = entry
        
        if tail == nil {
            tail = head
        }
    }
    
    private mutating func remove(entry: Entry<Key, Value>) {
        if let previous = entry.previous {
            previous.next = entry.next
        } else {
            head = entry.next
        }
        
        if let next = entry.next {
            next.previous = entry.previous
        } else {
            tail = entry.previous
        }
    }
    
    private mutating func evictTail() {
        guard let tail = tail else {
            return
        }
        remove(entry: tail)
        lookup.removeValue(forKey: tail.key)
    }
}
