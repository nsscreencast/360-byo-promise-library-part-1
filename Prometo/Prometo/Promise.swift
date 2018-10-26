//
//  Promise.swift
//  Prometo
//
//  Created by Ben Scheirman on 10/25/18.
//  Copyright © 2018 NSScreencast. All rights reserved.
//

import Foundation

class Promise<T> {
    var value: T?
    var error: Error?
    
    private var thenBlocks: [(T)->Void] = []
    private var catchBlocks: [(Error)->Void] = []
    
    init(value: T) {
        self.value = value
    }
    
    init() {
    }
    
    func then(_ thenBlock: @escaping (T) -> Void) -> Promise<T> {
        thenBlocks.append(thenBlock)
        return self
    }
    
    @discardableResult
    func `catch`(_ errorBlock: @escaping (Error)->Void) -> Promise<T> {
        catchBlocks.append(errorBlock)
        return self
    }
    
    func map<S>(_ transformBlock: @escaping (T)->S) -> Promise<S> {
        let promise = Promise<S>()
        then { value in
            let transformedValue = transformBlock(value)
            promise.fulfill(transformedValue)
        }.catch { e in
            promise.fail(e)
        }
        return promise
    }
    
    func fulfill(_ value: T) {
        self.value = value
        thenBlocks.forEach { block in
            block(value)
        }
    }
    
    func fail(_ error: Error) {
        self.error = error
        catchBlocks.forEach { block in
            block(error)
        }
    }
}
