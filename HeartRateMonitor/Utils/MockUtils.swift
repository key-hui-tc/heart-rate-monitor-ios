//
//  MockUtils.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 10/30/21.
//

import UIKit

struct MockUtils {
    static let pdfUrl = URL(string: "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf")!

    static let geneticResponse: GeneticResponse = {
        var arr = Array<GenotypeModel>()
        arr.append(GenotypeModel(name: "Adenine", symbol: "A"))
        arr.append(GenotypeModel(name: "Cytosine", symbol: "C"))
        arr.append(GenotypeModel(name: "Guanine", symbol: "G"))
        arr.append(GenotypeModel(name: "Thymine", symbol: "T"))
        arr.append(GenotypeModel(name: "Uracil", symbol: "U"))
        arr.append(GenotypeModel(name: "Weak", symbol: "W"))
        arr.append(GenotypeModel(name: "Strong", symbol: "S"))
        arr.append(GenotypeModel(name: "Amino", symbol: "M"))
        arr.append(GenotypeModel(name: "Ketone", symbol: "K"))
        arr.append(GenotypeModel(name: "Purine", symbol: "R"))
        arr.append(GenotypeModel(name: "Pyrimidine", symbol: "Y"))
        arr.append(GenotypeModel(name: "Not A", symbol: "B"))
        arr.append(GenotypeModel(name: "Not C", symbol: "D"))
        arr.append(GenotypeModel(name: "Not G", symbol: "H"))
        arr.append(GenotypeModel(name: "Not T", symbol: "V"))
        arr.append(GenotypeModel(name: "Any one base", symbol: "N"))
        arr.append(GenotypeModel(name: "Gap", symbol: "-"))
        // duplicate
        arr.append(contentsOf: arr)
        arr.shuffle()
        return GeneticResponse(genotypes: arr)
    }()
}
