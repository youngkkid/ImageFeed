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
    weak var presenter: ImagesListPresenterProtocol?
    private var photos = [Photo]()
    private var imageListServiceObserver: NSObjectProtocol?
    private let photoName: [String] = Array(0...20).map{"\($0)"}
    private let imagesListService = ImagesListService.shared
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
            let image = photos[indexPath.row].largeImageURL
            viewController.photoUrl = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTableViewAnimated),
                                               name: ImagesListService.didChangeNotification,
                                               object: nil)
        ImagesListService.shared.fetchPhotosNextPage() {_ in}
    }
    
   @objc private func updateTableViewAnimated() {
       let oldCount = photos.count
       let newPhotos = imagesListService.photos
       guard newPhotos.count > oldCount else {return}
       let indexPaths = (oldCount..<newPhotos.count).map { IndexPath(row: $0, section: 0)}
       
       photos.append(contentsOf: newPhotos[oldCount..<newPhotos.count])
       
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

        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photos[indexPath.row].size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photos[indexPath.row].size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            ImagesListService.shared.fetchPhotosNextPage {_ in}
          }
        
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
        guard let url = URL(string: photos[indexPath.row].regularImageURL) else {return}
        cell.cellImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.layer.cornerRadius = 15
        cell.cellImage.layer.masksToBounds = true
        
        if let date = photos[indexPath.row].createdAt,
           let finalDate = newDateFormatter.date(from: date) {
            cell.dateLabel.text = dateFormatter.string(from: finalDate)
        } else {
            cell.dateLabel.text = ""
        }
        let isLiked = photos[indexPath.row].isLiked
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
        
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) {[weak self] result in
            UIBlockingProgressHUD.dismiss()
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result {
                case .success:
                    self.photos = self.imagesListService.photos
                    cell.setIsLiked(self.photos[indexPath.row].isLiked)
                case .failure:
                    AlertPresenter.showAlert(viewController: self, title: "Что-то пошло не так(", message:"Не удалось выполнить действие" , handler: {})
                }
            }
        }
    }
}
