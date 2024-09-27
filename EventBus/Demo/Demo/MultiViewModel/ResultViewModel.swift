//
//  ResultViewModel.swift
//  EventBusPOC
//
//  Created by Pravin Tate on 11/09/24.
//

import Foundation
import Combine

class ResultViewModel: SectionViewModel {
    var result: PassthroughSubject<[UIModel], Never> = PassthroughSubject<[UIModel], Never>()
    typealias DataType = Result
    typealias UIDataType = UIModel


    func getData() async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            print("🔮 result fire")
            let array = [
                Result(result: "first Result", resultDetails: "Result details 1"),
                Result(result: "second Result", resultDetails: "Result details 2")
                     ]
            guard let self else {
                return
            }
            self.result.send(self.getUIData(array))
        }
    }

    func getUIData(_ data: [DataType]) -> [UIDataType] {
        data.compactMap({ UIModel(title: $0.result, header: $0.resultDetails )})
    }
}
