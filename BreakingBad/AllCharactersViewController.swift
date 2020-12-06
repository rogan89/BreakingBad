//
//  AllCharactersViewController.swift
//  BreakingBad
//
//  Created by Brendan Rogan on 12/4/20.
//

import UIKit
import SDWebImage

class AllCharactersViewController: UIViewController {
    
    @IBOutlet weak var characterSearchBar: UISearchBar!
    
    @IBOutlet weak var charactersTableView: UITableView!
    
    @IBOutlet weak var seasonsScrollView: UIScrollView!
    
    var allCharacters = [Character]()
    var currentSeasonCharacters = [Character]()
    var currentCharacters = [Character]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Breaking Bad Characters"
        
        characterSearchBar.placeholder = "Search characters..."
        
        charactersTableView.delegate = self
        charactersTableView.dataSource = self
        
        characterSearchBar.delegate = self
        
        getCharacters()

        charactersTableView.keyboardDismissMode = .onDrag
    }
    
    func getCharacters() {
        
        BreakingBadAPI.getCharacters { [weak self] result in
            
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                self?.allCharacters = []
            case .success(let characterArray):
                self?.allCharacters = characterArray
                self?.currentSeasonCharacters = characterArray
            }
            
            DispatchQueue.main.async {
                self?.setUpScrollView()
                self?.currentCharacters = self?.allCharacters ?? []
                self?.charactersTableView.reloadData()
            }
        }
    }
    
    func setUpScrollView() {
        var set = Set<Int>()
        for character in allCharacters {
            guard let appearance = character.appearance else {
                continue
            }
            for season in appearance {
                set.insert(season)
            }
        }
        set.insert(-1)
        let seasons = set.sorted()
        
        var xCoord: CGFloat = 5
        let yCoord: CGFloat = 5
        let buttonWidth:CGFloat = 45.0
        let buttonHeight: CGFloat = 45.0
        let gapBetweenButtons: CGFloat = 5

        for season in seasons {
            let seasonButton = UIButton(type: .custom)
            seasonButton.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
            seasonButton.tag = season
            seasonButton.backgroundColor = UIColor.clear
            seasonButton.setTitleColor(.systemBlue, for: .normal)
            let seasonString = season == -1 ? "All" : String(season)
            seasonButton.setTitle(seasonString, for: .normal)
            seasonButton.titleLabel?.adjustsFontSizeToFitWidth = true
            seasonButton.addTarget(self, action:#selector(seasonSelected(_:)), for: .touchUpInside)
            seasonButton.layer.cornerRadius = 5
            seasonButton.clipsToBounds = true
            xCoord +=  buttonWidth + gapBetweenButtons
            seasonsScrollView.addSubview(seasonButton)

        }
        seasonsScrollView.contentSize = CGSize(width: buttonWidth * CGFloat(seasons.count + 1), height: yCoord)
    }
    
    @objc func seasonSelected(_ button: UIButton) {
        let season = button.tag
        if season == -1 {
            characterSearchBar.text = nil
            currentSeasonCharacters = allCharacters
        } else {
            characterSearchBar.text = nil
            let characters = allCharacters.filter {
                $0.appearance?.contains(season) ?? false
            }
            currentSeasonCharacters = characters
        }
        for view in seasonsScrollView.subviews {
            if view is UIButton {
                view.backgroundColor = .none
            }
        }
        button.backgroundColor = UIColor.lightGray
        currentCharacters = currentSeasonCharacters
        charactersTableView.reloadData()
    }

}

extension AllCharactersViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentCharacters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = charactersTableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath)
        let character = currentCharacters[indexPath.row]
        cell.textLabel?.text = character.name
        if let imageURLString = character.img {
            let imageURL = URL(string: imageURLString)
            cell.imageView?.sd_setImage(with: imageURL, completed: nil)
        }
        
        return cell
    }
}

extension AllCharactersViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let characterDetailsVC = storyboard?.instantiateViewController(identifier: "characterDetailsVC") as? CharacterDetailsViewController else { return }
        characterDetailsVC.character = currentCharacters[indexPath.row]
        navigationController?.pushViewController(characterDetailsVC, animated: true)
    }
    
}

extension AllCharactersViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        currentCharacters = searchText.isEmpty ? currentSeasonCharacters : currentSeasonCharacters.filter {
            return $0.name?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }

        charactersTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
