//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 07.02.2025.
//

import UIKit

 final class SingleImageViewController: UIViewController {

     var image: UIImage? {
         didSet {
//             проверяем, было ли ранее загружено view, дабы избежать крэша
             guard isViewLoaded, let image else {return}
             imageView.image = image
             imageView.frame.size = image.size
             rescaleAndCenterImageInScrollView(image: image)
         }
     }
     
     @IBOutlet private var imageView: UIImageView!
     @IBOutlet private var scrollView: UIScrollView!
    
     override func viewDidLoad() {
         super.viewDidLoad()
         scrollView.minimumZoomScale = 0.1
         scrollView.maximumZoomScale = 1.25
         
//       устанавливаем размер imageView после присвоения
         guard let image else {return}
         imageView.image = image
         imageView.frame.size = image.size
         rescaleAndCenterImageInScrollView(image: image)
     }
     
     private func rescaleAndCenterImageInScrollView(image: UIImage) {
         let minZoomScale = scrollView.minimumZoomScale
         let maxZoomScale = scrollView.maximumZoomScale
         view.layoutIfNeeded()
         let visibleRectSize = scrollView.bounds.size
         let imageSize = image.size
         let hScale = visibleRectSize.width / imageSize.width
         let vScale = visibleRectSize.height / imageSize.height
         let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
         scrollView.setZoomScale(scale, animated: false)
         scrollView.layoutIfNeeded()
         let newContentSize = scrollView.contentSize
         let x = (newContentSize.width - visibleRectSize.width) / 2
         let y = (newContentSize.height - visibleRectSize.height) / 2
         scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
     }
     
     @IBAction private func didTapBackButton(_ sender: UIButton) {
//         скрываем модальный экран с помощью вызова метода dismiss (благодаря этому методу, мы можем возвращаться к imageListViewController)
         dismiss(animated: true, completion: nil)
     }
     
     @IBAction private func didTapShareButton(_ sender: UIButton) {
         guard let image else {return}
         let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)
         present(share,animated: true, completion: nil)
     }
 }

// с помощью расширения добавляем метод, с помощью которого приложению понятно, какое изображение увеличивать
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
