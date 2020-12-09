//
//  ViewController.swift
//  Pokedex
//
//  Created by Feng (Jeffrey) Lu on 7/2/20.
//  Copyright © 2020 CS50. All rights reserved.
//

import UIKit

class PokemonListViewController: UITableViewController, UISearchBarDelegate {
    
    var pokemon: [Pokemon] = []
    @IBOutlet var searchBar: UISearchBar!
    var currentList: [Pokemon] = []
    let defaults = UserDefaults.standard
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentList = []
        if searchText == ""
        {
            currentList = pokemon
        }
        else {
            for i in 0..<pokemon.count{
                if pokemon[i].name.localizedStandardContains(searchText) == true{
                    currentList.append(pokemon[i])
                }
            }
        }
        tableView.reloadData()
    }
    
    func capitalize(text: String) -> String{
        return text.prefix(1).uppercased() + text.dropFirst()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151")
        guard let u = url else{
            return
        }
        URLSession.shared.dataTask(with: u) {(data, response, error) in
            guard let data = data else{
                return
            }
            do{
                let pokemonList = try JSONDecoder().decode(PokemonList.self , from: data)
                self.pokemon = pokemonList.results
                self.currentList = self.pokemon
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
                
            }
            catch let error{
                print("\(error)")
            }
        }.resume()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        cell.textLabel?.text = capitalize(text: currentList[indexPath.row].name)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if UserDefaults.standard.bool(forKey: "on") == false{
            defaults.set(true, forKey:"on")
            var catches: [String : Bool] = [:]
            for poke in pokemon{
                catches.updateValue(false, forKey: poke.name)
            }
            defaults.set(catches, forKey: "catches")
        }
        
        //let m = defaults.object(forKey: "catches") as? [String: Bool]
       // print(String(5))
       
        
        /*
        var catches: [String: Bool] = [:]
        for poke in pokemon{
            catches.updateValue(false, forKey: poke.name)
        }
        defaults.set(catches, forKey: "catches")
        
        for poke in pokemon{
            print(String(defaults.bool(forKey: poke.name)))
        }
        */
        if segue.identifier == "PokemonSegue"{
            if let destination = segue.destination as? PokemonViewController {
                destination.pokemon = currentList[tableView.indexPathForSelectedRow!.row]
            }
        }
    }


}

