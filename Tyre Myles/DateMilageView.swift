//
//  DateMilageView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/19/21.
//

import SwiftUI


struct DateMilageView: View {
	@ObservedObject var currentTire: TireEntity

	@State private var isEditingDetails = false
	@State private var totalMilage = "---"


	var body: some View {
		VStack(alignment: .leading) {
			HStack(alignment: .firstTextBaseline) {
				Text("Intallation")
					.font(.title3.bold())
			}
			HStack {
				Text("Date:")
				Text(currentTire.installDate ?? Date(), style: .date)
			}

			HStack {
				Text("Milage:")
				Text(String(format: "%.0f", currentTire.installMiles))
			}

			Text("Removal")
				.font(.title3.bold())
				.padding([.top])
			HStack {
				Text("Date:")
				Text(currentTire.removalDate ?? Date(), style: .date)
			}
			HStack {
				Text("Milage:")
					.padding(.trailing)
				Text(String(format: "%.0f", currentTire.removalMiles))
					.padding(.leading, -10)
			}
			HStack {
				Text("Total Tyre Myles")
					.bold()

				Spacer()

				Text(totalMilage)
					.underline()
					.foregroundColor(.blue)
					.padding([.top, .bottom])
					.onTapGesture {
						isEditingDetails.toggle()
					}
			}.font(.title2)
		}.font(.footnote.monospaced())
			.onAppear {
				totalMiles(installation: currentTire.installMiles, removal: currentTire.removalMiles)
			}

			.sheet(isPresented: $isEditingDetails) {
				// on dismiss
				print("Sheet is dismissed.")
			} content: {
				EditTireView(currentTire: currentTire)
			}

	}


	@MainActor private func totalMiles(installation: Double, removal: Double) {
		let total = removal - installation
		if total > 0 {
			totalMilage = String(Int(total))
		} else {
			totalMilage = "On Vehicle"
		}
	}

	

}

//struct DateMilageView_Previews: PreviewProvider {
//    static var previews: some View {
//		DateMilageView()
//			.preferredColorScheme(.dark)
//    }
//}
