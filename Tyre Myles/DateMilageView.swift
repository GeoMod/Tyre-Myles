//
//  DateMilageView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/19/21.
//

import SwiftUI


struct DateMilageView: View {
	@EnvironmentObject var dataModel: DataModel
	@ObservedObject var currentTire: TireEntity

	@State private var isEditingDetails = false
	@State private var totalMilage = "---"

	@State private var tireStatus: TireStatus = .inStorage

	private let installed = "Installed"
	private let removed = "Removed"
	private let onVehicle = "On Vehicle"

	var body: some View {
		VStack(alignment: .leading) {
			HStack(alignment: .firstTextBaseline) {
				Text(installed)
					.font(.title3.bold())
			}
			HStack {
				Text("Date:")
				Text(currentTire.installDate ?? Date(), style: .date)
			}

			HStack {
				Text("Mileage:")
				Text(String(currentTire.installMiles))
			}

			Group {
				Text(currentTire.isInStorage == true ? removed : onVehicle)
					.font(.title3.bold())
					.padding(.top)
				HStack {
					Text("Date:")
					Text(currentTire.removalDate ?? Date(), style: .date)
				}
				HStack {
					Text("Mileage:")
						.padding(.trailing)
					Text(String(currentTire.removalMiles))
						.padding(.leading, -10)
				}
			}.opacity(currentTire.isInStorage == true ? 1.0 : 0.25)

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
				totalMiles(installation: currentTire.installMiles, removal: currentTire.removalMiles)
			} content: {
				EditTireView(currentTire: currentTire)
			}

	}


	private func totalMiles(installation: Int64, removal: Int64) {
		// Int64 because that is how it's defined in the CoreData model.
		let total = removal - installation

		if !currentTire.isInStorage {
			// Tires are on vehicle.
			totalMilage = onVehicle
		} else if total > 0 {
			totalMilage = String(total)
		}
	}


}

//struct DateMilageView_Previews: PreviewProvider {
//    static var previews: some View {
//		DateMilageView()
//			.preferredColorScheme(.dark)
//    }
//}
