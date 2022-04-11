//
//  DateSheetView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/19/21.
//

import SwiftUI
import CoreData

struct EditTireView: View {
	@Environment(\.dismiss) var dismiss
	
	@EnvironmentObject var dataModel: CoreDataModel
	@EnvironmentObject var tireViewModel: TyreViewModel

	@State private var installDate = Date()
	@State private var removalDate = Date()

	@State private var name = ""
	@State private var installMilage: Double = 0
	@State private var removalMilage: Double = 0
	@State private var seasonType: TireType = .allSeason
	@State private var tireStatus: TireStatus = .inStorage

	@FocusState private var fieldIsFocused: Bool

	let currentTire: TireEntity

	var body: some View {
		ScrollView {

			VStack {
				Text("Edit Tyre")
					.font(.largeTitle)
				TextField(currentTire.name ?? "Name", text: $name, prompt: Text("Name"))
					.textFieldStyle(.roundedBorder)
				Picker("Season", selection: $seasonType) {
					Text("Summer")
						.tag(TireType.summer)
					Text("All Season")
						.tag(TireType.allSeason)
					Text("Winter")
						.tag(TireType.winter)
				}
				.padding([.leading, .trailing])
				.pickerStyle(.segmented)

				Text("Enter Date Values")
					.font(.headline)
					.padding()
				DatePicker("Install Date", selection: $installDate, displayedComponents: .date)

				Picker("Wheel Status", selection: $tireStatus) {
					Text("On Vehicle").tag(TireStatus.onVehicle)
					Text("In Storage").tag(TireStatus.inStorage)
				}.pickerStyle(.segmented)
					.padding(.vertical)

				DatePicker("Removal Date", selection: $removalDate, in: installDate..., displayedComponents: .date)
					.opacity(tireStatus == .onVehicle ? 0.25 : 1.0)
					.disabled(tireStatus == .onVehicle)

				Text("Enter Mileage Values")
					.font(.headline)
					.padding()

				Group {
					TextField("Installation Mileage", value: $installMilage, format: .number)
					TextField("Removal Mileage", value: $removalMilage, format: .number)
				}
				.keyboardType(.numberPad)
				.textFieldStyle(.roundedBorder)

				HStack {
					Button(role: .cancel) {
						dismiss()
					} label: {
						Text("Cancel")
							.foregroundColor(.red)
					}.buttonStyle(.automatic)

					Button {
						checkTireMileageValues()
					} label: {
						Text("Save")
							.foregroundColor(.white)
					}
					.buttonStyle(.borderedProminent)
					.disabled(removalMilage == 0 && tireStatus == .inStorage)
					// Disabled to prevent poor UX logic.
					.padding()
					.alert("Mileage Entry Error", isPresented: $tireViewModel.isShowingAlert) {
						Button(role: .cancel) {
							removalMilage = 0
						} label: {
							Text("OK")
						}
					} message: {
						Text(tireViewModel.errorMessage)
					}
				}

			}
			.padding()
			.onAppear {
				loadInitialValues()
			}

		} // End ScrollView

	}

	private func loadInitialValues() {
		guard let loadedName = currentTire.name else { return }
		guard let loadedInstallDate = currentTire.installDate else { return }
		guard let loadedRemovalDate = currentTire.removalDate else { return }
		guard let loadedTireSeason = currentTire.seasonType else { return }
		let loadedTireStatus = currentTire.isInStorage
		let loadedInstallMilage = currentTire.installMiles
		let loadedRemovalMilage = currentTire.removalMiles

		name = loadedName
		seasonType = tireViewModel.checkSeason(type: loadedTireSeason)
		tireStatus = tireViewModel.loadTireLocation(status: loadedTireStatus)
		installDate = loadedInstallDate
		removalDate = loadedRemovalDate
		installMilage = loadedInstallMilage
		removalMilage = loadedRemovalMilage

	}


	private func checkTireMileageValues() {
		tireViewModel.checkLogicalMileageValues(install: installMilage, removal: removalMilage, status: tireStatus)

		if !tireViewModel.isShowingAlert {
			save()
		}
	}


	private func save() {
		currentTire.name = name
		currentTire.seasonType = seasonType.rawValue
		currentTire.isInStorage = tireViewModel.saveTireLocation(status: tireStatus)
		currentTire.installDate = installDate
		currentTire.removalDate = removalDate

		// CoreData model defines these values as Double
		currentTire.installMiles = installMilage
		currentTire.removalMiles = removalMilage

		dataModel.saveToMOC()

		// Dismiss View
		dismiss()
	}


}

#if DEBUG
struct EditTireView_Previews: PreviewProvider {
    static var previews: some View {
		Text("Test View")
    }
}
#endif
