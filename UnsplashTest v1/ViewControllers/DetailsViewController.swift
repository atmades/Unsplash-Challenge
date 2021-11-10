//
//  DetailsViewController.swift
//  UnsplashTest v1
//
//  Created by Максим on 05/11/2021.
//

import UIKit

protocol FavoritsWasChangedDelegate: AnyObject {
    func didChanged()
}

class DetailsViewController: UIViewController {
    
    //    MARK: - Properties
    var detailsView = DetailsView()
    weak var delegate: FavoritsWasChangedDelegate?
    
    var networkDataFetcher: NetworkDataFetcher
    var viewModel: DetailsViewModel
    
    //    MARK: - Setup UI
    func setupUI(detail: Detail) {
        let isFavorit = viewModel.checkIsFavorit(detail: detail)
        detailsView.setupUI(detail: detail, isFavorit: isFavorit)
    }
    
    //  MARK: - Show Alert
    func showAlert(indexForRemove: Int) {
        let alert = UIAlertController(title: "Remove from Favorits?", message: "Would you like to remove this photo?", preferredStyle: .alert)
        
        //  add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Remove", style: .default, handler: {action in
            self.viewModel.removeFromFavorites(index: indexForRemove)
            self.detailsView.isFavaritNow(isFavorit: false)
            self.delegate?.didChanged()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            self.detailsView.isFavaritNow(isFavorit: true)
        }))
        
        //  show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Init
    init(viewModel: DetailsViewModel, networkDataFetcher: NetworkDataFetcher) {
        self.viewModel = viewModel
        self.networkDataFetcher = networkDataFetcher
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - Life Cycle
    override func loadView() {
        view = detailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        detailsView.delegate = self
        setupUI(detail: viewModel.detail)
    }
}

//  MARK: - Extension DetailsViewDelegate
extension DetailsViewController:  DetailsViewDelegate {
    func didTapAdd() {
        viewModel.addToFavorites(item: viewModel.detail)
        delegate?.didChanged()
    }
    
    func didTapRemove() {
        let index = viewModel.getIndex(id: viewModel.detail.id)
        guard let indexForRemove = index else { return }
        self.detailsView.isFavaritNow(isFavorit: true)
        showAlert(indexForRemove: indexForRemove)
    }
}
