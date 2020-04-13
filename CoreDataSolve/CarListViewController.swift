//
//  ViewController.swift
//  CoreDataSolve
//
//  Created by Mohammad Hamudeh on 3/16/20.
//  Copyright © 2020 Al-Quds University. All rights reserved.
//

import UIKit
import CoreData
class CarListViewController: UIViewController {
    var carList : [CarSales] = []
    @IBOutlet weak var carsTableView: UITableView!
    @IBOutlet weak var totalUnitesLabel: UILabel!
    @IBOutlet weak var totalSalesLabel: UILabel!
    //var carList : [CarSales] = []
    var sum : Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carsTableView.dataSource = self
        carsTableView.dataSource = self
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedObject = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CarSales")
        
        do{
            carList = try  managedObject.fetch(fetchRequest) as! [CarSales]
            self.carsTableView.reloadData()
            
           
        }catch{
            print(error.localizedDescription)
        }
        totalUnitesLabel.text = "\(carList.count)"
        for i in carList{
            print(i.salePrice)
            //sum += Double(i.salePrice!)!
        }
        totalSalesLabel.text = "\(sum)"
        // Do any additional setup after loading the view.
    }

    @IBAction func unWindSegue(segue:UIStoryboardSegue){
        let sourceVC = segue.source as? AddNewCarViewController
        let carItem = sourceVC?.carItem as! CarSales
        print(carItem)
        carList.append(carItem)
        carsTableView.insertRows(at: [IndexPath(row: carList.count - 1, section: 0)], with: .automatic)
        totalUnitesLabel.text = "\(carList.count)"
//        for i in carList{
//            sum += Double(i.salePrice!)!
//        }
        totalSalesLabel.text = "\(sum)"
    }
}
extension CarListViewController :UITableViewDataSource,UITableViewDelegate{
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "carCell", for: indexPath) as! carTableViewCell
        cell.carBrand.text = carList[indexPath.row].brand
        cell.carModel.text = carList[indexPath.row].model
        cell.carPrice.text = carList[indexPath.row].salePrice
        return cell
       }
}

