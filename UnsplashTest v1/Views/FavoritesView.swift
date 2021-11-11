//
//  FavoritesView.swift
//  UnsplashTest v1
//
//  Created by Максим on 08/11/2021.
//

import UIKit

class FavoritesView: UIView {
    //    MARK: - For Setup TableView
    var delegate: UITableViewDelegate? {
        get {
            return tableView.delegate
        }
        set {
            tableView.delegate = newValue
        }
    }
    
    var dataSource: UITableViewDataSource? {
        get {
            return tableView.dataSource
        }
        set {
            tableView.dataSource = newValue
        }
    }
    
    func registerClass(cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
        tableView.register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    func dequeueReusableCellWithIdentifier(identifier: String) -> UITableViewCell? {
        return tableView.dequeueReusableCell(withIdentifier: identifier)
    }
    
    //    MARK: - UI Elements
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.contentInsetAdjustmentBehavior = .automatic
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .light)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.text = "There is no favorits"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //    MARK: - Setup Layout
    private func createSubviews() {
        addSubview(emptyLabel)
        addSubview(tableView)
        
        emptyLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        emptyLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    //    MARK: - Setup UI Functions
    func setupUI(isEmpty: Bool) {
        if isEmpty {
            tableView.isHidden = true
            emptyLabel.isHidden = false
        } else {
            tableView.isHidden = false
            emptyLabel.isHidden = true
        }
    }
    
    func reloadTableview() {
        tableView.reloadData()
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
