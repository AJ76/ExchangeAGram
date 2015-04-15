//
//  ViewController.swift
//  ExchangeAGram
//
//  Created by Alan Platsky on 4/14/15.
//  Copyright (c) 2015 Alan Platsky. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreData

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var feedArray: [AnyObject] = []
    
    @IBAction func snapBarButtonTapped(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            var cameraController = UIImagePickerController()
            cameraController.delegate = self
            cameraController.sourceType = UIImagePickerControllerSourceType.Camera
            
            let mediaTypes:[AnyObject] = [kUTTypeImage]
            cameraController.mediaTypes = mediaTypes
            cameraController.allowsEditing = false
            
            presentViewController(cameraController, animated: true, completion: nil)
        }
        
        else if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            
            var photoLibraryController = UIImagePickerController()
            
            photoLibraryController.delegate = self
            photoLibraryController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            let mediaTypes:[AnyObject] = [kUTTypeImage]
            
            photoLibraryController.mediaTypes = mediaTypes
            photoLibraryController.allowsEditing = false
            
            presentViewController(photoLibraryController, animated: true, completion: nil)
        }
        
        else {
            
            var alertController = UIAlertController(title: "Alert", message: "Your device does not support the camera or photo Library", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            
            presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    
    //UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let entityDescription = NSEntityDescription.entityForName("FeedItem", inManagedObjectContext: managedObjectContext!)
        
        let feedItem = FeedItem(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
        
        feedItem.image = imageData
        feedItem.caption = "test caption"
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
        
        feedArray.append(feedItem)
        
        self.collectionView.reloadData()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = NSFetchRequest(entityName: "FeedItem")
        let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDelegate.managedObjectContext!
        
        feedArray = context.executeFetchRequest(request, error: nil)!
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView:UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return feedArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell: FeedCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! FeedCell
        
        let thisItem = feedArray[indexPath.row] as! FeedItem
        
        cell.imageView.image = UIImage(data: thisItem.image)
        cell.captionLabel.text = thisItem.caption
    
        return cell
    }
    


}

