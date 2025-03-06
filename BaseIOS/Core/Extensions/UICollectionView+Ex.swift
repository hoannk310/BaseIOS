//
//  UICollectionView+Ex.swift
//  BaseIOS
//
//  Created by Hoàn Nguyễn on 3/7/25.
//

import UIKit

extension UICollectionView {
    func registerWithNib<T: UICollectionViewCell>(_ aClass: T.Type, bundle: Bundle? = Bundle(for: T.self)) {
        let name = String(describing: aClass)
        if let bundle = bundle, bundle.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forCellWithReuseIdentifier: name)
        } else {
            register(aClass, forCellWithReuseIdentifier: name)
        }
    }
    
    func registerReusableView<T: UICollectionReusableView>(_ aClass: T.Type, kind: String, bundle: Bundle? = Bundle(for: T.self)) {
        let name = String(describing: aClass)
        let nib = UINib(nibName: name, bundle: bundle)
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: name)
    }
    
    func registerHeader<T: UICollectionReusableView>(_ aClass: T.Type, bundle: Bundle? = Bundle(for: T.self)) {
        registerReusableView(aClass, kind: UICollectionView.elementKindSectionHeader, bundle: bundle)
    }
    
    func registerFooter<T: UICollectionReusableView>(_ aClass: T.Type, bundle: Bundle? = Bundle(for: T.self)) {
        registerReusableView(aClass, kind: UICollectionView.elementKindSectionFooter, bundle: bundle)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue reusable cell with identifier: \(identifier)")
        }
        return cell
    }
    
    func dequeueReusableView<T: UICollectionReusableView>(_ aClass: T.Type, kind: String, for indexPath: IndexPath) -> T {
        let identifier = String(describing: aClass)
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue reusable view with identifier: \(identifier)")
        }
        return view
    }
    
    func dequeueHeader<T: UICollectionReusableView>(_ aClass: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableView(aClass, kind: UICollectionView.elementKindSectionHeader, for: indexPath)
    }
    
    func dequeueFooter<T: UICollectionReusableView>(_ aClass: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableView(aClass, kind: UICollectionView.elementKindSectionFooter, for: indexPath)
    }
}
