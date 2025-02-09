//
//  ViewController.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 30.01.2025.
//

import UIKit

final class ImagesListViewController: UIViewController {
    // создаем аутлет для таблицы
    @IBOutlet private var tableView: UITableView!
//    создаем массив с нашими мок-данными (где с помощью .map мы превращаем каждый элемент массива из числа в строку)
    private let photoName: [String] = Array(0...20).map{"\($0)"}
//    вводим константу для ShowSingleImage
    private let showSingleImageIdentifier = "ShowSingleImage"
//    форматируем дату
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        return formatter
    }()
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                    let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            let image = UIImage(named: photoName[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        определяем dataSource и delegate
        tableView.dataSource = self
        tableView.delegate = self
//        устанавливаем высоту ячейки
        tableView.rowHeight = 200
//        создаем отступ между ячейками
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
    }


}


// создаем два расширения (одно для dataSource, а другое для delegate)

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     performSegue(withIdentifier: showSingleImageIdentifier, sender: indexPath)
    }
//    метод, который задает высоту каждой ячейке в зависимости от размера фото в ней
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photoName[indexPath.row]) else {
            return 0
        }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // используем метод, который из всех существующих ячеек возвращает только ту, что добавлена по идентификатору
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        // проводим проведение типов для работы с ячейкой как с экземпляром класса imagesListCell
        guard let imagesListCell = cell as? ImagesListCell else {return UITableViewCell()}
        
        configCell(for: imagesListCell, with: indexPath)
        
        return imagesListCell
    }
    
    
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: photoName[indexPath.row]) else {return}
        
        cell.cellImage.image = image
        cell.dateLabel.text = dateFormatter.string(from: Date())
        
        let isLiked = indexPath.row % 2 == 0
        let likeImage = isLiked ? UIImage(named: "heart_button_on") : UIImage(named: "heart_button_off")
        cell.likeButton.setImage(likeImage, for: .normal)
       
    }
}

