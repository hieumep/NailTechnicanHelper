//
//  DailyIncomeViewController.swift
//  Nail Technican Helper
//
//  Created by Hieu Vo on 4/10/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import UIKit
import CoreData

class DailyIncomeViewController : UIViewController,UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var pickShopLabel: UILabel!
    @IBOutlet weak var shopLabel: UILabel!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mainView: UIStackView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var incomeText: UITextField!
    @IBOutlet weak var cardTipsText: UITextField!
    @IBOutlet weak var cashTipsText: UITextField!
    @IBOutlet weak var realIncomeLabel: UILabel!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    var flagDate  = true
    var tapRecognizer : UITapGestureRecognizer? = nil
    var textFieldDelegate = TextFieldDelegate()
    var date = NSDate()
    
    var shop :NailShop?
    var image : UIImage?
    
    override func viewWillAppear(animated: Bool) {
        getCurrentShop()
        let date = formatDate(NSDate())
        dateButton.setTitle("\(date)", forState: .Normal)
        incomeText.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        addKeyboardDismissRecognizer()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardDismissRecognizer()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        cardTipsText.delegate = textFieldDelegate
        cashTipsText.delegate = textFieldDelegate
        pickShopLabel.text = " You don't set up Nail Shop yet, please tap EDIT to pick your current Nail Shop"
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSingeTap))
        tapRecognizer!.numberOfTapsRequired = 1
    }
    
    func handleSingeTap(recognizer : UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    func addKeyboardDismissRecognizer() {
        self.view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        self.view.removeGestureRecognizer(tapRecognizer!)
    }
    
    @IBAction func dateFromDatePicker(sender: AnyObject) {
        let date = formatDate(datePicker.date)
        self.date = datePicker.date
        dateButton.setTitle("\(date)", forState: .Normal)
    }
    
    @IBAction func pickDate(sender: AnyObject) {
        flagDate = !flagDate
        datePicker.hidden = flagDate
        dateLabel.hidden = !flagDate
    }
    
    func formatDate(date: NSDate) -> String {
        let dateFormater = NSDateFormatter()
        dateFormater.locale = NSLocale.currentLocale()
        dateFormater.dateStyle = .FullStyle
        let dateString = dateFormater.stringFromDate(date)
        return dateString
    }
    
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromGallery(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
    }
   
    @IBAction func saveIncome(sender: AnyObject) {
        let incomeDict : [String : AnyObject] = [
            DailyIncome.keys.date : date,
            DailyIncome.keys.income : incomeText.text!,
            DailyIncome.keys.cardTip : cardTipsText.text!,
            DailyIncome.keys.cashTip : cashTipsText.text!,
            DailyIncome.keys.photo : String(self.image)
        ]
        let income = DailyIncome(dailyIncomeDict: incomeDict, context: sharedContext)
        income.shops = self.shop
        saveContext()
    }
    
    
    @IBAction func cancel(sender: AnyObject) {
    }
    
    func getCurrentShop (){
        let fetchRequest = NSFetchRequest(entityName: "NailShop")
        fetchRequest.predicate = NSPredicate(format: "selected==true")
        do {
           let shops = try sharedContext.executeFetchRequest(fetchRequest) as? [NailShop]
        if shops?.count >= 1  {
            shopLabel.text = shops![0].nailShop
            percentLabel.text = "\(shops![0].percent)"
            shop = shops![0]
            mainView.hidden = false
            pickShopLabel.hidden = true
        }else {
            mainView.hidden = true
            pickShopLabel.hidden = false
            }
        }catch{
            print(error)
            abort()
        }
    }
    
    lazy var sharedContext : NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managerObjectContext
    }()
    
    func saveContext(){
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if !textField.text!.isEmpty {
            let percent = shop?.percent as! Int
            let realIncomeLabel = Double(Int(textField.text!)! * percent/100)
            self.realIncomeLabel.text = "\(realIncomeLabel)"
        } else {
            textField.text = "0"
            self.realIncomeLabel.text = "0"
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text!.isEmpty || textField.text == "0" {
            textField.text = ""
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imageView.contentMode = .ScaleToFill
        imageView.image = image
        self.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
}
