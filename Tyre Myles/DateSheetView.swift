//
//  DateSheetView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/19/21.
//

import SwiftUI

struct DateSheetView: View {
	@Environment(\.dismiss) var dismiss

	@Binding var installDate: Date
	@Binding var removalDate: Date

    var body: some View {
		VStack {
			Text("Enter Date Values")
				.font(.headline)
				.padding()
			DatePicker("Install Date", selection: $installDate, displayedComponents: .date)
			DatePicker("Removal Date", selection: $removalDate, displayedComponents: .date)

			HStack {
				// As of 10/19/21 both buttons do the same thing.
				// in the future I'd like this to save to CoreData for iCloud sync to macOS app.
				Button(role: .cancel) {
					dismiss()
				} label: {
					Text("Cancel")
						.foregroundColor(.red)
				}.buttonStyle(.automatic)

				Button {
					dismiss()
				} label: {
					Text("Save")
				}.buttonStyle(.borderedProminent)
					.padding()
			}

		}.padding()
    }


}


struct DateSheetView_Previews: PreviewProvider {
	// 3 days into the future
	static let future = Date(timeIntervalSinceNow: 259200)

    static var previews: some View {
		DateSheetView(installDate: .constant(Date()), removalDate: .constant(future))
    }
}
