//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Feng (Jeffrey) Lu on 7/4/20.
//  Copyright © 2020 CS50. All rights reserved.
//

import UIKit

class PokemonViewController: UIViewController{
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var type1Label: UILabel!
    @IBOutlet var type2Label: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var catchState: UIButton!
    @IBOutlet var pokeImage: UIImageView!
    
    var n: [String : Bool] = UserDefaults.standard.object(forKey: "catches") as! [String : Bool]
    var catched = false
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        type1Label.text = ""
        type2Label.text = ""
        descriptionLabel.text = ""
        
        
        let url = URL(string: pokemon.url)
        guard let u = url else{
            return
        }
        URLSession.shared.dataTask(with: u) {(data, response, error) in
            guard let data = data else{
                return
            }
            do{
                let pokemonData = try JSONDecoder().decode(PokemonData.self , from: data)
                DispatchQueue.main.async {
                    self.nameLabel.text = self.pokemon.name
                    self.numberLabel.text = String(format: "#%03d", pokemonData.id)
                   
                    self.catched = self.n[self.pokemon.name]!
                    if self.catched == true{
                        self.catchState.setTitle("Release", for: .normal)
                    }else{
                        self.catchState.setTitle("Catch", for: .normal)
                    }
                    
                    for typeEntry in pokemonData.types{
                        if typeEntry.slot == 1 {
                            self.type1Label.text = typeEntry.type.name
                        }
                        else if typeEntry.slot == 2 {
                            self.type2Label.text = typeEntry.type.name
                        }
                    }
                    let imageURL = URL(string: pokemonData.sprites.front_default)
                    guard let imageU = imageURL else{
                        return
                    }
                    
                    do{
                        let imageData = try Data(contentsOf: imageU)
                        self.pokeImage.image = UIImage(data: imageData)
                    }catch let error{
                        print("\(error)")
                    }
                }
                    //if let imageurl = URL(string: )
                }
                catch let error{
                    print("\(error)")
                }
           
            }.resume()
        
            self.loadDescription(pokename: self.pokemon.name)
        }
    
    @IBAction func togglecatch(){
        if catched == false {
            catchState.setTitle("Release", for: .normal)
            catched = true
        } else{
            catchState.setTitle("Catch", for: .normal)
            catched = false
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        n.updateValue(catched, forKey: pokemon.name)
        UserDefaults.standard.set(n, forKey: "catches")
        
    }
    //load description
    func loadDescription(pokename: String) -> Void{
        //Retrieve URL
        let url = URL(string:  "https://pokeapi.co/api/v2/pokemon-species/\(pokename)/")
        guard let u = url else{
           return
        }
        //URL session to retrieve data
        URLSession.shared.dataTask(with: u) {(data, response, error) in
              guard let data = data else{
                  return
              }
              do{
                  //JSON Decoder to load data into structs
                  let descriptionres = try JSONDecoder().decode(Description.self, from: data)
                
                  DispatchQueue.main.async{
                    //Enter first english entry into description label
                    for entry in descriptionres.flavor_text_entries{
                        if entry.language.name == "en" {
                            self.descriptionLabel.text = entry.flavor_text.replacingOccurrences(of: "\n", with:" " )
                            break
                        }
                    }
                  }
              }
              catch let error{
                  print("\(error)")
              }
          }.resume()
        
    }
}

