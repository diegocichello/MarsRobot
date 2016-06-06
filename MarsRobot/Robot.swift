//
//  Robot.swift
//  MarsRobot
//
//  Created by Diego Cichello on 6/5/16.
//  Copyright © 2016 DiegoCo. All rights reserved.
//

import UIKit

internal enum Messages : String {
    case ROBOT_COLLISION = "Robo irá colidir com outro robo"
    case PLATEAU_FALL = "Robo irá sair do plateau"
    case PARALYZED_ROBOT = " Robo paralizado por possivel colisão"
}
enum Instruction : Character {
    case Esquerda = "E"
    case Direita = "D"
    case Andar = "A"
}

class Robot: NSObject {

    var direction : Direction
    var x : Int
    var y : Int
    var instructions: [Instruction]
    var errorMessage = ""

    init(coordinatesString: String, instructions: String) {
        let coordinates = coordinatesString.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        self.x = Int(coordinates[0])!
        self.y = Int(coordinates[1])!
        self.direction = Direction(rawValue:Character(coordinates[2]))!
        self.instructions = Array()
        for instruction in instructions.characters {
            self.instructions.append(Instruction(rawValue: instruction)!)
        }
    }

    func changeDirectionTo(instruction: Instruction) {
        if instruction == .Direita {
            switch direction {
            case .Norte: direction = .Leste
            case .Leste: direction = .Sul
            case .Sul: direction = .Oeste
            case .Oeste: direction = .Norte
            }
        } else if instruction == .Esquerda {
            switch direction {
            case .Norte: direction = .Oeste
            case .Oeste: direction = .Sul
            case .Sul: direction = .Leste
            case .Leste: direction = .Norte
            }
        }
    }

    func walkInPlateau(plateau: Plateau) -> Bool {
        let currentX = x
        let currentY = y

        var collision = false
        var collisionMessage = ""

        plateau.linhas[x][y] = 0
        switch direction {
        case .Norte:
            if (plateau.linhas[x].count <= y+1) {
                collision = true
                collisionMessage = Messages.PLATEAU_FALL.rawValue
            } else if (plateau.linhas[x][y+1] == 1){
                collision = true
                collisionMessage = Messages.ROBOT_COLLISION.rawValue
            } else {
                y = y+1
            }
        case .Oeste:
            if (x-1 < 0) {
                collision = true
                collisionMessage = Messages.PLATEAU_FALL.rawValue
            } else if (plateau.linhas[x-1][y] == 1){
                collision = true
                collisionMessage = Messages.ROBOT_COLLISION.rawValue
            } else {
                x = x-1
            }
        case .Sul:
            if (y-1 < 0) {
                collision = true
                collisionMessage = Messages.PLATEAU_FALL.rawValue
            } else if (plateau.linhas[x][y-1] == 1) {
                collision = true
                collisionMessage = Messages.ROBOT_COLLISION.rawValue
            } else {
                y = y-1
            }
        case .Leste:
            if (plateau.linhas.count <= x+1) {
                collision = true
                collisionMessage = Messages.PLATEAU_FALL.rawValue
            } else if (plateau.linhas[x+1][y] == 1){
                collision = true
                collisionMessage = Messages.ROBOT_COLLISION.rawValue
            } else {
                x = x+1
            }
        }
        if collision {
            print(collisionMessage)
            errorMessage = Messages.PARALYZED_ROBOT.rawValue
        } else {
            plateau.linhas[currentX][currentY] = 0
            plateau.linhas[x][y] = 1
        }

        return collision


    }
}


