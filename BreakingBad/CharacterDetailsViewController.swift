//
//  CharacterDetailsViewController.swift
//  BreakingBad
//
//  Created by Brendan Rogan on 12/4/20.
//

import UIKit

class CharacterDetailsViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var occupation: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var seasonAppearance: UILabel!
    
    @IBOutlet weak var characterImageView: UIImageView!
    
    var character: Character!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Character Details"
        
        setLabels()
        setImageView()
    }
    
    func setLabels() {
        name.text = "Name: " + (character.name ?? "")
        occupation.text = "Occupation: " + (character.occupation?.joined(separator: ", ") ?? "")
        status.text = "Status: " + (character.status ?? "")
        nickName.text = "Nickname: " + (character.nickname ?? "")
        var appearanceString = "N/A"
        if let appearances = character.appearance {
            let allAppearances = appearances.map {
                String($0)
            }
            appearanceString = allAppearances.joined(separator: ", ")
        }
        seasonAppearance.text = "Seasons: " + appearanceString
    }

    func setImageView() {
        if let imageURLString = character.img {
            let imageURL = URL(string: imageURLString)
            characterImageView.sd_setImage(with: imageURL, completed: nil)
        }
    }

}
