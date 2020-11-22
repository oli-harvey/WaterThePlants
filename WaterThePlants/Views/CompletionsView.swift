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
            ForEach(0..<maxTimes()) { comp in
                Image(systemName: imageNameFor(comp))
                    .foregroundColor(dummy ? colorFor(comp) : colorFor(comp))
            }
        }
        .padding()
       

    }
    
    func maxTimes() -> Int {
        return min(5,Int(task.repetitions))
    }
    
    func imageNameFor(_ comp: Int) -> String {
        if comp + 1 > task.lastCompletions.count {
            return "circle"
        } else if task.lastCompletions[comp] {
            return "checkmark.circle"
        } else {
            return "multiply.circle"
        }
    }
    
    func colorFor(_ comp: Int) -> Color {
        if comp + 1 > task.lastCompletions.count {
            return .gray
        } else if task.lastCompletions[comp] {
            return .green
        } else {
            return .red
        }
    }
}
