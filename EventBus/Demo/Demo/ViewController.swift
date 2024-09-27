//
//  ViewController.swift
//  EventBusPOC
//
//  Created by Pravin Tate on 05/09/24.
//

import UIKit
import Combine
import EventBus

class ViewController: UIViewController {
    var secondVc: SecondVC?
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        setupButton()
    }

    private func setupButton() {
        let btn = UIButton()
        btn.setTitle("Push", for: .normal)
        btn.backgroundColor = .blue
        btn.layer.cornerRadius = 20
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(done), for: .touchUpInside)
        btn.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        btn.center = view.center
        view.addSubview(btn)
    }

    @objc
    func done() {
        navigationController?.pushViewController(SecondVC(),
                                                 animated: true)
    }
}

class SecondVC: UIViewController {
    private var vm: EventBusFeatureTester?
    private var vm3: EventBusFeatureTester3?
    private let mainVC: MainViewModel!
    private var disposeBag = Set<AnyCancellable>()
    private var eventBusViewModel: EventBusFeatureTester?
    private let eventBus = EventBus<SectionType, EventBusEventImp>()
    private var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        return stack
    }()
    private var orderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private var resultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private var allergyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    init() {
        self.mainVC = MainViewModel(
            [
            .order: OrderViewModel(),
            .result: ResultViewModel(),
            .allergy: AllergyViewModel()
            ],
            eventBus: EventBus<ViewModelType, MainViewModelEvent>())
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addStack()

        subscribe(for: .result, label: resultLabel)
        subscribe(for: .allergy, label: allergyLabel)
        subscribe(for: .order, label: orderLabel)

        mainVC.fetchData(for: .order)
        mainVC.fetchData(for: .result)
        mainVC.fetchData(for: .allergy)
        view.backgroundColor = .white
     }

    func subscribe(for sectionType: ViewModelType, label: UILabel) {
        mainVC.eventBus.subscribe(for: sectionType) { [weak self] event in
            guard let self else {
                return
            }
            label.text = "\(sectionType) \(event)"
            if event == .dataReady {
                let data = self.mainVC.getData(for: sectionType)
                var str = [String]()
                data.forEach { model in
                    str.append("title: \(model.title), detail: \(model.header)")
                }
                label.text = "\(sectionType): \n" + str.joined(separator: "\n") + "\n\n"
            }
        }
    }

    func addStack() {
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
        stackView.addArrangedSubview(orderLabel)
        stackView.addArrangedSubview(resultLabel)
        stackView.addArrangedSubview(allergyLabel)
    }

    func busHandling() {
        // home
        EventBusContainer.shared.register(bus:
                                            EventBus<SectionType, EventBusEventImp>(),
                                          identifier: "superBill")

        // inbox
        guard let busObject = EventBusContainer.shared.getBus(for: "superBill") as?
        EventBus<SectionType, EventBusEventImp> else {
            print("but not found")
            return
        }
        vm = EventBusFeatureTester(eventBus: busObject)
        guard let vm = vm else {
            return
        }
        vm.registerEventBusEvents()
        print("🔮 first fire")
        vm.pubishEventBus()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            print("🔮 second fire")
            self?.vm?.pubishEventBus(.success)
        }

        vm3 = EventBusFeatureTester3(eventBus: busObject)
        guard let vm3 = vm3 else {
            return
        }
        print("🔮 3 test class 🔮")
        vm3.sink()
        vm.pubishEventBus()
        print("🔮 Bus removed 🔮")
        vm.pubishEventBus()
        // appEvents()
        view.backgroundColor = .yellow
    }

    func checkEventBusFunctionality() {
        eventBusViewModel = EventBusFeatureTester(eventBus: eventBus)
        guard let eventBusViewModel = eventBusViewModel else {
            print("view model not created")
            return
        }
        eventBusViewModel.registerEventBusEvents()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.eventBusViewModel?.pubishEventBus(.success)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.eventBusViewModel?.cancelEventBusListListner()

                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                    self?.eventBusViewModel?.pubishEventBus(.failed)
                }
            }
        }
    }
    let secondVM = EventBusFeatureTester2()
    func appEvents() {
        secondVM.sink()
        secondVM.fireEvent()
       // DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            // self?.secondVM.fireEvent()
        // }
    }
    deinit {
        EventBusContainer.shared.cleanBus(for: "superBill")
        print("deinit vc")
    }
}

