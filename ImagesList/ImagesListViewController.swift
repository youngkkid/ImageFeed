//
//  ViewController .swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 30.01.2025.
//

import UIKit
import Kingfisher

protocol ImageListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? {get set}
    func showAlert()
}

final class ImagesListViewController: UIViewController & ImageListViewControllerProtocol {    
    var presenter: ImagesListPresenterProtocol?
    private var imageListServiceObserver: NSObjectProtocol?
    private let showSingleImageIdentifier = "ShowSingleImage"
    private let newDateFormatter = ISO8601DateFormatter()
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        return formatter
    }()
    
    @IBOutlet private var tableView: UITableView!
    
    func showAlert() {
        AlertPresenter.showAlert(viewController: self, title: "Что-то пошло не так(", message: "Не удалось выполнить действие", handler: {})
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            guard let photos = presenter?.photo(at: indexPath) else {return}
            let image = photos.largeImageURL
            viewController.photoUrl = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        ImagesListService.shared.fetchPhotosNextPage() {_ in}
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTableViewAnimated),
                                               name: ImagesListService.didChangeNotification,
                                               object: nil)
    }
    
   @objc private func updateTableViewAnimated() {
       guard let presenter = presenter else {return}
       let counts = presenter.updateInfoForTableView()
       
       let oldCount = counts[0]
       let newCount = counts[1]
       print("oldCount: \(oldCount), newCount: \(newCount)")
       guard newCount > oldCount else {return}
       let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0)}
       
       tableView.performBatchUpdates {
           tableView.insertRows(at: indexPaths, with: .automatic)
       }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        guard let imageCell = presenter?.photo(at: indexPath),
              view != nil else {return 0}
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = imageCell.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageCell.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.countPhotos() ?? 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.loadNewPhotosIfNeed(indexPath: indexPath)
        }
    
    func tableView(
        _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
            guard let imageListCell = cell as? ImagesListCell else {
                return UITableViewCell()
            }
            imageListCell.delegate = self
            configCell(for: imageListCell, with: indexPath)
            return imageListCell
    }
    
}

extension ImagesListViewController {
   private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
       guard let photos = presenter?.photo(at: indexPath),
             let url = URL(string: photos.regularImageURL) else {return}
        cell.cellImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.layer.cornerRadius = 15
        cell.cellImage.layer.masksToBounds = true
        
        if let date = photos.createdAt,
           let finalDate = newDateFormatter.date(from: date) {
            cell.dateLabel.text = dateFormatter.string(from: finalDate)
        } else {
            cell.dateLabel.text = ""
        }
        let isLiked = photos.isLiked
        let image = isLiked ? UIImage(named: "heart_button_on") : UIImage(named: "heart_button_off")
        cell.likeButton.setImage(image, for: .normal)
    }
    
    private func imagesListObserver(){
        imageListServiceObserver = NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else {return}
            self.updateTableViewAnimated()
        }
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imagesListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        presenter?.imagesListCellDidTapLike(cell, indexPath: indexPath)
    }
}
