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
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    fileprivate let informationLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "No songs searched yet or no match for current song name. Please try to fill the search bar with another song name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    fileprivate var musicPlayerView: MusicPlayerView!
    
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
        musicPlayerView = MusicPlayerView(frame: CGRect(x: 0, y: view.frame.height - 200, width: view.frame.width, height: 200))
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        view.addSubview(informationLabel)
        view.addSubview(musicPlayerView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: musicPlayerView.topAnchor),
            
            informationLabel.topAnchor.constraint(equalTo: view.topAnchor),
            informationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            informationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            informationLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
        if musicList.isEmpty {
            informationLabel.text = "No songs searched yet or no match for current song name. Please try to fill the search bar with another song name"
            self.showLabelAndHideTable()
        } else {
            self.showTableAndHideLabel()
        }
    }
    
    fileprivate func showLabelAndHideTable(){
        self.informationLabel.isHidden = false
        self.tableView.isHidden = true
    }
    
    fileprivate func showTableAndHideLabel() {
        self.informationLabel.isHidden = true
        self.tableView.isHidden = false
    }
    
    fileprivate func updateViewWhenLoading(isSearching: Bool) {
        if isSearching {
            LoadingManager.shared.showLoading()
        } else {
            LoadingManager.shared.hideLoading()
        }
    }
    
    func updateViewWithError(errorMessage: String) {
        informationLabel.text = "ERROR: \(errorMessage)"
        showLabelAndHideTable()
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .fetchMusicListDidSucceed(let musicList):
                    //                    debugPrint(musicList)
                    self?.updateTableView(with: musicList)
                    AudioPlayerManager.shared.tracks = musicList
                case .fetchMusicListDidFail(let error):
                    debugPrint(error)
                    self?.updateViewWithError(errorMessage: error.localizedDescription)
                case .toggleSearch(let isSearching):
                    self?.updateViewWhenLoading(isSearching: isSearching)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchController.isActive = false
        AudioPlayerManager.shared.currentTrackIndex = indexPath.row
        AudioPlayerManager.shared.playCurrentTrack()
    }
    
    
}

// MARK: Extension UISearchResultsUpdating
extension MusicListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty{
            DispatchQueue.main.asyncDeduped(target: self, after: 0.5) { [weak self] in
                self?.input.send(.searchTriggered(searchText))
            }
        }
    }
}

