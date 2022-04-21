//
//  NotesView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 12/7/21.
//

import SwiftUI

struct NotesView: View {
	@Environment(\.dismiss) var dismiss
	@EnvironmentObject var dataModel: CoreDataModel

	@ObservedObject var currentTire: TireEntity

	@State private var notes: String =  ""

	let defaultNote = "Save notes for this set of tires."

	var body: some View {

		VStack {
			Text("\(currentTire.name!) Notes:")
				.font(.title)
			// Empty note view
			Text(defaultNote)
				.font(.title3)
				.opacity(notes.isEmpty ? 0.4 : 0)
				.animation(.easeIn(duration: 0.3), value: notes.isEmpty)

			TextEditor(text: $notes)
				.multilineTextAlignment(.leading)
				.padding()

			Button("Save") {
				saveNotes()
			}
			.buttonStyle(.bordered)
			.buttonBorderShape(.roundedRectangle)

			Spacer()
		}.onAppear {
			loadNoteFor(tire: currentTire)
		}

	}

	private func loadNoteFor(tire: TireEntity) {
		notes = tire.notes ?? ""
	}

	private func saveNotes() {
		currentTire.notes = notes

		dataModel.saveToMOC()
		dismiss()
	}

}


#if DEBUG
struct NotesView_Previews: PreviewProvider {
	static let defaultNote = "Save notes for this set of tires."

	@State static var notes = ""

    static var previews: some View {
		VStack {
			Text("Tyre Notes:")
				.font(.title)
			// Empty note view
			Text(defaultNote)
				.font(.title3)
				.opacity(notes.isEmpty ? 0.4 : 0)

			TextEditor(text: $notes)
				.multilineTextAlignment(.leading)
				.padding()
			Button("Save") {
//				saveNotes()
			}
			.buttonStyle(.bordered)
			.buttonBorderShape(.roundedRectangle)


			Spacer()
		}
		.preferredColorScheme(.dark)
    }
}
#endif
