//
//  OrderViewModel.swift
//  EventBusPOC
//
//  Created by ________ on 11/09/24.
//

import Foundation
import Combine

class OrderViewModel: SectionViewModel {
    var result: PassthroughSubject<[UIModel], Never> = PassthroughSubject<[UIModel], Never>()
    // useCase - 10
    func getData() async throws {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            print("🔮 order fire")
            let array = [
                Order(orderName: "first order", orderDetails: "order details 1"),
                Order(orderName: "second order", orderDetails: "order details 2")
                     ]
            guard let self else {
                return
            }
            self.result.send(self.getUIData(array))
        }
    }

    func getUIData(_ data: [Order]) -> [UIModel] {
        data.compactMap({ UIModel(title: $0.orderName, header: $0.orderDetails )})
    }
}
