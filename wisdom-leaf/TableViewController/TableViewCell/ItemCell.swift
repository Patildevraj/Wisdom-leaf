//
//  ItemCell.swift
//  wisdom-leaf
//
//  Created by Kibbcom on 25/06/24.
//

import UIKit

class ItemCell: UITableViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var checkboxImage: UIImageView!
    
    var checkboxHandler: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func checkboxTapped(_ sender: UIButton) {
        checkboxHandler?()
    }
}
