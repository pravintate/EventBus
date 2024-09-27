//
//  EventBus.swift
//  EventBusPOC
//
//  Created by Pravin Tate on 06/09/24.
//

import Foundation
import Combine

public final class EventBus<ComponentType: BusComponent, EventType: BusEvent>: EventBusInterface {
    public typealias Event = EventType
    public typealias Component = ComponentType
    public typealias Failure = Never

    private var store: [ComponentType: PassthroughSubject<EventType, Failure>] = [:]
    private var disposeBag = Set<AnyCancellable>()
    public init() {}
    public func cancelAllSubscription() {
        print("Event bus canceled for \(store.keys.map({ $0 }))")
        disposeBag.removeAll()
        store.removeAll()
    }

    public func publish(event: EventType, for component: ComponentType) {
        if let publisher = store[component] {
            publisher.send(event)
        } else {
            debugPrint("publisher not created for \(component)")
        }
    }

    @discardableResult
    public func subscribe(for component: ComponentType, 
                   _ event: @escaping (EventType) -> Void) -> AnyPublisher<EventType, Never> {
        var publisher = PassthroughSubject<EventType, Failure>()

        if let currentPublisher = store[component] {
            publisher = currentPublisher
        } else {
            let newPublisher = PassthroughSubject<EventType, Failure>()
            store[component] = newPublisher
            publisher = newPublisher
        }
        publisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: event)
            .store(in: &disposeBag)
        return publisher.eraseToAnyPublisher()
    }
}

