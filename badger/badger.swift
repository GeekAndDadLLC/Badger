//
//  main.swift
//  badger
//
//  Created by Dad @GeekAndDad on 2/8/23.
//
// All exceptions are hacked and should be cleaned up.
// This is a proof-of concept, and I feel like there should be a higher level API
// that could be used, but haven't gone to figure out what it might be.
//
// The last digits of the git sha for the branch being built is a good candidate
// for the overlay string.  Write an Xcode build script get that and then call this
// tool, perhaps.
//

import Foundation

import ArgumentParser
import CoreFoundation
import CoreGraphics
import CoreText
import ImageIO
import UniformTypeIdentifiers

@main
struct Badger: ParsableCommand {
	@Argument(help: "The string to draw over the image; a short, non-empty string is required.")
	var badgeString: String

	@Option(name: .shortAndLong, help: "The image file path for the icon.",
			  completion: .file(), transform: URL.init(fileURLWithPath:))
	var inputFile: URL
	
	@Option(name: .shortAndLong, help: "The file path to save the output to.",
			  completion: .file(), transform: URL.init(fileURLWithPath:))
	var outputFile
	
	@Option(name: .shortAndLong,
			help: "Name of the font to use; default is Courier. Optional.")
	var fontName: String = "Courier"
	
	@Option(name: [.customShort("s"), .customLong("size")],
			help: "Size of font to use. default is 24. Optional.")
	var fontSize: Double = 24	// ???
	
	@Option(name: .shortAndLong, help: "text position x coordinate. Optional.")
	var xOffset: Double = 10
	
	@Option(name: .shortAndLong, help: "text position y coordinate. Optional.")
	var yOffset: Double = 10
	
	@Flag(name: .shortAndLong, help: "extra logging.")
	var verbose: Bool = false
}

extension Badger {
	mutating func run() throws {
		if verbose { print("running badger") }
		
		guard !badgeString.isEmpty,
			  try inputFile.checkResourceIsReachable() == true,
			  outputFile.isFileURL == true
		else {
			throw NSError(domain: "CoreGraphics",
						  code: Int(CGError.illegalArgument.rawValue),
						  userInfo: [NSLocalizedDescriptionKey: "Input argument invalid"])
		}

		guard let imageSource = CGImageSourceCreateWithURL(inputFile as NSURL, nil),
			  let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
		else {
			throw NSError(domain: "CoreGraphics",
						  code: Int(CGError.illegalArgument.rawValue),
						  userInfo: [NSLocalizedDescriptionKey: "Failed to create Image Source or Image"])
		}
		
		guard let context = CGContext(data: nil,
									  width: image.width,
									  height: image.height,
									  bitsPerComponent: image.bitsPerComponent,
									  bytesPerRow: 0,
									  space: image.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!,
									  bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
		else {
			throw NSError(domain: "CoreGraphics",
						  code: Int(CGError.invalidContext.rawValue),
						  userInfo: [NSLocalizedDescriptionKey: "Failed to create CGContext"])
		}
		
		context.draw(image,
					 in: CGRect(origin: .zero,
								size: CGSize(width: image.width, height: image.height)))
		
		let font = CTFontCreateWithName(fontName as CFString, fontSize, nil)

		let attributes: [CFString:Any] = [
			kCTFontAttributeName: font,
			kCTForegroundColorFromContextAttributeName: true
		]
		
		guard let cfString = CFAttributedStringCreate(nil,
													  badgeString as CFString,
													  attributes as CFDictionary)
		else {
			throw NSError(domain: "CoreFoundation", code: -1)
		}
		
		let line = CTLineCreateWithAttributedString(cfString)
		
		context.textMatrix = .identity
		context.setTextDrawingMode(CGTextDrawingMode.fill)
		context.setBlendMode(.copy)
		
		// TODO: let user pass in the color
		context.setFillColor(CGColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0))
		
		context.textPosition = CGPoint(x: xOffset, y: yOffset)
		
		CTLineDraw(line, context);
		
		guard let cgImage = context.makeImage(),
			  let imageDestination = CGImageDestinationCreateWithURL(
				outputFile as CFURL,
				UTType.png.identifier as CFString,
				1,
				nil)
		else {
			throw NSError(domain: "CoreGraphics", code: Int(CGError.failure.rawValue))
		}
		
		CGImageDestinationAddImage(imageDestination, cgImage, nil)
		if !CGImageDestinationFinalize(imageDestination) {
			throw NSError(domain: "", code: Int(CGError.failure.rawValue))
		}
		
		if verbose { print("done") }
	}
}
