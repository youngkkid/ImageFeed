//
//  SingleImageViewController .swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 07.02.2025.
//

import UIKit
import Kingfisher

 final class SingleImageViewController: UIViewController {

     var image: UIImage? {
         didSet{
             guard isViewLoaded, let image else {return}
             setImage(image: image)
            }
     }
     
     var photoUrl: String?
     
     @IBOutlet private var imageView: UIImageView!
     @IBOutlet private var scrollView: UIScrollView!
    
     override func viewDidLoad() {
         super.viewDidLoad()
         scrollView.minimumZoomScale = 0.1
         scrollView.maximumZoomScale = 1.25
         guard let stringUrl = photoUrl, 
               let url = URL(string: stringUrl) else {return}
         loadAndSetImage(fullImageUrl: url)
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
     
     private func setImage(image: UIImage) {
         imageView.image = image
         imageView.frame.size = image.size
         rescaleAndCenterImageInScrollView(image: image)
     }
     
     private func loadAndSetImage(fullImageUrl: URL) {
         UIBlockingProgressHUD.show()
         imageView.kf.setImage(with: fullImageUrl) {[weak self] result in
             UIBlockingProgressHUD.dismiss()
             guard let self = self else {return}
             switch result {
             case .success(let value):
                 self.image = value.image
             case .failure:
                 showError()
             }
         }
     }
     
     private func showError(){
         AlertPresenter.showAlertTwoButtons(viewController: self, title: "Что-то пошло не так(", message: "Попробовать ещё раз?", firstButtonTitle: "Повторить", secondButtonTitle: "Не надо") {[weak self] in
             guard let self = self else {return}
             guard let stringUrl = photoUrl, let url = URL(string: stringUrl) else {return}
             self.loadAndSetImage(fullImageUrl: url)
         }
     }
     
     @IBAction private func didTapBackButton(_ sender: UIButton) {
         dismiss(animated: true, completion: nil)
     }
     
     @IBAction private func didTapShareButton(_ sender: UIButton) {
         guard let image else {return}
         let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)
         present(share,animated: true, completion: nil)
     }
 }

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
