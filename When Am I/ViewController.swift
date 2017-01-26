//
//  ViewController.swift
//  When Am I
//
//  Created by Orlando G. Rodriguez on 1/19/17.
//  Copyright © 2017 Orlando G. Rodriguez. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var date = Date()
    let calendar = Calendar.current

//    @IBOutlet weak var label_Latitude: UILabel!
    @IBOutlet weak var label_Longitude: UILabel!
    @IBOutlet weak var label_RealTime: UILabel!
    @IBOutlet weak var label_ClockTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleLocationServices()
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in 
            self.UI_UpdateLabels()
            
        })
        UI_UpdateLabels()
    }
    
    func handleLocationServices() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func UI_UpdateLabels() {
        if CLLocationManager.locationServicesEnabled() {
            //label_Latitude.text = String(Double((self.locationManager.location?.coordinate.latitude)!))
            label_Longitude.text = String(Double((self.locationManager.location?.coordinate.longitude)!))
            label_RealTime.text = handleRealTime()
            
        }
        let time = handleTime()
        label_ClockTime.text = time
    }
    
    func handleTime() -> (String) {
        date = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let out:String = formatter.string(from: date)
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: ({
            let timeArc = UIBezierPath(arcCenter: CGPoint(x: 187,y: 333), radius: CGFloat(120), startAngle: CGFloat((M_PI * -0.5)), endAngle:CGFloat((M_PI * -0.5) + (2 * M_PI) * (Double(minutes % 60) / 60.0) - 0.0000001), clockwise: true)
            let oppositeArc = UIBezierPath(arcCenter: CGPoint(x: 187,y: 333), radius: CGFloat(120), startAngle: CGFloat((M_PI * -0.5)), endAngle:CGFloat((M_PI * -0.5) + (2 * M_PI) * (Double(minutes % 60) / 60.0) - 0.0000001), clockwise: false)
        
            let shapeLayer = CAShapeLayer()
            let shapeLayerOpposite = CAShapeLayer()
            shapeLayer.path = timeArc.cgPath
            shapeLayerOpposite.path = oppositeArc.cgPath
            //change the fill color
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = UIColor.white.cgColor
            shapeLayer.lineWidth = 10.0
            self.view.layer.addSublayer(shapeLayer)
            
            shapeLayerOpposite.fillColor = UIColor.clear.cgColor
            shapeLayerOpposite.strokeColor = UIColor.white.cgColor
            shapeLayerOpposite.lineWidth = 11.0
            //self.view.layer.addSublayer(shapeLayerOpposite)
            
        }), completion: nil)
        
        print(seconds)
        return out
    }
    
    func handleRealTime() -> (String) {
        let gmtDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT:0)
        let offset = calculateOffsetTime(longitude: Double((self.locationManager.location?.coordinate.longitude)!))
        let calendar = Calendar.current
        let offsetdate = calendar.date(byAdding: .second, value: Int(offset), to: gmtDate)
        
        let hour = calendar.component(.hour, from: offsetdate!)
        let minutes = calendar.component(.minute, from: offsetdate!)
        let seconds = calendar.component(.second, from: offsetdate!)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: ({
            let timeArc = UIBezierPath(arcCenter: CGPoint(x: 187,y: 333), radius: CGFloat(130), startAngle: CGFloat((M_PI * -0.5)), endAngle:CGFloat((M_PI * -0.5) + (2 * M_PI) * (Double(minutes % 60) / 60.0) - 0.0000001), clockwise: true)
            let oppositeArc = UIBezierPath(arcCenter: CGPoint(x: 187,y: 333), radius: CGFloat(130), startAngle: CGFloat((M_PI * -0.5)), endAngle:CGFloat((M_PI * -0.5) + (2 * M_PI) * (Double(minutes % 60) / 60.0) - 0.0000001), clockwise: false)
            
            let shapeLayer = CAShapeLayer()
            let shapeLayerOpposite = CAShapeLayer()
            shapeLayer.path = timeArc.cgPath
            shapeLayerOpposite.path = oppositeArc.cgPath
            //change the fill color
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = UIColor.white.cgColor
            shapeLayer.lineWidth = 5.0
            self.view.layer.addSublayer(shapeLayer)
            
            shapeLayerOpposite.fillColor = UIColor.clear.cgColor
            shapeLayerOpposite.strokeColor = UIColor.white.cgColor
            shapeLayerOpposite.lineWidth = 6.0
            //self.view.layer.addSublayer(shapeLayerOpposite)
            
        }), completion: nil)
        
        
        return formatter.string(from: offsetdate!)
    }
    
    func calculateOffsetTime(longitude:Double) -> (Double) {
        return (longitude / 15) * 3600
    }
    
    func minutesFromSeconds(seconds:Int) -> (Int) {
        return seconds / 60
    }
    
    func hoursFromSeconds(seconds:Int) -> (Int) {
        return seconds / 3600
    }
    
    
}

