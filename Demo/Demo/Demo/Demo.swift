//
//  EventBus.swift
//  EventBusPOC
//
//  Created by Pravin Tate on 05/09/24.
//

import Foundation
import Combine
import EventBus

enum SectionType: String, BusComponent {
    case order, result, allergy
    func uniqueKey() -> String {
        rawValue
    }
}

enum EventBusEventImp: String, BusEvent {
    case loading, success, failed

    func eventName() -> String {
        rawValue
    }
}

class EventBusFeatureTester {
    typealias EventType = EventBusEventImp
    weak var eventBus: EventBus<SectionType, EventBusEventImp>?

    init(eventBus: EventBus<SectionType, EventBusEventImp>) {
        self.eventBus = eventBus
    }

    func registerEventBusEvents() {
        guard let eventBus = eventBus else { return }
        eventBus.subscribe(for: .order) { value in
            print("order \(value)")
        }
        eventBus.subscribe(for: .result) { value in
            print("result \(value)")
        }
        eventBus.subscribe(for: .allergy) { value in
            print("allergy \(value)")
        }
    }

    func pubishEventBus(_ event: EventType = .loading) {
        guard let eventBus = eventBus else { return }
        eventBus.publish(event: event, for: .allergy)
        eventBus.publish(event: event, for: .order)
        eventBus.publish(event: event, for: .result)
    }

    func cancelEventBusListListner() {
        guard let eventBus = eventBus else { return }
        eventBus.cancelAllSubscription()
    }
}

class EventBusFeatureTester3 {
    typealias EventType = EventBusEventImp
    weak var eventBus: EventBus<SectionType, EventBusEventImp>?
    init(eventBus: EventBus<SectionType, EventBusEventImp>) {
        self.eventBus = eventBus
    }
    func sink() {
        guard let eventBus = eventBus else { return }
        eventBus.subscribe(for: .order) { value in
            print("🔮🔮 bus reference order \(value)")
        }
        eventBus.subscribe(for: .result) { value in
            print("🔮🔮 bus reference  result \(value)")
        }
        eventBus.subscribe(for: .allergy) { value in
            print("🔮🔮 bus reference  allergy \(value)")
        }
    }
}
/*

    func getResponse(completion: @escaping (String) -> Void) {
        print("Method called ")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion("🔮 Future emitted number")
        }
    }

    func response() -> Future<String, Never> {
        Future { [weak self] promise in
            self?.getResponse { str in
                promise(.success(str))
            }
        }
    }

    func deferedResponse() -> Deferred<AnyPublisher<String, Never>> {
        Deferred {
            self.response()
                .eraseToAnyPublisher()
        }
    }
}
*/
