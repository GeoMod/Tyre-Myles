//
//  DateSheetView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/19/21.
//

import SwiftUI

struct EditTireView: View {
	@Environment(\.dismiss) var dismiss
	@EnvironmentObject var dataModel: DataModel

	@Binding var installDate: Date
	@Binding var removalDate: Date

	@Binding var installMilage: String
	@Binding var removalMilage: String
	@Binding var totalMilage: String

	var body: some View {
		VStack {
			Text("Enter Date Values")
				.font(.headline)
				.padding()
			DatePicker("Install Date", selection: $installDate, displayedComponents: .date)
			DatePicker("Removal Date", selection: $removalDate, displayedComponents: .date)

			Text("Enter Milage Values")
				.font(.headline)
				.padding()

			Group {
				TextField("Install Milage", text: $installMilage, prompt: Text("Installation Milage"))
				TextField("Removal Milage", text: $removalMilage, prompt: Text("Removal Milage"))
			}
			.keyboardType(.numberPad)
			.textFieldStyle(.roundedBorder)

			HStack {
				// As of 10/19/21 both buttons do the same thing.
				Button(role: .cancel) {
					dismiss()
				} label: {
					Text("Cancel")
						.foregroundColor(.red)
				}.buttonStyle(.automatic)

				Button {
//					calculateTotalMilesFrom(install: installMilage, to: removalMilage)
					dataModel.saveTireProfileWith(name: "New", season: .summer, installMiles: installMilage, removalMiles: removalMilage, installDate: installDate, removallDate: removalDate)
				} label: {
					Text("Save")
						.foregroundColor(.white)
				}.buttonStyle(.borderedProminent)
					.padding()
			}

		}
		.padding()
	}


}


struct EditTireView_Previews: PreviewProvider {
	// 3 days into the future
	static let future = Date(timeIntervalSinceNow: 259200)

    static var previews: some View {
		EditTireView(installDate: .constant(Date()), removalDate: .constant(future), installMilage: .constant("0"), removalMilage: .constant("23000"), totalMilage: .constant("23000"))
    }
}
