//
//  RecipeListTableViewController.swift
//  foodstackular
//
//  Created by Johnnie Tran on 3/20/18.
//  Copyright © 2018 Ruslan Suvorov. All rights reserved.
//

import UIKit

class RecipeListTableViewController: UITableViewController {
    
    var recipesArr = [NSDictionary]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let session = URLSession.shared
        let url = URL(string: "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/random?number=3")
        var request = URLRequest(url: url!)
        request.addValue("oIFuWMxDztmshElenyDjFctQTeqPp1YBOsWjsn3zkDY7iXY4ss", forHTTPHeaderField: "X-Mashape-Key")
        request.addValue("2", forHTTPHeaderField: "number")
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    // Try converting the JSON object to "Foundation Types" (NSDictionary, NSArray, NSString, etc.)
                    if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        if let results = jsonResult["recipes"] as? NSArray {
                            for recipe in results {
                                let recipeDict = recipe as! NSDictionary
                                self.recipesArr.append( recipeDict )
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
                catch{
                    print("ERROR")
                }
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recipesArr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! recipeCell
//        print( "the whole thing:", recipesArr[indexPath.row] )
        
        if let recipeTitle = recipesArr[indexPath.row]["title"] as? String{
            cell.recipeTitle.text = recipeTitle
        }
        
        if let recipeImage = recipesArr[indexPath.row]["image"] as? String{

            let urlString = recipeImage
            let url = URL(string: urlString)
            
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error != nil {
                    print("Failed fetching image:", error)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("Not a proper HTTPURLResponse or statusCode")
                    return
                }
                
                DispatchQueue.main.async {
                    cell.recipeImage.image = UIImage(data: data!)
                }
                }.resume()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue( withIdentifier: "recipeView", sender: indexPath )
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! UINavigationController
        let recipeViewController = destination.topViewController as! RecipeViewController
        let indexPath = sender as! NSIndexPath
        recipeViewController.recipe = recipesArr[indexPath.row]
    }

}
