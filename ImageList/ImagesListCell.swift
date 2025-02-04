//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 31.01.2025.
//

import UIKit
// создаем класс для нашей кастомной ячейки
final class ImagesListCell: UITableViewCell {
    // производим идентификацию ячейки
    static let reuseIdentifier = "ImagesListCell"
    
//    создаем аутлеты для кастомной ячейки
    @IBOutlet  var dateLabel: UILabel!
    @IBOutlet  var cellImage: UIImageView!
    @IBOutlet  var likeButton: UIButton!
}
