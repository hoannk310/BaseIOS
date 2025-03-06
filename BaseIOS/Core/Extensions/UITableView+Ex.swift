//
//  Untitled.swift
//  BaseIOS
//
//  Created by Hoàn Nguyễn on 3/7/25.
//

import UIKit
import RxCocoa

extension UITableView {
    func register<T: UITableViewCell>(_ aClass: T.Type, bundle: Bundle? = Bundle(for: T.self)) {
        let name = String(describing: aClass)
        if let bundle = bundle, bundle.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forCellReuseIdentifier: name)
        } else {
            register(aClass, forCellReuseIdentifier: name)
        }
    }

    func dequeue<T: UITableViewCell>(_ aClass: T.Type) -> T {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableCell(withIdentifier: name) as? T else {
            fatalError("`\(name)` is not registered")
        }
        return cell
    }

    func dequeue<T: UITableViewCell>(at indexPath: IndexPath) -> T {
        let name = String(describing: T.self)
        guard let cell = dequeueReusableCell(withIdentifier: name, for: indexPath) as? T else {
            fatalError("`\(name)` is not registered")
        }
        return cell
    }

    func register<T: UITableViewHeaderFooterView>(_ aClass: T.Type, bundle: Bundle? = Bundle(for: T.self)) {
        let name = String(describing: aClass)
        if let bundle = bundle, bundle.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forHeaderFooterViewReuseIdentifier: name)
        } else {
            register(aClass, forHeaderFooterViewReuseIdentifier: name)
        }
    }

    func dequeue<T: UITableViewHeaderFooterView>(_ aClass: T.Type) -> T {
        let name = String(describing: aClass)
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: name) as? T else {
            fatalError("`\(name)` is not registered")
        }
        return view
    }
}
