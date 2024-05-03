//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Gregorius Yuristama Nugraha on 5/3/24.
//

import UIKit
import Combine

class MusicListViewController: UIViewController {

    fileprivate let tableView: UITableView = {
        let table = UITableView()
        table.register(MusicTableViewCell.self, forCellReuseIdentifier: MusicTableViewCell.identifier)
        return table
    }()
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    fileprivate let viewModel = MusicListViewModel()
    fileprivate let input: PassthroughSubject<MusicListViewModel.Input, Never> = .init()
    fileprivate var cancellables = Set<AnyCancellable>()
    
    fileprivate var musicList: [Music] = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
        self.initView()
    }
    
    fileprivate func initView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        self.initNavBar()
    }
    
    fileprivate func initNavBar() {
        self.navigationItem.title = "Songs"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Find Songs"
    }
    
    fileprivate func updateTableView(with musicList: [Music]) {
        self.musicList = musicList
        tableView.reloadData()
    }
    
    fileprivate func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .fetchMusicListDidSucceed(let musicList):
                    self?.updateTableView(with: musicList)
                case .fetchMusicListDidFail(let error):
                    print(error)
                case .toggleSearch(let isEnabled):
                    print(isEnabled)
                }
            }.store(in: &cancellables)
    }
}

// MARK: Extension TableView
extension MusicListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.musicList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MusicTableViewCell.identifier,
            for: indexPath
        ) as? MusicTableViewCell else { return UITableViewCell() }
        
        cell.config(self.musicList[indexPath.row])
        
        return cell
    }
    
    
}

// MARK: Extension UISearchResultsUpdating
extension MusicListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty{
            DispatchQueue.main.asyncDeduped(target: self, after: 0.7) { [weak self] in
                self?.input.send(.searchTriggered(searchText))
            }
        }
    }
}

