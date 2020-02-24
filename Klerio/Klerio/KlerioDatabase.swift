//
//  KlerioDatabase.swift
//  Klerio
//
//  Created by Swapnil Jagtap on 22/02/20.
//  Copyright © 2020 Swapnil Jagtap. All rights reserved.
//

import Foundation

protocol Database {
    func save(event: EventModel)
    func delete(event: EventModel)
}

final class KlerioDatabase: Database {
    //TODO: implement this
    func save(event: EventModel){}
    func delete(event: EventModel){}
}
