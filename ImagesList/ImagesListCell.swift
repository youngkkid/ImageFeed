//
//  ImagesListCell .swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 31.01.2025.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet  weak var dateLabel: UILabel!
    @IBOutlet  weak var cellImage: UIImageView!
    @IBOutlet  weak var likeButton: UIButton!
    
    weak var delegate: ImagesListCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
        cellImage.image = UIImage(named: "placeholder")
    }
    
    func setImage(with url: URL) {
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"), options: [.transition(.fade(0.3))])
    }
     
    func setDate(_ formattedDate: String) {
        dateLabel.text = formattedDate
    }
    
    func setIsLiked(_ isLiked: Bool) {
        let image = isLiked ? UIImage(named: "heart_button_on") : UIImage(named: "heart_button_off")
        likeButton.setImage(image, for: .normal)
    }
    @IBAction func likeButtonClicked(_ sender: Any) {
        delegate?.imagesListCellDidTapLike(self)
    }
    
}
