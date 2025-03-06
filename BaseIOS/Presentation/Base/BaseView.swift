//
//  BaseView.swift
//  BaseIOS
//
//  Created by Hoàn Nguyễn on 3/7/25.
//

import UIKit

class BaseView: UIView {
    var contentView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        contentView = loadNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }

    private func loadNib() -> UIView {
        let nibName = String(describing: type(of: self))
        let bundle = Bundle(for: type(of: self))
        
        guard let view = bundle.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView else {
            fatalError("⚠️ Could not load nib with name \(nibName)")
        }
        return view
    }
}
