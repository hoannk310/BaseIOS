//
//  UIViewController+Ex.swift
//  BaseIOS
//
//  Created by Nguyen Khai Hoan on 12/3/25.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    var viewDidLoad: Observable<Void> {
        return self.sentMessage(#selector(Base.viewDidLoad))
            .map { _ in }
            .share()
    }

    var viewWillAppear: Observable<Bool> {
        return self.sentMessage(#selector(Base.viewWillAppear(_:)))
            .map { $0.first as? Bool ?? false }
            .share()
    }

    var viewDidAppear: Observable<Bool> {
        return self.sentMessage(#selector(Base.viewDidAppear(_:)))
            .map { $0.first as? Bool ?? false }
            .share()
    }

    var viewWillDisappear: Observable<Bool> {
        return self.sentMessage(#selector(Base.viewWillDisappear(_:)))
            .map { $0.first as? Bool ?? false }
            .share()
    }

    var viewDidDisappear: Observable<Bool> {
        return self.sentMessage(#selector(Base.viewDidDisappear(_:)))
            .map { $0.first as? Bool ?? false }
            .share()
    }

    var viewWillLayoutSubviews: Observable<Void> {
        return self.sentMessage(#selector(Base.viewWillLayoutSubviews))
            .map { _ in }
            .share()
    }

    var viewDidLayoutSubviews: Observable<Void> {
        return self.sentMessage(#selector(Base.viewDidLayoutSubviews))
            .map { _ in }
            .share()
    }
}
