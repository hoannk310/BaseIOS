//
//  ViewController.swift
//  BaseIOS
//
//  Created by nguyen.khai.hoan on 6/2/25.
//

import UIKit
import RxSwift
import WebRTC

class ViewController: BaseViewController {
    let coordinator: MainCoordinator
    let viewModel: ViewModel
    @IBOutlet weak var localView: RTCMTLVideoView!
    @IBOutlet weak var remoteView: RTCMTLVideoView!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var setMicButton: UIButton!
    
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
    
    override func setupViews() {
    }
    
    override func setupBindings() {
        let input = ViewModel.Input(start: startButton.rx.tap.asObservable(),
                                    join: joinButton.rx.tap.asObservable(),
                                    setMic: setMicButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)
        output.localVideoOutput
            .drive { [weak self] track in
                guard let self = self, let track = track else { return }
                track.add(self.localView)
            }.disposed(by: disposeBag)
        
        output.remoteVideoOutput
            .drive { [weak self] track in
                guard let self = self, let track = track else { return }
                track.add(self.remoteView)
            }.disposed(by: disposeBag)
        
        output.emptyOutput
            .drive()
            .disposed(by: disposeBag)
    }
}

