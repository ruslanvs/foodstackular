//
//  RecipeViewController.swift
//  foodstackular
//
//  Created by Johnnie Tran on 3/20/18.
//  Copyright © 2018 Ruslan Suvorov. All rights reserved.
//

import UIKit
import CoreData

class RecipeViewController: UIViewController {
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    
    var recipe: NSDictionary?
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let rTitle = recipe!["title"] as? String{
                recipeTitle.text = rTitle
        }
        if let rInst = recipe!["instructions"] as? String{
            instructionsLabel.text = rInst
        }
        
        if let recipeImg = recipe!["image"] as? String{
            
            let urlString = recipeImg
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
                    self.recipeImage.image = UIImage(data: data!)
                }
                }.resume()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem ) {
        dismiss( animated: true, completion: nil )
    }
    
    
    @IBAction func addAllButtonPressed(_ sender: UIBarButtonItem) {
        if let ingredients = recipe!["extendedIngredients"] as? NSArray {
            for ingredient in ingredients{
                if let ingDict = ingredient as? NSDictionary{
                    let item = NSEntityDescription.insertNewObject(forEntityName: "Ingredient", into: managedObjectContext) as! Ingredient
                    
                    if let name = ingDict["name"] as? String {
                        item.name = name
                    }
                    if let quantity = ingDict["amount"] as? Double {
                        item.quantity = quantity
                    }
                    if let unit = ingDict["unit"] as? String {
                        item.unit = unit
                    }
                    if let imgUrl = ingDict["image"] as? String {
                        item.imgUrl = imgUrl
                    }
                    appDelegate.saveContext()
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
