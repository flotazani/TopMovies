//
//  DataStorage.swift
//  TestTask-T-Systems
//
//  Created by Andrei Konovalov on 06.02.2020.
//  Copyright © 2020 Andrei Konovalov. All rights reserved.
//

import Foundation
import UIKit

struct MovieResult: Decodable{
  var page: Int?
  var results: [res]
}


struct res : Decodable {
  var poster_path: String?
  var release_date: String?
  var overview: String?
  var title: String?
  var vote_average: Double?
}
