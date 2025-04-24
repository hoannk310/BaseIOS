//
//  TableViewCell.swift
//  BaseIOS
//
//  Created by Hoàn Nguyễn on 4/25/25.
//

import UIKit
import ImageLoaderPod

class TableViewCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with urlString: String) {
        if let url = URL(string: urlString) {
            imgView.loadImageByPod(from: url, failedImage: UIImage(systemName: "arrow.2.circlepath"))
        }
    }
}
