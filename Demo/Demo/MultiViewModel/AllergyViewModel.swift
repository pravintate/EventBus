//
//  AllergyViewModel.swift
//  EventBusPOC
//
//  Created by Pravin Tate on 12/09/24.
//

import Foundation
import Combine

class AllergyViewModel: SectionViewModel {
    var result: PassthroughSubject<[UIModel], Never> = PassthroughSubject<[UIModel], Never>()

    func getData() async throws {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            print("🔮 allergy fire")
            let array = [
                Allergy(allergy: "first Allergy", allergyDetails: "Allergy details 1"),
                Allergy(allergy: "second Allergy", allergyDetails: "Allergy details 2")
                     ]
            guard let self else {
                return
            }
            self.result.send(self.getUIData(array))
        }
    }

    func getUIData(_ data: [Allergy]) -> [UIModel] {
        data.compactMap({ UIModel(title: $0.allergy, header: $0.allergyDetails )})
    }
}

/*
enum Size {
    case small
    case medium
    case large
}

enum Color {
    case red
    case green
    case blue
}

struct Product {

    var name: String
    var color: Color
    var size: Size

}

extension Product : CustomStringConvertible {
    var description: String {
        return "\(size) \(color) \(name)"
    }
}
protocol Specification {
    associatedtype T

    func isSatisfied(item: T) -> Bool
}

struct ColorSpecification: Specification {
    typealias T = Product

    var color: Color

    func isSatisfied(item: Product) -> Bool {
        return item.color == color
    }
}

struct SizeSpecification: Specification {
    typealias T = Product

    var size: Size

    func isSatisfied(item: Product) -> Bool {
        return item.size == size
    }
}

protocol Filter {
    associatedtype T

    func filter<Spec: Specification>(items: [T], specs: Spec) -> [T]
    where Spec.T == T
}

struct ProductFilter : Filter {
    typealias T = Product

    func filter<Spec: Specification>(items: [Product], specs: Spec) -> [Product]
        where ProductFilter.T == Spec.T {
            var output = [T]()
            for item in items {
                if specs.isSatisfied(item: item) {
                    output.append(item)
                }
            }
            return output
    }
}

//MARK: Use Case
let small = SizeSpecification(size: .small)

let result = ProductFilter().filter(items: [tree, frog, strawberry], specs: small)
print(result)
*/
