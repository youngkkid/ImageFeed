//
//  ImagesListCell .swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 31.01.2025.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet  var dateLabel: UILabel!
    @IBOutlet  var cellImage: UIImageView!
    @IBOutlet  var likeButton: UIButton!
}
