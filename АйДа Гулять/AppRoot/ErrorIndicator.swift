//
//  ErrorIndicator.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 04.12.2022.
//

import Foundation
import Combine

/**
 Enables monitoring error of sequence computation.
 */
public final class ErrorIndicator {
    private struct ActivityToken<Source: Publisher> {
        let source: Source
        let errorAction: (Source.Failure) -> Void
        
        func asPublisher() -> AnyPublisher<Source.Output, Never> {
            source.handleEvents(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    errorAction(error)
                }
            })
            .catch { _ in Empty(completeImmediately: true) }
            .eraseToAnyPublisher()
        }
        
        func asPublisherWithFailure() -> AnyPublisher<Source.Output, Source.Failure> {
            source.handleEvents(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    errorAction(error)
                }
            })
            .eraseToAnyPublisher()
        }
    }
    
    @Published
    private var relay: Error?
    private let lock = NSRecursiveLock()
    
    public var errors: AnyPublisher<Error, Never> {
        $relay.compactMap { $0 }.eraseToAnyPublisher()
    }
    
    public init() {}
    
    public func trackErrorOfPublisher<Source: Publisher>(source: Source) -> AnyPublisher<Source.Output, Never> {
        return ActivityToken(source: source) { error in
            self.lock.lock()
            self.relay = error
            self.lock.unlock()
        }.asPublisher()
    }
    
    public func trackErrorOfPublisherWithFailure<Source: Publisher>(source: Source) -> AnyPublisher<Source.Output, Source.Failure> {
        return ActivityToken(source: source) { error in
            self.lock.lock()
            self.relay = error
            self.lock.unlock()
        }.asPublisherWithFailure()
    }
}

extension Publisher {
    public func trackError(_ errorIndicator: ErrorIndicator) -> AnyPublisher<Self.Output, Never> {
        errorIndicator.trackErrorOfPublisher(source: self)
    }
    
    public func trackErrorWithFailure(_ errorIndicator: ErrorIndicator) -> AnyPublisher<Self.Output, Self.Failure> {
        errorIndicator.trackErrorOfPublisherWithFailure(source: self)
    }
}



