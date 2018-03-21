//
//  ShoppingCartTableViewController.swift
//  foodstackular
//
//  Created by Johnnie Tran on 3/20/18.
//  Copyright © 2018 Ruslan Suvorov. All rights reserved.
//

import UIKit
import CoreData

class ShoppingCartTableViewController: UITableViewController {
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    var cart = [Ingredient]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAll()
        tableView.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchAll(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Ingredient")
        do {
            let result = try managedObjectContext.fetch(request)
            cart = result as! [Ingredient]
            print ( cart )
        } catch {
            print( error )
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let item = cart[indexPath.row]
        managedObjectContext.delete(item)
        appDelegate.saveContext()
        cart.remove(at: indexPath.row)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartCell
        
        if let ingName = cart[indexPath.row].name as? String {
            cell.ingredientLabel.text = ingName
        }
        
        if let ingQ = cart[indexPath.row].quantity as? Double {
            cell.amountLabel.text = String(ingQ)
            
        }
        if let ingU = cart[indexPath.row].unit as? String {
            let stringName = cell.amountLabel.text! + ingU
            cell.amountLabel.text = stringName
        }
        
        if let recipeImg = cart[indexPath.row].imgUrl as? String{
            
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
                    cell.ingredientImage.image = UIImage(data: data!)
                }
                }.resume()
        }



        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
