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
	@EnvironmentObject var dataModel: DataModel

	@FocusState private var fieldIsFocused: Bool

	@State private var installDate = Date()
	@State private var removalDate = Date()

	@State private var name = ""
	@State private var installMilage = ""
	@State private var removalMilage = ""
	@State private var seasonType: TireType = .allSeason
	@State private var tireStatus: TireStatus = .inStorage

	@State private var isShowingAlert = false

	let currentTire: TireEntity
	let tireLogic = TireMileageLogic()

	var body: some View {
		ScrollView {

			VStack {
				Text("Edit Tyre")
					.font(.largeTitle)
				TextField(currentTire.name ?? "Name", text: $name, prompt: nil)
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
					Text("In Storage").tag(TireStatus.inStorage)
					Text("On Vehicle").tag(TireStatus.onVehicle)
				}.pickerStyle(.segmented)
					.padding(.vertical)

				DatePicker("Removal Date", selection: $removalDate, displayedComponents: .date)
					.opacity(tireStatus == .onVehicle ? 0.25 : 1.0)
					.disabled(tireStatus == .onVehicle)

				Text("Enter Mileage Values")
					.font(.headline)
					.padding()

				Group {
					TextField("Install Mileage", text: $installMilage, prompt: Text("Installation Mileage"))
					TextField("Removal Mileage", text: $removalMilage, prompt: Text("Removal Mileage"))

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
						tireLogicCheck()
					} label: {
						Text("Save")
							.foregroundColor(.white)
					}
					.buttonStyle(.borderedProminent)
					.disabled(removalMilage.isEmpty && tireStatus == .inStorage)
					// Disabled to prevent poor UX logic.
					.padding()
					.alert("Mileage Entry Error", isPresented: $isShowingAlert) {
						Button(role: .cancel) {
							removalMilage = ""
						} label: {
							Text("I'll Fix It!")
						}
					} message: {
						Text(tireLogic.errorMessage)
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
		seasonType = checkTireSeason(type: loadedTireSeason)
		tireStatus = loadTireLocation(status: loadedTireStatus)
		installDate = loadedInstallDate
		removalDate = loadedRemovalDate
		installMilage = String(loadedInstallMilage)
		removalMilage = String(loadedRemovalMilage)

	}

	// Takes the enum used to create the tire when it was initially saved, and works it backwards.
	private func checkTireSeason(type: String) -> TireType {
		switch type {
			case "Summer":
				return .summer
			case "All Season":
				return .allSeason
			case "Winter":
				return .winter
			default:
				return .allSeason
		}
	}

	private func loadTireLocation(status: Bool) -> TireStatus {
		// To set value of Picker when loading this Edit View.
		switch status {
			case true:
				return .inStorage
			case false:
				return .onVehicle
		}
	}

	private func saveTireLocation(status: TireStatus) -> Bool {
		// To save the proper boolean value to CoreData
		switch status {
			case .onVehicle:
				return false
			case .inStorage:
				return true
		}
	}

	private func tireLogicCheck() {
		// MARK: Duplicated in AddNewTire View
		isShowingAlert = tireLogic.checkLogicalMileageValues(install: installMilage, removal: removalMilage, status: tireStatus)

		if !isShowingAlert {
			save()
		}
	}


	private func save() {
		currentTire.name = name
		currentTire.seasonType = seasonType.rawValue
		currentTire.isInStorage = saveTireLocation(status: tireStatus)
		currentTire.installDate = installDate
		currentTire.removalDate = removalDate
		// CoreData model defines these values as Int16
		currentTire.installMiles = Int16(installMilage) ?? 0
		currentTire.removalMiles = Int16(removalMilage) ?? 0

		dataModel.saveToMOC()

		// Dismiss View
		dismiss()
	}

	private func checkLogicalMileageEntered(install: Double, removal: Double) {
		
	}


}

#if DEBUG
struct EditTireView_Previews: PreviewProvider {
    static var previews: some View {
		Text("Test View")
    }
}
#endif
