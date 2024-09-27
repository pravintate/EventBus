//
//  MainViewModel.swift
//  EventBusPOC
//
//  Created by Pravin Tate on 11/09/24.
//

import Foundation
import Combine
import EventBus

enum ViewModelType: BusComponent {
    case order, result, allergy

}
enum MainViewModelEvent: String, BusEvent {
    case loading, dataReady
}



protocol SectionViewModel: AnyObject {
    var result: PassthroughSubject<[UIModel], Never> { get }
    func getData() async throws
}


final class MainViewModel {
    private var viewModels = [ViewModelType: any SectionViewModel]()
    var data = [ViewModelType: [UIModel]]()
    var disposeBag = Set<AnyCancellable>()
    let eventBus: EventBus<ViewModelType, MainViewModelEvent>

    init(_ viewModels: [ViewModelType: any SectionViewModel],
         eventBus: EventBus<ViewModelType, MainViewModelEvent>) {
        self.viewModels = viewModels
        self.eventBus = eventBus
    }

    func getData(for sectionType: ViewModelType) -> [UIModel] {
        data[sectionType] ?? []
    }

    func fetchData(for sectionType: ViewModelType) {
        if let vm = getViewModel(sectionType) {
            vm.result.sink { [weak self] arr in
                self?.data[sectionType] = arr
                self?.eventBus.publish(event: .dataReady, for: sectionType)
            }.store(in: &disposeBag)

            Task { [weak self] in
                self?.eventBus.publish(event: .loading, for: sectionType)
                try await vm.getData()
            }
        }
    }
}
// eventBus -> notify - data state (loading, dataReady)
// vm -> getData()

private extension MainViewModel {
    func getViewModel(_ section: ViewModelType) -> (any SectionViewModel)? {
        viewModels[section]
    }
}
