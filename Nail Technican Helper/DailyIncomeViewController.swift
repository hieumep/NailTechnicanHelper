//
//  DailyIncomeViewController.swift
//  Nail Technican Helper
//
//  Created by Hieu Vo on 4/10/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import UIKit
import CoreData
import QuartzCore
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


@available(iOS 10.0, *)
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
    var date = Date()
    var shop :NailShop?
    var image : UIImage?
    var dailyIncome : DailyIncome?
    var fetchRequest: NSFetchRequest<DailyIncome> = DailyIncome.fetchRequest() as! NSFetchRequest<DailyIncome>
    var indexPath : IndexPath?
    var flagEdit = false
    var textUltilities = TextUtilities()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.iAdBannerAdView.center = CGPoint(
            x: view.frame.midX,
            y:  view.frame.height - appDelegate.iAdBannerAdView.frame.height / 2)
        view.addSubview(appDelegate.iAdBannerAdView)        
        
        appDelegate.adMobBannerAdView.rootViewController = self
        appDelegate.adMobBannerAdView.center = CGPoint(
            x: view.frame.midX,
            y: view.frame.height - appDelegate.adMobBannerAdView.frame.height / 2)
        view.addSubview(appDelegate.adMobBannerAdView)
        getCurrentShop(nil)        
        incomeText.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        addKeyboardDismissRecognizer()
        
    }
    
    func setDate(){
        let dateString = formatDate(Foundation.Date())
        dateButton.setTitle("\(dateString)", for: UIControlState())
        print(dateString)
        date = Foundation.Date()
        datePicker.date = date
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardDismissRecognizer()
     //   NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(setDate), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        self.canDisplayBannerAds = true
        cardTipsText.delegate = textFieldDelegate
        cashTipsText.delegate = textFieldDelegate
        pickShopLabel.text = " You don't setup Nail Shop yet, please tap EDIT to pick your current Nail Shop"
        if let dailyIncome = dailyIncome {
            getInformationIncome(dailyIncome)
        }else{
            setDate()
        }
        //set tao action to hide keyboard
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSingeTap))
        tapRecognizer!.numberOfTapsRequired = 1
        let tomorrow = DateConvenient(date: Date(), addDay: 1)
        datePicker.maximumDate = tomorrow.getEndDate()
        
        //set tap action for Image View
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(DailyIncomeViewController.imageTapped(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        //set layer for ImageView
        imageView.layer.borderWidth = 1.0
        imageView.layer.cornerRadius = 8.0
      //  imageView.layer.borderColor = CGColor(GL_GREEN)
        
    }
    
    // segue to Image View Controller when tap image
    func imageTapped(_ image : AnyObject){
        let imageVC = storyboard?.instantiateViewController(withIdentifier: "imageViewController") as! ImageViewController
        imageVC.image = imageView.image
        self.present(imageVC, animated: true, completion: nil)
    }
    
    func handleSingeTap(_ recognizer : UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    func addKeyboardDismissRecognizer() {
        self.view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        self.view.removeGestureRecognizer(tapRecognizer!)
    }
    
    @IBAction func dateFromDatePicker(_ sender: AnyObject) {
        let date = formatDate(datePicker.date)
        self.date = datePicker.date
        dateButton.setTitle("\(date)", for: UIControlState())
    }
    
    @IBAction func pickDate(_ sender: AnyObject) {
        flagDate = !flagDate
        datePicker.isHidden = flagDate
        dateLabel.isHidden = !flagDate
    }
    
    // format date to String
    func formatDate(_ date: Foundation.Date) -> String {
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale.current
        dateFormater.dateStyle = .full
        let dateString = dateFormater.string(from: date)
        return dateString
    }
    
    @IBAction func pickImageFromCamera(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromGallery(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
   
    @IBAction func saveIncome(_ sender: AnyObject) {
        if !flagEdit {
        let incomeDict : [String : AnyObject] = [
            DailyIncome.keys.date : date as AnyObject,
            DailyIncome.keys.income : textUltilities.stringToInt(incomeText.text!) as AnyObject,
            DailyIncome.keys.cardTip : textUltilities.stringToInt(cardTipsText.text!) as AnyObject,
            DailyIncome.keys.cashTip : textUltilities.stringToInt(cashTipsText.text!) as AnyObject,
            DailyIncome.keys.photo : ImageCache.sharedIntanse().getImage(self.imageView.image, date: self.date) as AnyObject? ?? "" as AnyObject
        ]
        let income = DailyIncome(dailyIncomeDict: incomeDict, context: sharedContext)
        income.shops = self.shop
        self.tabBarController?.selectedIndex = 1
        resetField()
        saveContext()
        }else{
            do {
                var incomes = try sharedContext.fetch(self.fetchRequest)
                if incomes.count >= 1 {
                    let income = incomes[(indexPath! as NSIndexPath).row]
                    income.date = date as NSDate
                    income.income = textUltilities.stringToInt(incomeText.text!) as NSNumber
                    income.cardTip = textUltilities.stringToInt(cardTipsText.text!) as NSNumber
                    income.cashTip = textUltilities.stringToInt(cashTipsText.text!) as NSNumber
                    income.photo = ImageCache.sharedIntanse().getImage(self.imageView.image, date: self.date) ?? ""
                    saveContext()
                    self.dismiss(animated: true, completion: nil)
                }
            }catch{
                print(error)
            }
        }
    }
    
    
    @IBAction func cancel(_ sender: AnyObject) {
        if !flagEdit {
            resetField()
        }else {
            self.dismiss(animated: true, completion: nil)
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
    func getCurrentShop (_ nailShop : NailShop?){
        if let nailShop = nailShop{
            shopLabel.text = nailShop.nailShop
            percentLabel.text = "\(nailShop.percent)"
            shop = nailShop
            mainView.isHidden = false
            pickShopLabel.isHidden = true

        }else {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NailShop")
            fetchRequest.predicate = NSPredicate(format: "selected==true")
            do {
               let shops = try sharedContext.fetch(fetchRequest) as? [NailShop]
                if shops?.count >= 1  {
                    shopLabel.text = shops![0].nailShop
                    percentLabel.text = "\(shops![0].percent)"
                    shop = shops![0]
                    mainView.isHidden = false
                    pickShopLabel.isHidden = true
                }else {
                    mainView.isHidden = true
                    pickShopLabel.isHidden = false
                    }
            }catch{
                print(error)
                abort()
            }
        }
    }
    
    // remove photo from imageView
    @IBAction func deletePhoto(_ sender: AnyObject) {
        imageView.image = nil
    }
    
    lazy var sharedContext : NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managerObjectContext
    }()
    
    func saveContext(){
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    // protocols of textfied
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !textField.text!.isEmpty {
            let percent = shop?.percent as! Int
            let realIncomeLabel = textUltilities.stringToInt(textField.text!) * percent / 100
            self.realIncomeLabel.text = textUltilities.stringToNumber(String(realIncomeLabel))
        } else {
            textField.text = "0.00"
            self.realIncomeLabel.text = "0.00"
        }
    }
    
       
    // protocols of textfied
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text!.isEmpty || textField.text == "0" {
            textField.text = ""
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var text : String = textField.text! + string
        if text.characters.count < 12 {
            var newText = text.replacingOccurrences(of: ".", with: "")
            if string == "" {
                newText = String(newText.characters.dropLast())
            }
            text = textUltilities.stringToNumber(newText)
            textField.text = text
        }
        return false
    }
    
    //protocols of Image Picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // protoclos of Image Picke
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imageView.contentMode = .scaleToFill
        imageView.image = image
        self.image = image
        dismiss(animated: true, completion: nil)
    }
    
    // get Income from List to edit 
    func getInformationIncome(_ dailyIncome : DailyIncome!){
        incomeText.text = textUltilities.stringToNumber(String(describing: dailyIncome.income))
        let realIncomeLabel = String((Int(dailyIncome!.income) * Int(dailyIncome.shops!.percent) / 100))
        self.realIncomeLabel.text = textUltilities.stringToNumber(realIncomeLabel)
        cardTipsText.text = textUltilities.stringToNumber(String(describing: dailyIncome.cardTip))
        cashTipsText.text = textUltilities.stringToNumber(String(describing: dailyIncome.cashTip))
        let dateString = formatDate((dailyIncome.date as NSDate) as Date)
        dateButton.setTitle("\(dateString)", for: UIControlState())
        if let photo = dailyIncome.photo {
            imageView.image = ImageCache.sharedIntanse().imageWithIdentifier(photo)
            print(photo)
        }
        self.title = "Edit"
        self.saveButton.setTitle("Edit", for: UIControlState())
        getCurrentShop(dailyIncome.shops)
        flagEdit = true
    }
    
    }
