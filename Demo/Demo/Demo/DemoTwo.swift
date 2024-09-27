//
//  DemoTwo.swift
//  EventBusPOC
//
//  Created by Pravin Tate on 06/09/24.
//

import Foundation
import EventBus

enum AppComponent: String, BusComponent {
    case login, pay, logout
    func uniqueKey() -> String {
        rawValue
    }
}

enum AppEvent: String, BusEvent {
    case loading, success, failed

    func eventName() -> String {
        rawValue
    }
}

class EventBusFeatureTester2 {
    typealias EventType = AppEvent
    let eventBus = EventBus<AppComponent, EventType>()

    func sink() {
        eventBus.subscribe(for: .login) { value in
            print("login \(value)")
        }
        eventBus.subscribe(for: .pay) { value in
            print("pay \(value)")
        }
        eventBus.subscribe(for: .logout) { value in
            print("logout \(value)")
        }
    }

    func fireEvent(_ event: EventType = .loading) {
        eventBus.publish(event: event, for: .login)
        eventBus.publish(event: event, for: .pay)
        eventBus.publish(event: event, for: .logout)
    }

    func cancel() {
        eventBus.cancelAllSubscription()
    }
}

final class EventBusContainer {
    static let shared = EventBusContainer()
    private init() {}

    var container: [String: any EventBusInterface] = [:]

    func register(bus: any EventBusInterface, identifier: String) {
        container[identifier] = bus
    }

    func getBus(for identifier: String) -> (any EventBusInterface)? {
        let bus = container[identifier]
        return bus
    }

    func cleanBus(for identifier: String) {
        container[identifier] = nil
    }
}
