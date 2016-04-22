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
    var dailyIncome : DailyIncome?
    var fetchRequest : NSFetchRequest?
    var indexPath : NSIndexPath?
    var flagEdit = false
    
    override func viewWillAppear(animated: Bool) {
        getCurrentShop(nil)
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
        if let dailyIncome = dailyIncome {
            getInformationIncome(dailyIncome)
        }
        //set tao action to hide keyboard
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSingeTap))
        tapRecognizer!.numberOfTapsRequired = 1
        let tomorrow = Date(date: NSDate(), addDay: 1)
        datePicker.maximumDate = tomorrow.getEndDate()
        
        //set tap action for Image View
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(DailyIncomeViewController.imageTapped(_:)))
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // segue to Image View Controller when tap image
    func imageTapped(image : AnyObject){
        let imageVC = storyboard?.instantiateViewControllerWithIdentifier("imageViewController") as! ImageViewController
        imageVC.image = imageView.image
        self.presentViewController(imageVC, animated: true, completion: nil)
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
    
    // format date to String
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
        if !flagEdit {
        let incomeDict : [String : AnyObject] = [
            DailyIncome.keys.date : date,
            DailyIncome.keys.income : Int(incomeText.text!)!,
            DailyIncome.keys.cardTip : Int(cardTipsText.text!)!,
            DailyIncome.keys.cashTip : Int(cashTipsText.text!)!,
            DailyIncome.keys.photo : ImageCache.sharedIntanse().getImage(self.imageView.image, date: self.date) ?? ""
        ]
        let income = DailyIncome(dailyIncomeDict: incomeDict, context: sharedContext)
        income.shops = self.shop
        self.tabBarController?.selectedIndex = 1
        resetField()
        saveContext()
        }else{
            do {
                var incomes = try sharedContext.executeFetchRequest(self.fetchRequest!) as? [DailyIncome]
                if incomes?.count >= 1 {
                    let income = incomes?[indexPath!.row]
                    income?.income = Int(incomeText.text!)!
                    income?.cardTip = Int(cardTipsText.text!)!
                    income?.cashTip = Int(cashTipsText.text!)!
                    income?.photo = ImageCache.sharedIntanse().getImage(self.imageView.image, date: self.date) ?? ""
                    saveContext()
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }catch{
                print(error)
            }
        }
    }
    
    
    @IBAction func cancel(sender: AnyObject) {
        if !flagEdit {
            resetField()
        }else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // reset every fields to default
    func resetField(){
        incomeText.text = "0"
        realIncomeLabel.text  = "0.0"
        cardTipsText.text = "0"
        cashTipsText.text = "0"
        imageView.image = nil
    }
    
    // Get information about current Shop with selected == true
    func getCurrentShop (nailShop : NailShop?){
        if let nailShop = nailShop{
            shopLabel.text = nailShop.nailShop
            percentLabel.text = "\(nailShop.percent)"
            shop = nailShop
            mainView.hidden = false
            pickShopLabel.hidden = true

        }else {
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
    }
    
    // remove photo from imageView
    @IBAction func deletePhoto(sender: AnyObject) {
        imageView.image = nil
    }
    
    lazy var sharedContext : NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managerObjectContext
    }()
    
    func saveContext(){
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    // protocols of textfied
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
    
    // protocols of textfied
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text!.isEmpty || textField.text == "0" {
            textField.text = ""
        }
    }
    
    //protocols of Image Picker
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // protoclos of Image Picke
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imageView.contentMode = .ScaleToFill
        imageView.image = image
        self.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // get Income from List to edit 
    func getInformationIncome(dailyIncome : DailyIncome!){
        incomeText.text = "\(dailyIncome.income)"
        let realIncomeLabel = Double(Int(dailyIncome!.income) * Int(dailyIncome.shops!.percent) / 100)
        self.realIncomeLabel.text = "\(realIncomeLabel)"
        cardTipsText.text = "\(dailyIncome.cardTip)"
        cashTipsText.text = "\(dailyIncome.cashTip)"
        if let photo = dailyIncome.photo {
            imageView.image = ImageCache.sharedIntanse().imageWithIdentifier(photo)
            print(photo)
        }
        self.title = "Edit"
        self.saveButton.setTitle("Edit'", forState: .Normal)
        getCurrentShop(dailyIncome.shops)
        flagEdit = true
    }
}
