//
//  CompletionsView.swift
//  WaterThePlants
//
//  Created by Oliver Harvey on 19/11/2020.
//

import SwiftUI

struct CompletionsView: View {
    var task: Task
    @Binding var dummy: Bool
    
    var body: some View {
        HStack {
            ForEach(0..<5) { comp in
                Image(systemName: imageNameFor(comp))
            }
        }

    }
    func imageNameFor(_ comp: Int) -> String {
        if comp + 1 > task.lastCompletions.count {
            return "circle"
        } else if task.lastCompletions[comp] {
            return "checkmark.circle"
        } else {
            return "x.circle"
        }
    }
}

