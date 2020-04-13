//
//  AddNewCarViewController.swift
//  CoreDataSolve
//
//  Created by Mohammad Hamudeh on 3/16/20.
//  Copyright © 2020 Al-Quds University. All rights reserved.
//

import UIKit

class AddNewCarViewController: UIViewController {

   lazy var cars : [String:[String]] = ["Mercedes":["A Class","B Class", "C Class", "E Class", "S Class", "X Class", "GLA", "GLB", "CLE", "GLS"], "BMW": [ "X1","X2", "X3","X4","X5","X6","X7"]]
    
    
    @IBOutlet weak var sliderValueLabel: UILabel!
    // 2 tables
    // brandsTable brandId -primaryKey  brandName
    //modelTable modelID primary , modelName, brandID FK
    // select * from BrandsTable
    // select * from modelTable where brandId == brandsTable.brandID
    var carSelectedBrand = ""
    var carSelectedModel = ""
    @IBOutlet weak var productionYearPickerView: UIPickerView!
    @IBOutlet weak var brandBtn: UIButton!
    @IBOutlet weak var modelBtn: UIButton!
    @IBOutlet weak var productionYearTF: UITextField!
    @IBOutlet weak var engineNumberTf: UITextField!
    @IBOutlet weak var ownerPhoneTF: UITextField!
    @IBOutlet weak var ownerNameTF: UITextField!
    @IBOutlet weak var sellDate: UITextField!
    @IBOutlet weak var sellPrice: UITextField!
    @IBOutlet weak var bodyNumberTF: UITextField!
    var carItem : CarSales!
    var dataPicker =  UIDatePicker()
    var yearsPickerView = UIPickerView()
    var toolbar = UIToolbar()
    var soldDate:Date!
    var pickerData:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareDatePicker()
        preparePickerView()
        prepareToolbar()
        productionYearPickerView.dataSource = self
        productionYearPickerView.delegate = self
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        var startDate = dateFormatter.date(from: "1970")
        while startDate! <=  Date(){
            pickerData.append(dateFormatter.string(from: startDate!))
            startDate = Calendar.current.date(byAdding: .year, value: 1, to: startDate!)
        }
        
    }
    func prepareDatePicker(){
        dataPicker.maximumDate = Date()
        dataPicker.datePickerMode = .date
        sellDate.inputView = dataPicker
    }
    func preparePickerView(){
        yearsPickerView.delegate = self
        yearsPickerView.dataSource = self
        productionYearTF.inputView = yearsPickerView
    }
    func prepareToolbar(){
        toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donBtnSelcted(sender:)))
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBtnPressed(sender:)))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([cancel,space,done], animated: true)
        sellDate.inputAccessoryView = toolbar
        productionYearTF.inputAccessoryView = toolbar
        
    }
    @objc func donBtnSelcted(sender:UIBarButtonItem){
        if productionYearTF.isFirstResponder{
            productionYearTF.text =  pickerData[yearsPickerView.selectedRow(inComponent: 0)]
            bodyNumberTF.becomeFirstResponder()
        }else if sellDate.isFirstResponder{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        soldDate = dataPicker.date
            sellDate.text = formatter.string(from: dataPicker.date)
            
        }
    }
    @objc func cancelBtnPressed(sender: UIBarButtonItem){
        view.endEditing(true)
    }
    @IBAction func brandBtnPressed(_ sender: Any) {
        var brandList = Array(cars.keys)
        
        let alert = UIAlertController(title: "Brands", message: nil, preferredStyle: .actionSheet)
        for i in brandList{
            alert.addAction(UIAlertAction(title: i, style: .default, handler: { (action) in
                self.carSelectedBrand = i
                self.brandBtn.setTitle(i, for: .normal)
                self.modelBtn.setTitle("Select Model", for: .normal)
                alert.dismiss(animated: true, completion: nil)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBAction func modelBtnPressed(_ sender: Any) {
       
        selectCarModel()
        
    }
    func selectCarModel(){
        let carModels : [String] = Array(cars[carSelectedBrand]!)
               let alert = UIAlertController(title: "Models", message: nil, preferredStyle: .actionSheet)
               for i in carModels{
                   alert.addAction(UIAlertAction(title: i, style: .default, handler: { (action) in
                       self.carSelectedModel = i
                       self.modelBtn.setTitle(i, for: .normal)
                       alert.dismiss(animated: true, completion: nil)
                   }))
               }
               alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                   alert.dismiss(animated: true, completion: nil)
               }))
               self.present(alert, animated: true, completion: nil)
               
    }
    
    @IBAction func addNewCarBtnPressed(_ sender: Any) {
        print("inside Btn")
        if modelBtn.titleLabel?.text == "Select Model"{
                   let errorAlert = UIAlertController(title: "Select Model", message: "You have to select car model", preferredStyle: .alert)
            
            errorAlert.addAction(UIAlertAction(title: "ok", style: .destructive, handler: { (action) in
                       self.selectCarModel()
                   }))
            self.present(errorAlert, animated: true, completion: nil)
        }else{
            performSegue(withIdentifier: "unwindSegue", sender: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedObject = appDelegate.persistentContainer.viewContext
        carItem =  CarSales(context: managedObject)
        carItem.bodyNumber = bodyNumberTF.text
        carItem.brand = carSelectedBrand
        carItem.engineNumber = engineNumberTf.text
        carItem.model = carSelectedModel
        carItem.owner = ownerNameTF.text
        carItem.ownerPhoneNumber = ownerPhoneTF.text
        carItem.sellDate = soldDate
        carItem.productionYear = productionYearTF.text
        carItem.salePrice = sellPrice.text
        do{
            try managedObject.save()
            
        }catch{
            print(error.localizedDescription)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func sliderTest(_ sender: UISlider) {
        sliderValueLabel.text = "\(Int(sender.value))"
    }
}
extension AddNewCarViewController:UIPickerViewDataSource,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var numOfRows = 0
        if component == 0 {
            numOfRows = pickerData.count
        }
        return numOfRows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        if component == 0{
            return pickerData[row]
        }else{
            return ""
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        productionYearTF.text =  pickerData[row]
    }
    
}
