//
//  SplashViewController.swift
//  wisdom-leaf
//
//  Created by Kibbcom on 25/06/24.
//

import UIKit

class SplashViewController: UIViewController {
@IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
          super.viewDidLoad()
          // Set up the splash screen with an image in the center
          view.backgroundColor = .white
      }

      override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(animated)
          
          // Navigate to the table view after 5 seconds
          DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
              let storyboard = UIStoryboard(name: "Main", bundle: nil)
              let tableViewController = storyboard.instantiateViewController(withIdentifier: "TableViewController")
              self.navigationController?.pushViewController(tableViewController, animated: true)
          }
      }
  }
