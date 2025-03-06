//
//  ViewController.swift
//  BaseIOS
//
//  Created by nguyen.khai.hoan on 6/2/25.
//

import UIKit
import RxSwift

class ViewController: BaseViewController {
    let coordinator: MainCoordinator
    let viewModel: ViewModel
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginStatus: UILabel!
    @IBOutlet weak var registerStatus: UILabel!
    
    deinit {
        print("deinit \(String(describing: self))")
    }
    
    init(coordinator: MainCoordinator, viewModel: ViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupBindings() {
        let loginEntity = LoginRequestEntity(email: "hoannk@gmail.com", password: "A123456")
        let registerEntity = RegisterRequestEntity(email: "hoannk@gmail.com", password: "A123456", name: "hoan", age: 29)
        let input = ViewModel.Input(registerTrigger: registerButton.rx.tap.map{ registerEntity },
                                    loginTrigger: loginButton.rx.tap.map{ loginEntity })
        let output = viewModel.transform(input: input)
        output.loginOutput
            .map{"Login được rồi:\n \($0)"}
            .drive(loginStatus.rx.text).disposed(by: disposeBag)
        
        output.registerOutput
            .map{"Register được rồi:\n \($0)"}
            .drive(registerStatus.rx.text).disposed(by: disposeBag)
        
        output.errorTracker
            .driveNext { error in
                print(error)
            }.disposed(by: disposeBag)
    }
}

