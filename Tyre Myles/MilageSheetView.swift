//
//  MilageSheetView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/19/21.
//

import SwiftUI

struct MilageSheetView: View {
	@Environment(\.dismiss) var dismiss

	@Binding var installMilage: String
	@Binding var removalMilage: String
	@Binding var totalMilage: String

	var body: some View {
		VStack {
						Spacer()
			Text("Enter Milage Values")
				.font(.headline)
				.padding()
			Group {
				TextField("Install Milage", text: $installMilage, prompt: Text("Installation Milage"))
				TextField("Removal Milage", text: $removalMilage, prompt: Text("Removal Milage"))
			}
			.textFieldStyle(.roundedBorder)
			.padding([.leading, .trailing], 50)

			HStack {
				Button(role: .cancel) {
					dismiss()
				} label: {
					Text("Cancel")
						.foregroundColor(.red)
				}.buttonStyle(.automatic)

				Button {
					calculateTotalMilesFrom(install: installMilage, to: removalMilage)
				} label: {
					Text("Save")
				}.buttonStyle(.borderedProminent)
					.padding()
			}

			Spacer()
		}
	}

	private func calculateTotalMilesFrom(install: String, to removal: String) {
		var result = 0

		guard let installMilageInt = Int(install) else { return }
		guard let removalMilageInt = Int(removal) else { return }

		result = removalMilageInt - installMilageInt

		totalMilage = String(result)

		dismiss()
	}
}

struct MilageSheetView_Previews: PreviewProvider {
    static var previews: some View {
		MilageSheetView(installMilage: .constant("3000"), removalMilage: .constant("7000"), totalMilage: .constant("4000"))
    }
}
