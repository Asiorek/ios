//
//  ViewController.swift
//  joanna
//
//  Created by Użytkownik Gość on 13.10.2016.
//  Copyright © 2016 Użytkownik Gość. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
// MARK: Properties
    
    @IBOutlet weak var artistTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var genreTextField: UITextField!
    @IBOutlet weak var yearTextView: UITextField!
    
    @IBOutlet weak var numberRate: UILabel!

    @IBOutlet weak var buttonRates: UIStepper!
    @IBOutlet weak var buttonPrev: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var buttonDelete: UIButton!
    
    @IBOutlet weak var buttonNew: UIButton!
    
    @IBOutlet weak var numberRecord: UITextView!
    
    let plistCatPath=NSBundle.mainBundle().pathForResource("Albums", ofType: "plist")
    let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    let fileManager = NSFileManager.defaultManager()
    
    var albums: NSMutableArray=[]
    var albumsDocPath: String = ""
    
    var record:[String:AnyObject]=[:]
    var currentRecord: Int = 0
    
    deinit{
        writeFile()
    }
    
    func writeFile(){
        albums.writeToFile(albumsDocPath, atomically: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        albumsDocPath = documentsPath.stringByAppendingString("/Albums.plist")
        if !fileManager.fileExistsAtPath(albumsDocPath){
            try? fileManager.copyItemAtPath(plistCatPath!, toPath: albumsDocPath)
        }
        buttonPrev.enabled=false;
        buttonSave.enabled=false;
        albums = readFile()
        
        artistTextField.text=albums[currentRecord].valueForKey("artist") as? String
        titleTextField.text=albums[currentRecord].valueForKey("title") as? String
        genreTextField.text=albums[currentRecord].valueForKey("genre") as? String
        
        numberRate.text=String(albums[currentRecord].valueForKey("rating") as! Int)
    
        numberRecord.text="Record: \(currentRecord+1)/\(albums.count)"
    
    }
    
    func readFile()->NSMutableArray{
        return NSMutableArray(contentsOfFile:albumsDocPath)!
    }
    
// MARK: Actions
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showRecord(index:Int)->Void{
        artistTextField.text=albums[index].valueForKey("artist") as? String
        titleTextField.text=albums[index].valueForKey("title") as? String
        genreTextField.text=albums[index].valueForKey("genre") as? String
        
        numberRate.text=String(albums[index].valueForKey("rating") as! Int)
        yearTextView.text=String(albums[index].valueForKey("date") as! Int)
        numberRecord.text="Record: \(currentRecord+1)/\(albums.count)"
    }
    
    
    @IBAction func changeStepperRate(sender: UIStepper) {
        if  sender.value>5{
            sender.value=5
        }
        
        if sender.value<0{
            sender.value=0
        }
        buttonSave.enabled=true
        numberRate.text=String(Int(sender.value ))
    }
 
    
    @IBAction func clickBtnPrev(sender: UIButton) {
        currentRecord--
        
        if(currentRecord==0){
            sender.enabled=false
        }
        if(currentRecord<0){
            currentRecord=0
        }
        if currentRecord>albums.count{
            currentRecord=albums.count-1
        }
        if currentRecord < albums.count{
            showRecord(currentRecord)
        }

    }
    
    @IBAction func clickBtnNext(sender: UIButton) {
        currentRecord++
        
        if currentRecord>0{
            buttonPrev.enabled=true
        }
        if currentRecord==albums.count{
            titleTextField.text=""
            genreTextField.text=""
            yearTextView.text=""
            artistTextField.text=""
            numberRate.text=String(0)
            numberRecord.text="Record: \(currentRecord+1)/\(albums.count)"
//            buttonPrev.enabled=false
        }
        
        if currentRecord < albums.count{
            showRecord(currentRecord)
        }
        if currentRecord>albums.count{
            currentRecord=albums.count
        }
    }
    
    @IBAction func clickBtnSave(sender: UIButton) {
        let artistR = artistTextField.text ?? ""
        let genreR = genreTextField.text ?? ""
        let titleR = titleTextField.text ?? ""
        let yearR = Int(yearTextView.text!) ?? 0
        let ratingR = Int(numberRate.text!) ?? 0
        if currentRecord==albums.count{
            albums.addObject(["artist":artistR,"title":titleR,"genre":genreR,"date":yearR,"rating":ratingR])
            
        }
        
        if currentRecord >= 0 && currentRecord < albums.count {
            albums.replaceObjectAtIndex(currentRecord, withObject: ["artist":artistR,"title":titleR,"genre":genreR,"date":yearR,"rating":ratingR])
        }
        
        numberRecord.text="Record: \(currentRecord+1)/\(albums.count)"
    }
    
    func exit(){
        albums.writeToFile(albumsDocPath, atomically: true)
    }
    
    @IBAction func clickBtnDelete(sender: UIButton) {
        if albums.count == 1 {
            buttonPrev.enabled=false
            albums.removeObjectAtIndex(0)
            currentRecord=getCur(currentRecord-1)
            titleTextField.text=""
            genreTextField.text=""
            yearTextView.text=String(0)
            artistTextField.text=""
            numberRate.text=String(0)
            numberRecord.text="Record: \(currentRecord+1)/\(albums.count)"
        } else  if currentRecord < albums.count{
            albums.removeObjectAtIndex(currentRecord)
            currentRecord=getCur(currentRecord-1)
            showRecord(currentRecord)
        }

    }
    
    @IBAction func clickBtnNew(sender: UIButton) {
        currentRecord=albums.count
        titleTextField.text=""
        genreTextField.text=""
        yearTextView.text=String(0)
        artistTextField.text=""
        numberRate.text=String(0)
        numberRecord.text="Record: \(currentRecord+1)/\(albums.count)"
    }
    
    func getCur(index:Int)->Int{
        if index < 0 {
            return 0
        }
        if index > albums.count-1{
            return albums.count - 1
        }
        
        return index as Int
    }
    
    @IBAction func changeTxtYear(sender: UITextField) {
        buttonSave.enabled=true
    }
    
    @IBAction func changeTxtGenre(sender: UITextField) {
        buttonSave.enabled=true
    }
    
    @IBAction func changeTxtTitle(sender: UITextField) {
        buttonSave.enabled=true
    }
    
    @IBAction func changeTxtArtist(sender: AnyObject) {
         buttonSave.enabled=true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
}

