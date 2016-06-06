//
//  ViewController.swift
//  MarsRobot
//
//  Created by Diego Cichello on 6/5/16.
//  Copyright © 2016 DiegoCo. All rights reserved.
//

import UIKit

enum Direction: Character {
    case Norte = "N"
    case Sul = "S"
    case Leste = "L"
    case Oeste = "O"
}

class Plateau: NSObject {
    var linhas: [[Int]]

    init(height: Int, width: Int) {
        linhas = [[Int]]()
        for _ in 0...height {
        var linha = [Int]()
            for _ in 0...width {
                linha.append(0)
            }
        linhas.append(linha)
        }
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let file = "input.txt"
        let text = "10 10\n1 2 N\nEAEAEAEAA\n6 4 N\nEAEADDAA\n3 3 L\nAADAADADDA"
        let inputString : String

        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(file)
            do {
                try text.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
            }
            catch {}
            do {
                inputString = try NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding) as String
                print(inputString)
                readInputAndPerformInstructions(inputString)
            }
            catch {}
        }
    }

    func readInputAndPerformInstructions(input: String) {
        let lines = breakInputIntoLines(input)
        let plateau = createPlateau(lines[0])
        let robots = addRobotsToPlateau(lines,plateau: plateau)
        performRobotInstructionsInPlateau(robots, plateau: plateau)
        let output = createOutput(robots)
        writeOutputToFile(output)
    }

    //pure functions
    func breakInputIntoLines(input: String) -> [String] {
        return input.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
    }

    func createPlateau(string: String) -> Plateau {
        let plateauCoordinates = string.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        return Plateau(height: Int(plateauCoordinates[0])!,width: Int(plateauCoordinates[1])!)
    }

    func addRobotsToPlateau(lines: [String], plateau: Plateau) -> [Robot]
    {
        var robots = [Robot]()
        for i in 0...(lines.count - 3)/2 {
            let robot = Robot(coordinatesString: lines[2*i+1], instructions: lines[2*i+2])
            plateau.linhas[robot.x][robot.y] = 1
            robots.append(robot)
        }
        return robots
    }

    func performRobotInstructionsInPlateau(robots : [Robot], plateau: Plateau) {
        var collision = false
        for robot in robots {
            for instruction in robot.instructions {
                switch instruction {
                case .Direita:
                    robot.changeDirectionTo(.Direita)
                case .Esquerda:
                    robot.changeDirectionTo(.Esquerda)
                case .Andar:
                    collision = (robot.walkInPlateau(plateau))
                    if collision {break}
                }
                if collision{break}
            }
            if collision {break}
        }

    }

    func createOutput(robots: [Robot]) -> String {
        var output = ""
        for robot in robots {
            output = output.stringByAppendingString(String(robot.x)) + " "
            output = output.stringByAppendingString(String(robot.y)) + " "
            output.append(robot.direction.rawValue)
            output = output.stringByAppendingString(String(robot.errorMessage))
            output = output.stringByAppendingString("\n")
        }
        return output;
    }

    func writeOutputToFile(output: String) {

        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let file = "output.txt"
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(file)

            do {
                try output.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
            }
            catch {}

            do {
                let outputString = try NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding) as String
                print(outputString)
            }
            catch {}
        }
    }
}

