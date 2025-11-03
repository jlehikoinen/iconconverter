//
//  CliApp.swift
//  iconconverter
//
//  Created by Janne Lehikoinen on 30.10.2025.
//

import Foundation
import ArgumentParser

@main
struct Iconconverter: AsyncParsableCommand {
    
    static var configuration = CommandConfiguration(
        abstract: "Command line tool for converting icon formats.",
        discussion: """
            See README.md for more info.
            """,
        version: "0.1",
        subcommands: [
            Convert.self
        ]
    )
}
