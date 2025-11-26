//
//  SampleCell.swift
//  NSAutoAXKit Test Fixtures
//
//  Sample table view cell for testing the generator.
//

import UIKit

class SampleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel?
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var disclosureButton: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class SampleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

