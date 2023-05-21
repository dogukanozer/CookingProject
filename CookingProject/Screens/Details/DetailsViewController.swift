//
//  DetailsViewController.swift
//  CookingProject
//
//  Created by Macbook Air on 17.05.2023.
//

import UIKit
import Lottie

class DetailsViewController: UIViewController {
    
    // MARK: - Outles
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var summaryLabel: UILabel!
    
    // MARK: - Properties
    private let viewModel = DetailsViewModel()
    var searchResultModel: ResultModel?
    var imageUrl: String?
    private var animationView = LottieAnimationView(name: "anime")
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        addDelegates()
        fetchService()
        setAnimationView()
    }
}

// MARK: - Helpers
private extension DetailsViewController {
    
    func addDelegates() {
        viewModel.delegate = self
    }
    
    func fetchService() {
        animationView.play()
        animationView.isHidden = false
        if let id = searchResultModel?.id {
            viewModel.fetchService(id: "\(id)")
        }
    }
    
    func setAnimationView() {
        animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        animationView.center = view.center
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.isHidden = false
        view.addSubview(animationView)
    }
    
    func makeAlert(tittleInput: String, messegaInput: String) {
            let alert = UIAlertController(title: tittleInput, message: messegaInput, preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
            alert.addAction(okButton)
            self.present(alert, animated: true)
    }
    
    func loadCellImage(url: URL) {
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
}

// MARK: - DetailsViewModelDelegate
extension DetailsViewController: DetailsViewModelDelegate {
    func didFetchServiceSuccess(detailResponseModel: DetailResponseModel) {
        DispatchQueue.main.async {
            self.titleLabel.text = detailResponseModel.title
            self.summaryLabel.text = detailResponseModel.summary
            let urlToImage = self.imageUrl ?? ""
            if let imageUrll = URL(string: urlToImage) {
                self.loadCellImage(url: imageUrll)
        }
            self.animationView.stop()
            self.animationView.isHidden = true
    }
}
    
    func didFetchServiceFail(message: String) {
        DispatchQueue.main.async {
            self.makeAlert(tittleInput: "Error", messegaInput: message)
            self.animationView.stop()
            self.animationView.isHidden = true
        }
    }
}
