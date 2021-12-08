//
//  NotesView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 12/7/21.
//

import SwiftUI

struct NotesView: View {
	@Environment(\.dismiss) var dismiss
	@EnvironmentObject var dataModel: DataModel
	@ObservedObject var currentTire: TireEntity

	@State private var notes: String =  """
										Save notes on this set of tires.
										"""

	var body: some View {

		VStack {
			Text("\(currentTire.name!) Notes:")
				.font(.title)
			TextEditor(text: $notes)
				.multilineTextAlignment(.leading)
				.padding()
			Button("Save") {
				saveNotes()
			}
			.buttonStyle(.bordered)
			.buttonBorderShape(.roundedRectangle)


			Spacer()
		}
		.onAppear {
			loadNoteFor(tire: currentTire)
		}


	}

	private func loadNoteFor(tire: TireEntity) {
		notes = tire.notes ?? "No notes created for \(tire.name ?? "nil")"
	}

	private func saveNotes() {
		currentTire.notes = notes

		dataModel.saveToMOC()
		dismiss()
	}

}



//struct NotesView_Previews: PreviewProvider {
//    static var previews: some View {
//        NotesView()
//    }
//}
